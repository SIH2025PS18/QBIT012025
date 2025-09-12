import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/appointment_booking_service.dart';
import '../services/socket_service.dart';
import '../screens/appointment_booking_screen.dart';
import '../screens/video_call_request_screen.dart';
import '../models/doctor.dart';

/// Integration widget for telemedicine features
/// Add this to your main app screen to enable appointment booking and video consultation
class TeleMedicineIntegrationWidget extends StatefulWidget {
  final String patientId;
  final String patientName;

  const TeleMedicineIntegrationWidget({
    Key? key,
    required this.patientId,
    required this.patientName,
  }) : super(key: key);

  @override
  State<TeleMedicineIntegrationWidget> createState() =>
      _TeleMedicineIntegrationWidgetState();
}

class _TeleMedicineIntegrationWidgetState
    extends State<TeleMedicineIntegrationWidget> {
  late SocketService _socketService;
  late AppointmentBookingService _bookingService;
  bool _isConnected = false;
  int _appointmentCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    _socketService = SocketService();
    _bookingService = AppointmentBookingService();

    // Initialize socket connection
    try {
      await _socketService.initialize(
        serverUrl: 'https://telemed18.onrender.com', // Unified backend
        userId: widget.patientId,
        userRole: 'patient',
        userName: widget.patientName,
      );

      // Listen for connection state changes
      _socketService.addListener(_onSocketStateChanged);

      // Listen for video call requests
      _socketService.videoCallRequests.listen((request) {
        if (request.patientId == widget.patientId) {
          _showVideoCallRequest(request);
        }
      });

      // Load existing appointments
      _loadAppointments();
    } catch (e) {
      debugPrint('Error initializing telemedicine services: $e');
    }
  }

  void _onSocketStateChanged() {
    if (mounted) {
      setState(() {
        _isConnected = _socketService.isConnected;
      });
    }
  }

  Future<void> _loadAppointments() async {
    try {
      final appointments = await _bookingService.getPatientAppointments(
        widget.patientId,
      );
      setState(() {
        _appointmentCount = appointments.length;
      });
    } catch (e) {
      debugPrint('Error loading appointments: $e');
    }
  }

  void _showVideoCallRequest(VideoCallRequest request) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Incoming Video Call'),
        content: Text(
          'Dr. ${request.doctorId} is starting a video consultation with you.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to video call screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VideoCallRequestScreen(
                    patientId: widget.patientId,
                    patientName: widget.patientName,
                  ),
                ),
              );
            },
            child: const Text('Join Call'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _socketService),
        ChangeNotifierProvider.value(value: _bookingService),
      ],
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.local_hospital, color: Colors.blue[600], size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Telemedicine Services',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Connection Status
              Row(
                children: [
                  Icon(
                    _isConnected ? Icons.cloud_done : Icons.cloud_off,
                    color: _isConnected ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isConnected ? 'Connected to Doctor Dashboard' : 'Offline',
                    style: TextStyle(
                      color: _isConnected ? Colors.green[700] : Colors.red[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Appointment Count
              if (_appointmentCount > 0)
                Text(
                  'You have $_appointmentCount appointment${_appointmentCount == 1 ? '' : 's'}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _bookAppointment,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Book Appointment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isConnected ? _joinVideoConsultation : null,
                      icon: const Icon(Icons.video_call),
                      label: const Text('Video Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isConnected
                            ? Colors.green[600]
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // View Appointments Button
              if (_appointmentCount > 0)
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: _viewAppointments,
                    icon: const Icon(Icons.list),
                    label: const Text('View My Appointments'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _bookAppointment() {
    // TODO: Replace with real doctor selection screen
    // For now, using a placeholder doctor - this should fetch from the backend
    final placeholderDoctor = Doctor(
      id: 'placeholder_001',
      name: 'Dr. Available Doctor',
      email: 'doctor@telemed.com',
      phone: '+91 9876543210',
      speciality: 'General Medicine',
      qualification: 'MBBS, MD',
      experience: 5,
      consultationFee: 500.0,
      licenseNumber: 'LIC_PLACEHOLDER',
      status: 'online',
      isAvailable: true,
      workingHours: {},
    );

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) =>
                AppointmentBookingScreen(doctor: placeholderDoctor),
          ),
        )
        .then((appointment) {
          if (appointment != null) {
            _loadAppointments(); // Refresh appointment count

            // Notify that patient is ready for consultation
            _bookingService.joinConsultationQueue(appointment.id);
          }
        });
  }

  void _joinVideoConsultation() {
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not connected to doctor dashboard'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Notify doctor dashboard that patient is ready
    _socketService.notifyPatientReady(
      patientId: widget.patientId,
      consultationId:
          'consultation_${widget.patientId}_${DateTime.now().millisecondsSinceEpoch}',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Notified doctor that you are ready for video consultation',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _viewAppointments() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('My Appointments'),
        content: FutureBuilder<List<Appointment>>(
          future: _bookingService.getPatientAppointments(widget.patientId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No appointments found');
            }

            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final appointment = snapshot.data![index];
                  return ListTile(
                    title: Text(appointment.patientName),
                    subtitle: Text(
                      '${appointment.preferredTime}\nStatus: ${appointment.statusDisplayName}',
                    ),
                    trailing: Text(
                      appointment.priorityDisplayName,
                      style: TextStyle(
                        color: appointment.priority == 'critical'
                            ? Colors.red
                            : appointment.priority == 'urgent'
                            ? Colors.orange
                            : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _socketService.removeListener(_onSocketStateChanged);
    super.dispose();
  }
}
