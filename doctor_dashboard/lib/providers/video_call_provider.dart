import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import '../models/models.dart';

// Only import Agora on non-web platforms
// ignore: uri_does_not_exist
import '../services/agora_service.dart'
    if (dart.library.html) '../services/agora_service_stub.dart';

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

  // Agora service for video calling
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
  AgoraService get agoraService => _agoraService;
  List<int> get remoteUsers => _remoteUsers;

  // Initialize socket connection
  void initializeSocket(String doctorId, String authToken) async {
    _authToken = authToken;

    // Initialize Agora service
    await _agoraService.initialize('your-agora-app-id');
    _setupAgoraCallbacks();

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
  }

  // Setup Agora callbacks
  void _setupAgoraCallbacks() {
    // Listen to Agora service changes
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

    // Leave Agora channel
    await _agoraService.leaveChannel();
    notifyListeners();
  }

  // Start a video call with a patient
  Future<bool> startCall(Patient patient) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/calls/start'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: json.encode({'patientId': patient.id, 'type': 'video'}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _currentPatient = patient;
          _callId = data['callId'];
          _isInCall = true;

          // Join Agora channel using call ID
          await _agoraService.joinChannel(
            channelId: _callId!,
            token: '', // Use empty token for testing
          );

          // Notify patient via socket
          _socket?.emit('start_call', {
            'callId': _callId,
            'patientId': patient.id,
          });

          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error starting call: $e');
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

    // Use Agora to mute/unmute microphone
    await _agoraService.muteLocalAudio(_isMuted);

    // Emit mute status to other participants
    _socket?.emit('toggle_audio', {'callId': _callId, 'isMuted': _isMuted});

    notifyListeners();
  }

  // Toggle audio on/off
  void toggleAudio() async {
    _isAudioEnabled = !_isAudioEnabled;

    // Use Agora to enable/disable audio
    await _agoraService.muteLocalAudio(!_isAudioEnabled);

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

    // Use Agora to enable/disable video
    await _agoraService.enableLocalVideo(_isVideoEnabled);

    // Emit video status to other participants
    _socket?.emit('toggle_video', {
      'callId': _callId,
      'isVideoEnabled': _isVideoEnabled,
    });

    notifyListeners();
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
