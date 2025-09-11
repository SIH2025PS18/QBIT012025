import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/doctor.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;

  // Callbacks for real-time updates
  Function(Doctor)? onDoctorAdded;
  Function(Doctor)? onDoctorUpdated;
  Function(String)? onDoctorDeleted;

  void connect() {
    try {
      _socket = IO.io('https://telemed18.onrender.com', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket!.connect();

      _socket!.onConnect((_) {
        print('Connected to WebSocket server');
        _isConnected = true;

        // Join admin room for updates
        _socket!.emit('join_admin_room');
      });

      _socket!.onDisconnect((_) {
        print('Disconnected from WebSocket server');
        _isConnected = false;
      });

      _socket!.onConnectError((error) {
        print('WebSocket connection error: $error');
        _isConnected = false;
      });

      // Listen for doctor updates
      _socket!.on('doctor_added', (data) {
        print('Doctor added: $data');
        if (onDoctorAdded != null && data != null) {
          try {
            final doctor = Doctor.fromJson(Map<String, dynamic>.from(data));
            onDoctorAdded!(doctor);
          } catch (e) {
            print('Error parsing doctor data: $e');
          }
        }
      });

      _socket!.on('doctor_updated', (data) {
        print('Doctor updated: $data');
        if (onDoctorUpdated != null && data != null) {
          try {
            final doctor = Doctor.fromJson(Map<String, dynamic>.from(data));
            onDoctorUpdated!(doctor);
          } catch (e) {
            print('Error parsing doctor data: $e');
          }
        }
      });

      _socket!.on('doctor_deleted', (data) {
        print('Doctor deleted: $data');
        if (onDoctorDeleted != null && data != null) {
          final doctorId = data['id']?.toString() ?? data.toString();
          onDoctorDeleted!(doctorId);
        }
      });

      _socket!.on('error', (error) {
        print('WebSocket error: $error');
      });
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      _isConnected = false;
    }
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
      _isConnected = false;
    }
  }

  bool get isConnected => _isConnected;

  // Emit events to notify patient app
  void notifyDoctorAdded(Doctor doctor) {
    if (_isConnected && _socket != null) {
      _socket!.emit('admin_doctor_added', doctor.toJson());
    }
  }

  void notifyDoctorUpdated(Doctor doctor) {
    if (_isConnected && _socket != null) {
      _socket!.emit('admin_doctor_updated', doctor.toJson());
    }
  }

  void notifyDoctorDeleted(String doctorId) {
    if (_isConnected && _socket != null) {
      _socket!.emit('admin_doctor_deleted', {'id': doctorId});
    }
  }

  void notifyDoctorAvailabilityChanged(String doctorId, bool isAvailable) {
    if (_isConnected && _socket != null) {
      _socket!.emit('admin_doctor_availability_changed', {
        'id': doctorId,
        'isAvailable': isAvailable,
      });
    }
  }

  // Set callbacks
  void setDoctorCallbacks({
    Function(Doctor)? onAdded,
    Function(Doctor)? onUpdated,
    Function(String)? onDeleted,
  }) {
    onDoctorAdded = onAdded;
    onDoctorUpdated = onUpdated;
    onDoctorDeleted = onDeleted;
  }

  void clearCallbacks() {
    onDoctorAdded = null;
    onDoctorUpdated = null;
    onDoctorDeleted = null;
  }
}
