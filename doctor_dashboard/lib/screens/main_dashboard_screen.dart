import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../providers/video_call_provider.dart';
import '../providers/chat_provider.dart';
import '../models/models.dart';
import '../widgets/video_call_widget.dart';
import '../widgets/patient_queue_widget.dart';
import '../widgets/chat_widget.dart';
import '../widgets/sidebar_widget.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load mock chat messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadMockMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B23),
      body: Row(
        children: [
          // Left Sidebar
          const SidebarWidget(),

          // Main Content Area
          Expanded(
            child: Consumer<VideoCallProvider>(
              builder: (context, videoProvider, child) {
                if (videoProvider.isInCall) {
                  // Video Call Interface (like in the image)
                  return Row(
                    children: [
                      // Video Call Area (2/3 of screen)
                      Expanded(
                        flex: 2,
                        child: VideoCallWidget(
                          patient: videoProvider.currentPatient!,
                        ),
                      ),

                      // Chat Panel (1/3 of screen)
                      const Expanded(flex: 1, child: ChatWidget()),
                    ],
                  );
                } else {
                  // Dashboard View with Patient Queue
                  return const Row(
                    children: [
                      // Main Dashboard Content
                      Expanded(flex: 2, child: DashboardContent()),

                      // Patient Queue
                      Expanded(flex: 1, child: PatientQueueWidget()),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Consumer<DoctorProvider>(
        builder: (context, doctorProvider, child) {
          final doctor = doctorProvider.currentDoctor;

          if (doctor == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1)),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFF6366F1),
                    backgroundImage: doctor.profileImage.isNotEmpty
                        ? NetworkImage(doctor.profileImage)
                        : null,
                    child: doctor.profileImage.isEmpty
                        ? Text(
                            doctor.name
                                .split(' ')
                                .map((n) => n[0])
                                .join()
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${doctor.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          doctor.specialization,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'ONLINE',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Statistics Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Today\'s Appointments',
                      '${doctorProvider.patientQueue.length}',
                      Icons.calendar_today,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Patients Waiting',
                      '${doctorProvider.patientQueue.where((p) => p.status == 'waiting').length}',
                      Icons.people,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Consultations Done',
                      '12',
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Test section for development
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<DoctorProvider>().addTestPatient();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test patient added to queue!'),
                            backgroundColor: Color(0xFF6366F1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Add Test Patient'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Today's Schedule
              const Text(
                'Today\'s Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2D37),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: doctorProvider.patientQueue.isEmpty
                      ? const Center(
                          child: Text(
                            'No appointments scheduled for today',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: doctorProvider.patientQueue.length,
                          itemBuilder: (context, index) {
                            final patient = doctorProvider.patientQueue[index];
                            return _buildAppointmentCard(patient, context);
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D37),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Patient patient, BuildContext context) {
    final timeText =
        '${patient.appointmentTime.hour.toString().padLeft(2, '0')}:${patient.appointmentTime.minute.toString().padLeft(2, '0')}';
    final isNow =
        DateTime.now().difference(patient.appointmentTime).abs().inMinutes < 10;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNow
            ? const Color(0xFF6366F1).withValues(alpha: 0.1)
            : const Color(0xFF3A3D47),
        borderRadius: BorderRadius.circular(12),
        border:
            isNow ? Border.all(color: const Color(0xFF6366F1), width: 1) : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF6366F1),
            child: Text(
              patient.name.split(' ').map((n) => n[0]).join().toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  patient.symptoms,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            timeText,
            style: TextStyle(
              color: isNow ? const Color(0xFF6366F1) : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          if (isNow)
            ElevatedButton(
              onPressed: () {
                context.read<VideoCallProvider>().startCall(patient);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Start Call'),
            ),
        ],
      ),
    );
  }
}
