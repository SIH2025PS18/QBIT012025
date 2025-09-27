import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prescription_request.dart';

class PharmacyNotificationService {
  static final PharmacyNotificationService _instance =
      PharmacyNotificationService._internal();
  factory PharmacyNotificationService() => _instance;
  PharmacyNotificationService._internal();

  IO.Socket? _socket;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final StreamController<PrescriptionRequest> _prescriptionStreamController =
      StreamController<PrescriptionRequest>.broadcast();
  final StreamController<Map<String, dynamic>> _statusUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Streams for UI to listen to
  Stream<PrescriptionRequest> get prescriptionRequests =>
      _prescriptionStreamController.stream;
  Stream<Map<String, dynamic>> get statusUpdates =>
      _statusUpdateController.stream;

  String? _pharmacyId;
  bool _isConnected = false;
  bool _soundEnabled = true;

  bool get isConnected => _isConnected;

  Future<void> initialize(String pharmacyId) async {
    _pharmacyId = pharmacyId;
    await _loadSettings();
    await _connectToServer();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('notification_sound_enabled') ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_sound_enabled', enabled);
  }

  Future<void> _connectToServer() async {
    try {
      _socket = IO.io('http://192.168.1.7:5002', {
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket!.connect();

      _socket!.on('connect', (_) {
        print('📱 Pharmacy connected to notification server');
        _isConnected = true;
        _joinPharmacyRoom();
      });

      _socket!.on('disconnect', (_) {
        print('📱 Pharmacy disconnected from server');
        _isConnected = false;
      });

      // Listen for new prescription requests
      _socket!.on('new_prescription_request', (data) {
        _handleNewPrescriptionRequest(data);
      });

      // Listen for request status updates
      _socket!.on('prescription_status_update', (data) {
        _handleStatusUpdate(data);
      });

      // Listen for request expiry warnings
      _socket!.on('prescription_expiry_warning', (data) {
        _handleExpiryWarning(data);
      });

      _socket!.on('connect_error', (error) {
        print('❌ Connection error: $error');
        _isConnected = false;
      });
    } catch (e) {
      print('❌ Failed to connect to server: $e');
      _isConnected = false;
    }
  }

  void _joinPharmacyRoom() {
    if (_pharmacyId != null && _socket != null) {
      _socket!.emit('join_pharmacy', {
        'pharmacyId': _pharmacyId,
        'type': 'pharmacy_dashboard',
      });
      print('🏪 Joined pharmacy room: $_pharmacyId');
    }
  }

  void _handleNewPrescriptionRequest(dynamic data) {
    try {
      print('🔔 New prescription request received: $data');

      final request = PrescriptionRequest.fromJson(data);
      _prescriptionStreamController.add(request);

      // Play notification sound
      if (_soundEnabled) {
        _playNotificationSound();
      }

      // Show system notification (if supported)
      _showSystemNotification(request);
    } catch (e) {
      print('❌ Error handling prescription request: $e');
    }
  }

  void _handleStatusUpdate(dynamic data) {
    try {
      print('📋 Prescription status update: $data');
      _statusUpdateController.add(data);
    } catch (e) {
      print('❌ Error handling status update: $e');
    }
  }

  void _handleExpiryWarning(dynamic data) {
    try {
      print('⏰ Prescription expiry warning: $data');

      // Play urgent notification sound
      if (_soundEnabled) {
        _playUrgentNotificationSound();
      }

      _statusUpdateController.add({'type': 'expiry_warning', 'data': data});
    } catch (e) {
      print('❌ Error handling expiry warning: $e');
    }
  }

  Future<void> _playNotificationSound() async {
    try {
      // Use a default notification sound or custom asset
      await _audioPlayer.play(
        AssetSource('audio/prescription_notification.wav'),
      );
    } catch (e) {
      print('❌ Error playing notification sound: $e');
      // Fallback to system beep or vibration
    }
  }

  Future<void> _playUrgentNotificationSound() async {
    try {
      // Use a more urgent sound for expiry warnings
      await _audioPlayer.play(AssetSource('audio/urgent_notification.wav'));
    } catch (e) {
      print('❌ Error playing urgent notification sound: $e');
    }
  }

  void _showSystemNotification(PrescriptionRequest request) {
    // For web, this would use browser notifications
    // For now, we'll rely on the in-app notification system
    print(
      '🔔 New prescription from ${request.patientName} - ${request.medicines.length} medicines',
    );
  }

  // Send response to patient
  Future<void> respondToPrescription(
    String requestId,
    String response, {
    String? notes,
    double? estimatedCost,
    List<Map<String, dynamic>>? medicineAvailability,
  }) async {
    if (_socket == null || !_isConnected) {
      throw Exception('Not connected to server');
    }

    try {
      _socket!.emit('pharmacy_response', {
        'requestId': requestId,
        'pharmacyId': _pharmacyId,
        'response': response,
        'notes': notes,
        'estimatedCost': estimatedCost,
        'medicineAvailability': medicineAvailability,
        'respondedAt': DateTime.now().toIso8601String(),
      });

      print('✅ Response sent for request: $requestId');
    } catch (e) {
      print('❌ Error sending response: $e');
      throw Exception('Failed to send response: $e');
    }
  }

  // Update pharmacy online status
  Future<void> updateOnlineStatus(bool isOnline) async {
    if (_socket == null || !_isConnected) return;

    try {
      _socket!.emit('pharmacy_status_update', {
        'pharmacyId': _pharmacyId,
        'isOnline': isOnline,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Error updating online status: $e');
    }
  }

  // Request prescription details
  Future<void> requestPrescriptionDetails(String requestId) async {
    if (_socket == null || !_isConnected) return;

    try {
      _socket!.emit('request_prescription_details', {
        'requestId': requestId,
        'pharmacyId': _pharmacyId,
      });
    } catch (e) {
      print('❌ Error requesting prescription details: $e');
    }
  }

  void dispose() {
    _prescriptionStreamController.close();
    _statusUpdateController.close();
    _audioPlayer.dispose();
    _socket?.disconnect();
    _socket?.dispose();
  }

  // Reconnection logic
  Future<void> reconnect() async {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
    }

    await Future.delayed(const Duration(seconds: 2));
    await _connectToServer();
  }

  // Test notification (for debugging)
  Future<void> testNotification() async {
    final testRequest = PrescriptionRequest(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      patientId: 'test_patient',
      patientName: 'Test Patient',
      patientPhone: '+91 9876543210',
      doctorName: 'Dr. Test',
      medicines: [
        Medicine(name: 'Paracetamol', dosage: '500mg', quantity: 10),
        Medicine(name: 'Amoxicillin', dosage: '250mg', quantity: 21),
      ],
      requestedAt: DateTime.now(),
      status: 'pending',
      responseDeadline: DateTime.now().add(const Duration(minutes: 15)),
    );

    _prescriptionStreamController.add(testRequest);

    if (_soundEnabled) {
      await _playNotificationSound();
    }
  }
}
