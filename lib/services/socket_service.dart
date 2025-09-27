import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Service for real-time communication with doctor dashboard
class SocketService extends ChangeNotifier {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;
  String? _userId;
  String? _userRole;
  String? _userName;

  // Stream controllers for different events
  final _videoCallRequestController =
      StreamController<VideoCallRequest>.broadcast();
  final _prescriptionController =
      StreamController<PrescriptionData>.broadcast();
  final _chatMessageController = StreamController<ChatMessage>.broadcast();
  final _recordingEventController =
      StreamController<RecordingEvent>.broadcast();

  // Getters
  bool get isConnected => _isConnected;
  String? get userId => _userId;
  String? get userRole => _userRole;
  String? get userName => _userName;

  // Streams
  Stream<VideoCallRequest> get videoCallRequests =>
      _videoCallRequestController.stream;
  Stream<PrescriptionData> get prescriptions => _prescriptionController.stream;
  Stream<ChatMessage> get chatMessages => _chatMessageController.stream;
  Stream<RecordingEvent> get recordingEvents =>
      _recordingEventController.stream;

  /// Initialize socket connection
  Future<void> initialize({
    String? serverUrl,
    required String userId,
    required String userRole,
    String? userName,
  }) async {
    try {
      _userId = userId;
      _userRole = userRole;
      _userName = userName ?? userId;

      // Use local backend URL for development
      final url = serverUrl ?? 'https://telemed18.onrender.com';

      // Create socket connection with auth token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      _socket = IO.io(url, <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'autoConnect': false,
        'reconnection': true,
        'reconnectionDelay': 1000,
        'reconnectionAttempts': 5,
        'timeout': 20000,
        'auth': {'token': token},
        'query': {'userRole': userRole, 'userName': userName, 'userId': userId},
      });

      // Set up event listeners
      _setupEventListeners();

      // Connect to server
      _socket!.connect();

      debugPrint(
        'Socket service initialized for $userRole: $userId (URL: $url)',
      );
    } catch (e) {
      debugPrint('Error initializing socket service: $e');
      rethrow;
    }
  }

  /// Set up socket event listeners
  void _setupEventListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      _isConnected = true;
      debugPrint('Connected to signaling server');

      // Register user
      _socket!.emit('register', {
        'userId': _userId,
        'role': _userRole,
        'name': _userName,
      });

      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      debugPrint('Disconnected from signaling server');
      notifyListeners();
    });

    _socket!.onConnectError((error) {
      debugPrint('Socket connection error: $error');
      // Add error to stream for UI to handle
      _videoCallRequestController.addError(error);
    });

    // Video call events
    _socket!.on('incoming_call', (data) {
      debugPrint('Incoming call: $data');
      try {
        final request = VideoCallRequest.fromJson(
          Map<String, dynamic>.from(data),
        );
        _videoCallRequestController.add(request);
      } catch (e) {
        debugPrint('Error parsing incoming call data: $e');
        _videoCallRequestController.addError(e);
      }
    });

    _socket!.on('call_accepted', (data) {
      debugPrint('Call accepted: $data');
      // Handle call accepted event
    });

    _socket!.on('call_rejected', (data) {
      debugPrint('Call rejected: $data');
      // Handle call rejected event
    });

    // WebRTC signaling
    _socket!.on('webrtc-signal', (data) {
      debugPrint('WebRTC signal received: $data');
      // Handle WebRTC signaling - this will be processed by AgoraService
    });

    _socket!.on('webrtc-end', (data) {
      debugPrint('WebRTC call ended: $data');
      // Handle call end
    });

    // Prescription events
    _socket!.on('prescription_submitted', (data) {
      debugPrint('Prescription received: $data');
      try {
        final prescription = PrescriptionData.fromJson(
          Map<String, dynamic>.from(data),
        );
        _prescriptionController.add(prescription);
      } catch (e) {
        debugPrint('Error parsing prescription data: $e');
        _prescriptionController.addError(e);
      }
    });

    // Recording events
    _socket!.on('recording_started', (data) {
      debugPrint('Recording started: $data');
      try {
        final event = RecordingEvent.fromJson(Map<String, dynamic>.from(data));
        _recordingEventController.add(event);
      } catch (e) {
        debugPrint('Error parsing recording start data: $e');
        _recordingEventController.addError(e);
      }
    });

    _socket!.on('recording_stopped', (data) {
      debugPrint('Recording stopped: $data');
      try {
        final event = RecordingEvent.fromJson(Map<String, dynamic>.from(data));
        _recordingEventController.add(event);
      } catch (e) {
        debugPrint('Error parsing recording stop data: $e');
        _recordingEventController.addError(e);
      }
    });

    // Chat events
    _socket!.on('chat_message', (data) {
      debugPrint('Chat message received: $data');
      try {
        final message = ChatMessage.fromJson(Map<String, dynamic>.from(data));
        _chatMessageController.add(message);
      } catch (e) {
        debugPrint('Error parsing chat message data: $e');
        _chatMessageController.addError(e);
      }
    });

    // User events
    _socket!.on('user_registered', (data) {
      debugPrint('User registered: $data');
    });

    _socket!.on('user_disconnected', (data) {
      debugPrint('User disconnected: $data');
    });

    _socket!.on('user_joined', (data) {
      debugPrint('User joined consultation: $data');
    });

    // Error events
    _socket!.on('error', (data) {
      debugPrint('Socket error: $data');
      final error = data is Map ? data['message'] : 'Unknown error';
      _videoCallRequestController.addError(error);
    });
  }

  /// Join a consultation room
  void joinConsultation({
    required String consultationId,
    required String userId,
    required String role,
  }) {
    if (!_isConnected) return;

    _socket!.emit('join_consultation', {
      'consultationId': consultationId,
      'userId': userId,
      'role': role,
    });

    debugPrint('Joined consultation: $consultationId');
  }

  /// Notify that patient is ready for video call
  void notifyPatientReady({
    required String patientId,
    required String consultationId,
  }) {
    if (!_isConnected) return;

    _socket!.emit('patient_ready', {
      'patientId': patientId,
      'consultationId': consultationId,
    });

    debugPrint('Patient ready notification sent');
  }

  /// Send WebRTC signaling data
  void sendWebRTCSignal({
    required String to,
    required String from,
    required Map<String, dynamic> signal,
    String? consultationId,
  }) {
    if (!_isConnected) return;

    _socket!.emit('webrtc-signal', {
      'to': to,
      'from': from,
      'signal': signal,
      'consultationId': consultationId,
    });
  }

  /// Send custom event with data
  void emit(String event, Map<String, dynamic> data) {
    if (!_isConnected) return;
    _socket!.emit(event, data);
    debugPrint('Emitted event: $event with data: $data');
  }

  /// End WebRTC call
  void endWebRTCCall({
    required String to,
    required String from,
    String? consultationId,
  }) {
    if (!_isConnected) return;

    _socket!.emit('webrtc-end', {
      'to': to,
      'from': from,
      'consultationId': consultationId,
    });
  }

  /// Send chat message
  void sendChatMessage({
    required String consultationId,
    required String senderId,
    required String senderName,
    required String message,
  }) {
    if (!_isConnected) return;

    _socket!.emit('chat_message', {
      'consultationId': consultationId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Notify recording started
  void notifyRecordingStarted({
    required String consultationId,
    required String recordingId,
  }) {
    if (!_isConnected) return;

    _socket!.emit('recording_started', {
      'consultationId': consultationId,
      'recordingId': recordingId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Notify recording stopped
  void notifyRecordingStopped({
    required String consultationId,
    required String recordingId,
  }) {
    if (!_isConnected) return;

    _socket!.emit('recording_stopped', {
      'consultationId': consultationId,
      'recordingId': recordingId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Disconnect from server
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
    }
    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    _videoCallRequestController.close();
    _prescriptionController.close();
    _chatMessageController.close();
    _recordingEventController.close();
    super.dispose();
  }
}

/// Data models for socket events
class VideoCallRequest {
  final String patientId;
  final String doctorId;
  final String consultationId;
  final String roomId;
  final int timestamp;

  VideoCallRequest({
    required this.patientId,
    required this.doctorId,
    required this.consultationId,
    required this.roomId,
    required this.timestamp,
  });

  factory VideoCallRequest.fromJson(Map<String, dynamic> json) {
    return VideoCallRequest(
      patientId: json['patientId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      consultationId: json['consultationId'] ?? '',
      roomId: json['roomId'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }
}

class PrescriptionData {
  final String patientId;
  final String doctorId;
  final List<String> medications;
  final String notes;
  final int timestamp;

  PrescriptionData({
    required this.patientId,
    required this.doctorId,
    required this.medications,
    required this.notes,
    required this.timestamp,
  });

  factory PrescriptionData.fromJson(Map<String, dynamic> json) {
    return PrescriptionData(
      patientId: json['patientId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      medications: List<String>.from(json['medications'] ?? []),
      notes: json['notes'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }
}

class ChatMessage {
  final String consultationId;
  final String senderId;
  final String senderName;
  final String message;
  final int timestamp;

  ChatMessage({
    required this.consultationId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      consultationId: json['consultationId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }
}

class RecordingEvent {
  final String consultationId;
  final String recordingId;
  final String type; // 'started' or 'stopped'
  final int timestamp;

  RecordingEvent({
    required this.consultationId,
    required this.recordingId,
    required this.type,
    required this.timestamp,
  });

  factory RecordingEvent.fromJson(Map<String, dynamic> json) {
    return RecordingEvent(
      consultationId: json['consultationId'] ?? '',
      recordingId: json['recordingId'] ?? '',
      type: json['type'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }
}
