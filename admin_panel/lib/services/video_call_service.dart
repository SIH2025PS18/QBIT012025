import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video_call.dart';
import 'agora_service_web.dart';

class VideoCallService {
  static const String baseUrl = 'https://telemed18.onrender.com/api';
  final AgoraVideoService _agoraService = AgoraVideoService();

  static final VideoCallService _instance = VideoCallService._internal();
  factory VideoCallService() => _instance;
  VideoCallService._internal();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Initialize video call session
  Future<VideoCallSession?> initializeCall({
    required String appointmentId,
    required String doctorId,
    required String patientId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/video-calls/initialize'),
        headers: _headers,
        body: json.encode({
          'appointment_id': appointmentId,
          'doctor_id': doctorId,
          'patient_id': patientId,
        }),
      );

      print('Initialize Call Response: ${response.statusCode}');
      print('Initialize Call Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return VideoCallSession.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error initializing video call: $e');
      return null;
    }
  }

  // Start video call
  Future<bool> startCall({
    required VideoCallSession session,
    required bool isDoctor,
    required int uid,
  }) async {
    try {
      // Initialize Agora if not already done
      await _agoraService.initialize();

      // Join Agora channel
      final joined = await _agoraService.joinChannel(
        channelName: session.channelName,
        token: session.token,
        uid: uid,
        isDoctor: isDoctor,
      );

      if (joined) {
        // Update session status on backend
        await updateCallStatus(session.sessionId, VideoCallStatus.connected);
        return true;
      }
      return false;
    } catch (e) {
      print('Error starting video call: $e');
      return false;
    }
  }

  // End video call
  Future<bool> endCall(String sessionId) async {
    try {
      // Leave Agora channel
      await _agoraService.leaveChannel();

      // Update session status on backend
      final response = await http.patch(
        Uri.parse('$baseUrl/video-calls/$sessionId/end'),
        headers: _headers,
        body: json.encode({
          'end_time': DateTime.now().toIso8601String(),
          'status': VideoCallStatus.ended.name,
        }),
      );

      print('End Call Response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error ending video call: $e');
      return false;
    }
  }

  // Update call status
  Future<bool> updateCallStatus(
      String sessionId, VideoCallStatus status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/video-calls/$sessionId/status'),
        headers: _headers,
        body: json.encode({'status': status.name}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating call status: $e');
      return false;
    }
  }

  // Get appointments for doctor
  Future<List<Appointment>> getDoctorAppointments(String doctorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/appointments/doctor/$doctorId'),
        headers: _headers,
      );

      print('Get Doctor Appointments Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((appointment) => Appointment.fromJson(appointment))
              .toList();
        }
      }

      // Return mock data for development
      return _getMockAppointments(doctorId);
    } catch (e) {
      print('Error fetching doctor appointments: $e');
      return _getMockAppointments(doctorId);
    }
  }

  // Get patient record
  Future<PatientRecord?> getPatientRecord(String patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/$patientId/record'),
        headers: _headers,
      );

      print('Get Patient Record Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return PatientRecord.fromJson(data['data']);
        }
      }

      // Return mock data for development
      return _getMockPatientRecord(patientId);
    } catch (e) {
      print('Error fetching patient record: $e');
      return _getMockPatientRecord(patientId);
    }
  }

  // Create consultation record
  Future<bool> createConsultation({
    required String appointmentId,
    required String doctorId,
    required String patientId,
    required String diagnosis,
    required String prescription,
    required String notes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/consultations'),
        headers: _headers,
        body: json.encode({
          'appointment_id': appointmentId,
          'doctor_id': doctorId,
          'patient_id': patientId,
          'diagnosis': diagnosis,
          'prescription': prescription,
          'notes': notes,
          'date': DateTime.now().toIso8601String(),
        }),
      );

      print('Create Consultation Response: ${response.statusCode}');
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error creating consultation: $e');
      return false;
    }
  }

  // Generate Agora token
  Future<String?> generateAgoraToken({
    required String channelName,
    required int uid,
    required bool isDoctor,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/agora/token'),
        headers: _headers,
        body: json.encode({
          'channel_name': channelName,
          'uid': uid,
          'role': isDoctor ? 'publisher' : 'subscriber',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['token'];
      }

      // Return mock token for development
      return 'mock_agora_token_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      print('Error generating Agora token: $e');
      return 'mock_agora_token_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  // Mock data methods
  List<Appointment> _getMockAppointments(String doctorId) {
    return [
      Appointment(
        id: '1',
        patientId: 'patient_1',
        doctorId: doctorId,
        patientName: 'John Doe',
        doctorName: 'Dr. Smith',
        scheduledTime: DateTime.now().add(const Duration(minutes: 30)),
        status: AppointmentStatus.confirmed,
        reason: 'Regular checkup',
        symptoms: 'Headache, fever',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      Appointment(
        id: '2',
        patientId: 'patient_2',
        doctorId: doctorId,
        patientName: 'Jane Smith',
        doctorName: 'Dr. Smith',
        scheduledTime: DateTime.now().add(const Duration(hours: 1)),
        status: AppointmentStatus.pending,
        reason: 'Follow-up consultation',
        symptoms: 'Back pain',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now(),
      ),
      Appointment(
        id: '3',
        patientId: 'patient_3',
        doctorId: doctorId,
        patientName: 'Mike Johnson',
        doctorName: 'Dr. Smith',
        scheduledTime: DateTime.now().add(const Duration(hours: 2)),
        status: AppointmentStatus.confirmed,
        reason: 'Chest pain consultation',
        symptoms: 'Chest pain, shortness of breath',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  PatientRecord _getMockPatientRecord(String patientId) {
    return PatientRecord(
      id: 'record_$patientId',
      patientId: patientId,
      patientName: 'John Doe',
      age: 35,
      gender: 'Male',
      phone: '+1234567890',
      email: 'john.doe@email.com',
      allergies: ['Penicillin', 'Peanuts'],
      medications: ['Lisinopril 10mg', 'Metformin 500mg'],
      medicalHistory: ['Hypertension', 'Type 2 Diabetes'],
      consultations: [
        Consultation(
          id: 'consultation_1',
          doctorId: 'doctor_1',
          doctorName: 'Dr. Johnson',
          date: DateTime.now().subtract(const Duration(days: 30)),
          diagnosis: 'Hypertension',
          prescription: 'Lisinopril 10mg daily',
          notes: 'Blood pressure well controlled',
        ),
        Consultation(
          id: 'consultation_2',
          doctorId: 'doctor_2',
          doctorName: 'Dr. Brown',
          date: DateTime.now().subtract(const Duration(days: 60)),
          diagnosis: 'Type 2 Diabetes',
          prescription: 'Metformin 500mg twice daily',
          notes: 'HbA1c within target range',
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now(),
    );
  }

  AgoraVideoService get agoraService => _agoraService;
}
