import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import '../models/models.dart';

// Video call request model
class VideoCallRequest {
  final String patientId;
  final String patientName;
  final String channelName;
  final String symptoms;
  final DateTime timestamp;

  VideoCallRequest({
    required this.patientId,
    required this.patientName,
    required this.channelName,
    required this.symptoms,
    required this.timestamp,
  });
}

class DoctorProvider with ChangeNotifier {
  Doctor? _currentDoctor;
  List<Patient> _patientQueue = [];
  List<VideoCallRequest> _pendingCallRequests = [];
  bool _isLoading = false;
  int _todaysCallsCount = 0;
  String? _authToken;
  IO.Socket? _socket;

  // Backend API URL
  static const String _baseUrl = 'http://192.168.1.7:5002/api';
  static const String _socketUrl = 'http://192.168.1.7:5002';

  Doctor? get currentDoctor => _currentDoctor;
  List<Patient> get patientQueue => _patientQueue;
  List<VideoCallRequest> get pendingCallRequests => _pendingCallRequests;
  bool get isLoading => _isLoading;
  int get todaysCallsCount => _todaysCallsCount;
  int get waitingPatientsCount => _patientQueue.length;
  String? get authToken => _authToken;

  // Real login with backend
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('Doctor Login Attempt: $email');
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'loginId': email,
          'password': password,
          'userType': 'doctor',
        }),
      );

      print('Doctor Login Response Status: ${response.statusCode}');
      print('Doctor Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _authToken = data['data']['token'];
          _currentDoctor = Doctor.fromJson(data['data']['user']);

          // Load doctor's queue and today's calls
          await _loadDoctorData();

          // Initialize socket connection for real-time updates
          _initializeSocket();

          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Login error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Load doctor's queue and statistics
  Future<void> _loadDoctorData() async {
    if (_currentDoctor == null || _authToken == null) return;

    try {
      // Get doctor's queue
      final queueResponse = await http.get(
        Uri.parse('$_baseUrl/doctors/${_currentDoctor!.id}/queue'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (queueResponse.statusCode == 200) {
        final queueData = json.decode(queueResponse.body);
        if (queueData['success']) {
          _patientQueue = (queueData['queue'] as List)
              .map((patient) => Patient.fromJson(patient))
              .toList();
        }
      }

      // Get today's consultation count
      final statsResponse = await http.get(
        Uri.parse('$_baseUrl/doctors/${_currentDoctor!.id}/stats/today'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (statsResponse.statusCode == 200) {
        final statsData = json.decode(statsResponse.body);
        if (statsData['success']) {
          _todaysCallsCount = statsData['todayConsultations'] ?? 0;
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error loading doctor data: $e');
    }
  }

  // Refresh queue from backend
  Future<void> refreshQueue() async {
    await _loadDoctorData();
  }

  // Update doctor availability status
  Future<void> updateAvailability(bool isAvailable) async {
    if (_currentDoctor == null || _authToken == null) return;

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/doctors/${_currentDoctor!.id}/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: json.encode({
          'isAvailable': isAvailable,
          'status': isAvailable ? 'online' : 'offline',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _currentDoctor = Doctor.fromJson(data['doctor']);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error updating availability: $e');
    }
  }

  void setCurrentDoctor(Doctor doctor) {
    _currentDoctor = doctor;
    notifyListeners();
  }

  void setPatientQueue(List<Patient> patients) {
    _patientQueue = patients;
    notifyListeners();
  }

  void addPatientToQueue(Patient patient) {
    _patientQueue.add(patient);
    notifyListeners();
  }

  void removePatientFromQueue(String patientId) {
    _patientQueue.removeWhere((patient) => patient.id == patientId);
    notifyListeners();

    // Also update backend
    _removePatientFromBackend(patientId);
  }

  void updatePatientStatus(String patientId, String status) {
    final index = _patientQueue.indexWhere(
      (patient) => patient.id == patientId,
    );
    if (index != -1) {
      // Create new patient with updated status
      final patient = _patientQueue[index];
      _patientQueue[index] = Patient(
        id: patient.id,
        name: patient.name,
        profileImage: patient.profileImage,
        age: patient.age,
        gender: patient.gender,
        phone: patient.phone,
        email: patient.email,
        symptoms: patient.symptoms,
        appointmentTime: patient.appointmentTime,
        status: status,
      );
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Logout with backend API call
  Future<void> logout() async {
    try {
      // Call logout API to set doctor status to offline
      if (_authToken != null) {
        print('Calling logout API to set doctor status offline...');
        final response = await http.post(
          Uri.parse('$_baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_authToken',
          },
        );

        print('Logout API Response Status: ${response.statusCode}');
        print('Logout API Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error during logout API call: $e');
    }

    // Clear local data regardless of API call result
    _currentDoctor = null;
    _patientQueue.clear();
    _todaysCallsCount = 0;
    _authToken = null;

    // Disconnect socket if connected
    _socket?.disconnect();
    _socket = null;

    notifyListeners();
  }

  void incrementTodaysCallsCount() {
    _todaysCallsCount++;
    notifyListeners();
  }

  Future<void> _removePatientFromBackend(String patientId) async {
    if (_authToken == null) return;

    try {
      await http.delete(
        Uri.parse('$_baseUrl/queue/$patientId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );
    } catch (e) {
      print('Error removing patient from queue: $e');
    }
  }

  // Remove mock data - we now use real data from backend

  /// Add test patient for testing video call functionality
  void addTestPatient() {
    final testPatient = Patient(
      id: '68c2cf5e3f1d8dc55cabdd9f', // Real patient ID from the app
      name: 'Shaurya (Test Patient)',
      profileImage: 'https://avatar.iran.liara.run/public/boy?username=shaurya',
      age: 25,
      gender: 'Male',
      phone: '9026508435',
      email: '9026508435@telemed.local',
      symptoms: 'Testing video call functionality',
      appointmentTime: DateTime.now(),
      status: 'waiting',
      medicalHistory: ['No major medical history'],
      attachments: [],
    );

    _patientQueue.insert(0, testPatient); // Add at the beginning
    notifyListeners();
    print('✅ Added test patient: ${testPatient.name} to doctor queue');
  }

  /// Test socket communication by simulating patient join queue event
  void testSocketPatientJoin() {
    if (_socket == null || !_socket!.connected) {
      print('❌ Socket not connected - cannot test');
      return;
    }

    // Simulate receiving a join_queue event
    print('🧪 Testing socket communication...');

    // Test data to simulate what patient app sends
    final testData = {
      'patientId': 'test_patient_socket_123',
      'patientName': 'Socket Test Patient',
      'symptoms': 'Testing socket join queue event',
      'timestamp': DateTime.now().toIso8601String(),
    };

    print('🧪 Simulating join_queue event with data: $testData');

    // Manually trigger the handler as if we received the event
    _handlePatientJoinQueue(testData);
  }

  /// Add multiple dummy patients for testing with comprehensive data including attachments
  void addDummyPatients() {
    final dummyPatients = [
      Patient(
        id: 'patient_001',
        name: 'Rajesh Kumar',
        profileImage:
            'https://avatar.iran.liara.run/public/boy?username=rajesh',
        age: 45,
        gender: 'Male',
        phone: '+91-9876543210',
        email: 'rajesh.kumar@email.com',
        symptoms:
            'Chronic back pain for 2 weeks, difficulty in walking, pain radiates to left leg',
        appointmentTime: DateTime.now().subtract(const Duration(minutes: 5)),
        status: 'waiting',
        medicalHistory: [
          'Diabetes Type 2 (2018)',
          'Hypertension (2020)',
          'Previous back surgery (2019)',
          'Regular medication: Metformin, Lisinopril'
        ],
        attachments: [
          'X-Ray_Lumbar_Spine_2024.pdf',
          'Blood_Test_Results_Sept2024.pdf',
          'MRI_Report_Lower_Back.pdf',
          'Previous_Prescription_Aug2024.jpg'
        ],
      ),
      Patient(
        id: 'patient_002',
        name: 'Priya Sharma',
        profileImage:
            'https://avatar.iran.liara.run/public/girl?username=priya',
        age: 32,
        gender: 'Female',
        phone: '+91-8765432109',
        email: 'priya.sharma@email.com',
        symptoms:
            'Persistent headaches, nausea, blurred vision for past 3 days',
        appointmentTime: DateTime.now().add(const Duration(minutes: 10)),
        status: 'waiting',
        medicalHistory: [
          'Migraine episodes since 2020',
          'Anxiety disorder (2021)',
          'No known allergies',
          'Regular medication: Sumatriptan as needed'
        ],
        attachments: [
          'CT_Scan_Head_Sept2024.pdf',
          'Eye_Examination_Report.pdf',
          'Neurologist_Consultation_Aug2024.pdf',
          'Symptom_Diary_3Days.jpg'
        ],
      ),
      Patient(
        id: 'patient_003',
        name: 'Mohammed Ali',
        profileImage:
            'https://avatar.iran.liara.run/public/boy?username=mohammed',
        age: 28,
        gender: 'Male',
        phone: '+91-7654321098',
        email: 'mohammed.ali@email.com',
        symptoms:
            'Fever 102°F, cough with phlegm, body aches, fatigue for 4 days',
        appointmentTime: DateTime.now().add(const Duration(minutes: 25)),
        status: 'waiting',
        medicalHistory: [
          'No chronic conditions',
          'Seasonal allergies',
          'Previous COVID-19 infection (2022)',
          'Fully vaccinated'
        ],
        attachments: [
          'Temperature_Chart_4Days.jpg',
          'COVID_Test_Result_Negative.pdf',
          'Chest_X_Ray_Current.pdf'
        ],
      ),
      Patient(
        id: 'patient_004',
        name: 'Sunita Devi',
        profileImage:
            'https://avatar.iran.liara.run/public/girl?username=sunita',
        age: 58,
        gender: 'Female',
        phone: '+91-6543210987',
        email: 'sunita.devi@email.com',
        symptoms: 'Joint pain in knees and hands, morning stiffness, swelling',
        appointmentTime: DateTime.now().add(const Duration(minutes: 40)),
        status: 'waiting',
        medicalHistory: [
          'Rheumatoid Arthritis (2015)',
          'Osteoporosis (2020)',
          'Hypothyroidism (2018)',
          'Regular medication: Methotrexate, Levothyroxine, Calcium supplements'
        ],
        attachments: [
          'Rheumatology_Report_Sept2024.pdf',
          'Joint_X_Rays_Hands_Knees.pdf',
          'Blood_Work_RA_Factor.pdf',
          'Bone_Density_Scan_2024.pdf',
          'Current_Medications_List.jpg'
        ],
      ),
      Patient(
        id: 'patient_005',
        name: 'Amit Patel',
        profileImage: 'https://avatar.iran.liara.run/public/boy?username=amit',
        age: 35,
        gender: 'Male',
        phone: '+91-5432109876',
        email: 'amit.patel@email.com',
        symptoms:
            'Chest discomfort, shortness of breath during exercise, palpitations',
        appointmentTime: DateTime.now().add(const Duration(hours: 1)),
        status: 'waiting',
        medicalHistory: [
          'Family history of heart disease',
          'High cholesterol (2022)',
          'Sedentary lifestyle',
          'Smoker (10 cigarettes/day)',
          'Regular medication: Atorvastatin'
        ],
        attachments: [
          'ECG_Report_Current.pdf',
          'Stress_Test_Results.pdf',
          'Lipid_Profile_Sept2024.pdf',
          'Cardiology_Consultation.pdf',
          'Exercise_Tolerance_Test.pdf'
        ],
      ),
      Patient(
        id: 'patient_006',
        name: 'Neha Gupta',
        profileImage: 'https://avatar.iran.liara.run/public/girl?username=neha',
        age: 26,
        gender: 'Female',
        phone: '+91-4321098765',
        email: 'neha.gupta@email.com',
        symptoms:
            'Irregular menstrual cycles, weight gain, acne, excessive hair growth',
        appointmentTime:
            DateTime.now().add(const Duration(hours: 1, minutes: 15)),
        status: 'waiting',
        medicalHistory: [
          'PCOS diagnosed 2023',
          'No other medical conditions',
          'Family history of diabetes',
          'Taking oral contraceptives'
        ],
        attachments: [
          'Ultrasound_Pelvis_Sept2024.pdf',
          'Hormone_Panel_Results.pdf',
          'Gynecology_Consultation.pdf',
          'Menstrual_Cycle_Chart.jpg'
        ],
      ),
      Patient(
        id: 'patient_007',
        name: 'Ramesh Singh',
        profileImage:
            'https://avatar.iran.liara.run/public/boy?username=ramesh',
        age: 62,
        gender: 'Male',
        phone: '+91-3210987654',
        email: 'ramesh.singh@email.com',
        symptoms:
            'Frequent urination, excessive thirst, unexplained weight loss',
        appointmentTime:
            DateTime.now().add(const Duration(hours: 1, minutes: 30)),
        status: 'waiting',
        medicalHistory: [
          'Pre-diabetes (2022)',
          'Hypertension (2020)',
          'Family history of Type 2 diabetes',
          'Regular medication: Amlodipine, Aspirin'
        ],
        attachments: [
          'HbA1c_Test_Results.pdf',
          'Fasting_Glucose_Levels.pdf',
          'Kidney_Function_Tests.pdf',
          'Diabetic_Eye_Screening.pdf',
          'Nutritionist_Diet_Plan.pdf'
        ],
      ),
    ];

    // Add all dummy patients to the queue
    _patientQueue.addAll(dummyPatients);
    _patientQueue
        .sort((a, b) => a.appointmentTime.compareTo(b.appointmentTime));

    notifyListeners();
    print(
        '✅ Added ${dummyPatients.length} dummy patients with comprehensive medical data to doctor queue');
  }

  /// Initialize socket connection for real-time queue updates
  void _initializeSocket() {
    if (_currentDoctor == null) return;

    try {
      _socket = IO.io(_socketUrl, <String, dynamic>{
        'transports': ['websocket'],
        'query': {'doctorId': _currentDoctor!.id, 'token': _authToken},
      });

      _socket!.connect();

      _socket!.onConnect((_) {
        print('📡 Doctor provider connected to socket server');
        // Join doctor room to receive queue updates
        _socket!.emit('join_doctor_room', {'doctorId': _currentDoctor!.id});
      });

      _socket!.onDisconnect((_) {
        print('📡 Doctor provider disconnected from socket server');
      });

      // Listen for patients joining queue
      _socket!.on('join_queue', (data) {
        print('📋 Patient joining queue: $data');
        print('📋 Current doctor ID: ${_currentDoctor!.id}');
        _handlePatientJoinQueue(data);
      });

      // Listen for patients leaving queue
      _socket!.on('leave_queue', (data) {
        print('📋 Patient leaving queue: $data');
        _handlePatientLeaveQueue(data);
      });

      // Listen for video call requests from patients
      _socket!.on('patient_start_call', (data) {
        print('📞 Incoming video call request: $data');
        _handleIncomingVideoCall(data);
      });

      // Listen for patients ending calls
      _socket!.on('patient_end_call', (data) {
        print('📞 Patient ended call: $data');
        _handlePatientEndCall(data);
      });

      print('✅ Socket initialized for doctor ${_currentDoctor!.name}');
    } catch (e) {
      print('❌ Error initializing socket: $e');
    }
  }

  /// Handle patient joining queue via socket
  void _handlePatientJoinQueue(Map<String, dynamic> data) {
    try {
      final patientId = data['patientId'];
      final patientName = data['patientName'] ?? 'Unknown Patient';
      final symptoms = data['symptoms'] ?? 'No symptoms provided';

      // Create patient object
      final patient = Patient(
        id: patientId,
        name: patientName,
        profileImage:
            'https://avatar.iran.liara.run/public/boy?username=$patientId',
        age: 0,
        gender: '',
        phone: '',
        email: '',
        symptoms: symptoms,
        appointmentTime: DateTime.now(),
        status: 'waiting',
        medicalHistory: [],
        attachments: [],
      );

      // Check if patient is already in queue
      bool alreadyInQueue = _patientQueue.any((p) => p.id == patientId);
      if (!alreadyInQueue) {
        _patientQueue.add(patient);
        notifyListeners();
        print('✅ Added patient ${patient.name} to queue');
      }
    } catch (e) {
      print('❌ Error handling patient join queue: $e');
    }
  }

  /// Handle patient leaving queue via socket
  void _handlePatientLeaveQueue(Map<String, dynamic> data) {
    try {
      final patientId = data['patientId'];
      _patientQueue.removeWhere((patient) => patient.id == patientId);
      notifyListeners();
      print('✅ Removed patient $patientId from queue');
    } catch (e) {
      print('❌ Error handling patient leave queue: $e');
    }
  }

  /// Handle incoming video call request from patient
  void _handleIncomingVideoCall(Map<String, dynamic> data) {
    try {
      final patientId = data['patientId'];
      final patientName = data['patientName'];
      final channelName = data['channelName'];
      final symptoms = data['symptoms'] ?? 'No symptoms provided';
      final timestamp = data['timestamp'];

      print('📞 Incoming video call from $patientName (ID: $patientId)');
      print('📺 Channel: $channelName');
      print('🩺 Symptoms: $symptoms');

      // Create call request notification
      final callRequest = VideoCallRequest(
        patientId: patientId,
        patientName: patientName,
        channelName: channelName,
        symptoms: symptoms,
        timestamp: DateTime.tryParse(timestamp) ?? DateTime.now(),
      );

      // Add to pending call requests
      _pendingCallRequests.add(callRequest);
      notifyListeners();

      // Show notification or dialog to doctor
      _showCallRequestNotification(callRequest);
    } catch (e) {
      print('❌ Error handling incoming video call: $e');
    }
  }

  /// Handle patient ending call
  void _handlePatientEndCall(Map<String, dynamic> data) {
    try {
      final patientId = data['patientId'];
      final channelName = data['channelName'];

      print('📞 Patient $patientId ended call in channel $channelName');

      // Remove from pending call requests
      _pendingCallRequests
          .removeWhere((request) => request.patientId == patientId);
      notifyListeners();
    } catch (e) {
      print('❌ Error handling patient end call: $e');
    }
  }

  /// Show call request notification to doctor
  void _showCallRequestNotification(VideoCallRequest callRequest) {
    // This method will trigger UI updates through notifyListeners()
    // The actual notification dialog/UI will be handled by the dashboard screen
    print('🔔 Call notification triggered for ${callRequest.patientName}');
    print('📋 Channel: ${callRequest.channelName}');
    print('🩺 Symptoms: ${callRequest.symptoms}');

    // Notify listeners so UI can react to the new pending call request
    notifyListeners();
  }

  /// Accept video call request
  void acceptVideoCall(VideoCallRequest callRequest) {
    try {
      // Remove from pending requests
      _pendingCallRequests
          .removeWhere((request) => request.patientId == callRequest.patientId);

      // Send acceptance via socket
      _socket?.emit('doctor_accept_call', {
        'doctorId': _currentDoctor?.id,
        'patientId': callRequest.patientId,
        'channelName': callRequest.channelName,
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('✅ Accepted video call from ${callRequest.patientName}');
      notifyListeners();
    } catch (e) {
      print('❌ Error accepting video call: $e');
    }
  }

  /// Reject video call request
  void rejectVideoCall(VideoCallRequest callRequest) {
    try {
      // Remove from pending requests
      _pendingCallRequests
          .removeWhere((request) => request.patientId == callRequest.patientId);

      // Send rejection via socket
      _socket?.emit('doctor_reject_call', {
        'doctorId': _currentDoctor?.id,
        'patientId': callRequest.patientId,
        'channelName': callRequest.channelName,
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('❌ Rejected video call from ${callRequest.patientName}');
      notifyListeners();
    } catch (e) {
      print('❌ Error rejecting video call: $e');
    }
  }

  @override
  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    super.dispose();
  }
}
