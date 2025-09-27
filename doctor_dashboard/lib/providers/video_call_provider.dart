import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/models.dart';

// Use web-specific service for doctor dashboard
import '../services/agora_service_web.dart';

class VideoCallProvider with ChangeNotifier {
  Patient? _currentPatient;
  bool _isInCall = false;
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _isScreenSharing = false;
  bool _isAudioEnabled = true;
  bool _isSpeakerEnabled = false;
  String? _callId;
  IO.Socket? _socket;
  String? _authToken;

  // Video call service for web platform
  final AgoraService _agoraService = AgoraService();
  List<int> _remoteUsers = [];

  // Backend API URL
  static const String _baseUrl = 'https://telemed18.onrender.com/api';
  static const String _socketUrl = 'https://telemed18.onrender.com';

  Patient? get currentPatient => _currentPatient;
  bool get isInCall => _isInCall;
  bool get isMuted => _isMuted;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isScreenSharing => _isScreenSharing;
  bool get isAudioEnabled => _isAudioEnabled;
  bool get isSpeakerEnabled => _isSpeakerEnabled;
  String? get callId => _callId;
  AgoraService get webrtcService => _agoraService;
  AgoraService get videoCallService => _agoraService;
  List<int> get remoteUsers => _remoteUsers;

  // Initialize socket connection
  void initializeSocket(String doctorId, String authToken) async {
    _authToken = authToken;

    // Initialize video call service
    await _agoraService.initialize();
    _setupVideoCallCallbacks();

    _socket = IO.io(_socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'query': {'doctorId': doctorId, 'token': authToken},
    });

    _socket!.connect();

    _socket!.on('connect', (_) {
      print('Connected to video call server');
    });

    _socket!.on('disconnect', (_) {
      print('Disconnected from video call server');
    });

    _socket!.on('incoming_call', (data) {
      final patient = Patient.fromJson(data['patient']);
      _handleIncomingCall(patient, data['callId']);
    });

    _socket!.on('call_ended', (data) {
      _handleCallEnded();
    });

    _socket!.on('patient_joined', (data) {
      print('Patient joined the call');
      notifyListeners();
    });

    _socket!.on('patient_left', (data) {
      print('Patient left the call');
      notifyListeners();
    });

    // Listen for patient starting a call
    _socket!.on('patient_start_call', (data) {
      print('📞 Patient starting call: $data');
      final patient = Patient(
        id: data['patientId'] ?? '',
        name: data['patientName'] ?? 'Unknown Patient',
        profileImage: '',
        age: 0,
        gender: '',
        phone: '',
        email: '',
        symptoms: data['symptoms'] ?? 'No symptoms provided',
        appointmentTime: DateTime.now(),
        status: 'calling',
      );

      // Auto-join the same channel that patient created
      String channelName = data['channelName'] ?? '';
      _autoJoinPatientCall(patient, channelName, data);
    });

    // Listen for patient ending a call
    _socket!.on('patient_end_call', (data) {
      print('📞 Patient ending call: $data');
      _handleCallEnded();
    });
  }

  // Setup video call callbacks
  void _setupVideoCallCallbacks() {
    // Listen to video call service changes
    _agoraService.addListener(() {
      _remoteUsers = List.from(_agoraService.remoteUsers);
      notifyListeners();
    });
  }

  void _handleIncomingCall(Patient patient, String callId) {
    _currentPatient = patient;
    _callId = callId;
    _isInCall = true;
    notifyListeners();
  }

  void _handleCallEnded() async {
    _currentPatient = null;
    _callId = null;
    _isInCall = false;
    _isMuted = false;
    _isVideoEnabled = true;
    _isScreenSharing = false;
    _isAudioEnabled = true;
    _isSpeakerEnabled = false;
    _remoteUsers.clear();

    // Leave video call channel
    await _agoraService.leaveChannel();
    notifyListeners();
  }

  // Start a video call with a patient
  Future<bool> startCall(Patient patient) async {
    try {
      print('🚀 Starting video call with patient: ${patient.name}');

      // Generate a call ID based on current timestamp and patient ID
      _callId = 'call_${DateTime.now().millisecondsSinceEpoch}_${patient.id}';

      // Use the call ID directly as channel name (it already has proper format)
      String channelName = _callId!;

      print('📱 Video Call Details:');
      print('   - Call ID: $_callId');
      print('   - Channel: $channelName');
      print('   - Patient: ${patient.name} (${patient.id})');

      _currentPatient = patient;
      _isInCall = true;

      // Join video call channel using the generated channel name
      await _agoraService.joinChannel(
        channelId: channelName,
        uid: 1,
      );

      // Explicitly enable video and audio after joining
      await _agoraService.enableLocalVideo(true);
      await _agoraService.muteLocalAudioStream(false);

      // Notify patient via socket if available
      _socket?.emit('start_call', {
        'callId': _callId,
        'patientId': patient.id,
        'channelName': channelName,
        'doctorName': 'Dr. SATYAM',
      });

      print('✅ Doctor joined video call successfully');
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error starting call: $e');
      _isInCall = false;
      _currentPatient = null;
      _callId = null;
      notifyListeners();
      return false;
    }
  }

  // Join an existing video call with specific channel name (for patient-initiated calls)
  Future<bool> joinVideoCall(
      String patientId, String patientName, String channelName) async {
    try {
      print('🚀 Doctor joining video call with patient: $patientName');
      print('📱 Channel: $channelName');

      // Create a patient object for the call
      final patient = Patient(
        id: patientId,
        name: patientName,
        profileImage: '',
        age: 0,
        gender: 'Unknown',
        phone: '',
        email: '',
        status: 'waiting',
        symptoms: 'Video call request',
        appointmentTime: DateTime.now(),
      );

      _callId = channelName; // Use the patient's channel name as call ID
      _currentPatient = patient;
      _isInCall = true;

      // Join the existing video call channel created by patient
      await _agoraService.joinChannel(
        channelId: channelName,
        uid: 2, // Doctor uses uid 2, patient uses uid 1
      );

      // Explicitly enable video and audio after joining
      await _agoraService.enableLocalVideo(true);
      await _agoraService.muteLocalAudioStream(false);

      print('✅ Doctor joined existing video call successfully');
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error joining video call: $e');
      _isInCall = false;
      _currentPatient = null;
      _callId = null;
      notifyListeners();
      return false;
    }
  }

  // End the current call
  Future<void> endCall() async {
    if (_callId == null) return;

    try {
      await http.post(
        Uri.parse('$_baseUrl/calls/$_callId/end'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      // Notify patient via socket
      _socket?.emit('end_call', {'callId': _callId});

      _handleCallEnded();
    } catch (e) {
      print('Error ending call: $e');
      _handleCallEnded(); // End call locally even if API fails
    }
  }

  // Toggle microphone mute
  void toggleMute() async {
    _isMuted = !_isMuted;

    // Use video call service to mute/unmute microphone
    await _agoraService.muteLocalAudioStream(_isMuted);

    // Emit mute status to other participants
    _socket?.emit('toggle_audio', {'callId': _callId, 'isMuted': _isMuted});

    notifyListeners();
  }

  // Toggle audio on/off
  void toggleAudio() async {
    _isAudioEnabled = !_isAudioEnabled;

    // Use video call service to enable/disable audio
    await _agoraService.muteLocalAudioStream(!_isAudioEnabled);

    // Emit audio status to other participants
    _socket?.emit('toggle_audio', {
      'callId': _callId,
      'isAudioEnabled': _isAudioEnabled,
    });

    notifyListeners();
  }

  // Toggle speaker on/off
  void toggleSpeaker() {
    _isSpeakerEnabled = !_isSpeakerEnabled;

    // Emit speaker status to other participants
    _socket?.emit('toggle_speaker', {
      'callId': _callId,
      'isSpeakerEnabled': _isSpeakerEnabled,
    });

    notifyListeners();
  }

  // Toggle video on/off
  void toggleVideo() async {
    _isVideoEnabled = !_isVideoEnabled;

    // Use video call service to enable/disable video
    await _agoraService.enableLocalVideo(_isVideoEnabled);

    // Emit video status to other participants
    _socket?.emit('toggle_video', {
      'callId': _callId,
      'isVideoEnabled': _isVideoEnabled,
    });

    notifyListeners();
  }

  // Auto-join patient call when they start calling
  Future<void> _autoJoinPatientCall(Patient patient, String channelName,
      Map<String, dynamic> callData) async {
    try {
      print('🏃‍♂️ Auto-joining patient call: $channelName');

      // Set current patient and call state
      _currentPatient = patient;
      _isInCall = true;
      _callId = 'call_${DateTime.now().millisecondsSinceEpoch}_${patient.id}';

      // Join the same video call channel as the patient
      await _agoraService.joinChannel(
        channelId: channelName,
        uid: 1,
      );

      // Explicitly enable video and audio after joining
      await _agoraService.enableLocalVideo(true);
      await _agoraService.muteLocalAudioStream(false);

      // Notify patient that doctor has joined
      _socket?.emit('doctor_joined_call', {
        'callId': _callId,
        'patientId': patient.id,
        'channelName': channelName,
        'doctorName': 'Dr. SATYAM',
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('✅ Doctor auto-joined patient call successfully');
      notifyListeners();
    } catch (e) {
      print('❌ Error auto-joining patient call: $e');
      _isInCall = false;
      _currentPatient = null;
      _callId = null;
      notifyListeners();
    }
  }

  // Toggle screen sharing
  void toggleScreenShare() {
    _isScreenSharing = !_isScreenSharing;

    // Emit screen share status to other participants
    _socket?.emit('toggle_screen_share', {
      'callId': _callId,
      'isScreenSharing': _isScreenSharing,
    });

    notifyListeners();
  }

  @override
  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    super.dispose();
  }
}
