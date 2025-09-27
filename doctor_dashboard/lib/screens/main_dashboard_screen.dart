import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../providers/video_call_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/doctor_theme_provider.dart';
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
    return Consumer<DoctorThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.primaryBackgroundColor,
          appBar: AppBar(
            backgroundColor: themeProvider.cardBackgroundColor,
            elevation: 1,
            title: Text(
              'Doctor Dashboard',
              style: TextStyle(
                color: themeProvider.primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              // Theme toggle button
              IconButton(
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: themeProvider.primaryTextColor,
                ),
                tooltip: themeProvider.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: Row(
              children: [
                // Left Sidebar - fixed width
                const SidebarWidget(),

                // Main Content Area - flexible width
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
          ),
        );
      },
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Consumer<DoctorProvider>(
            builder: (context, doctorProvider, child) {
              final doctor = doctorProvider.currentDoctor;

              if (doctor == null) {
                return Center(
                  child: CircularProgressIndicator(
                      color: themeProvider.accentColor),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: themeProvider.accentColor,
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
                                style: TextStyle(
                                  color: themeProvider.primaryTextColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                doctor.specialization,
                                style: TextStyle(
                                  color: themeProvider.secondaryTextColor,
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
                            border: Border.all(
                              color: themeProvider.isDarkMode
                                  ? Colors.green.withValues(alpha: 0.3)
                                  : Colors.green.withValues(alpha: 0.1),
                              width: 1,
                            ),
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
                            themeProvider,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Patients Waiting',
                            '${doctorProvider.patientQueue.where((p) => p.status == 'waiting').length}',
                            Icons.people,
                            Colors.orange,
                            themeProvider,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Consultations Done',
                            '12',
                            Icons.check_circle,
                            Colors.green,
                            themeProvider,
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
                                SnackBar(
                                  content: const Text(
                                      'Test patient added to queue!'),
                                  backgroundColor: themeProvider.accentColor,
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
                    Text(
                      'Today\'s Schedule',
                      style: TextStyle(
                        color: themeProvider.primaryTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 400, // Fixed height instead of Expanded
                      child: Container(
                        decoration: BoxDecoration(
                          color: themeProvider.cardBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: themeProvider.borderColor,
                            width: 1,
                          ),
                        ),
                        child: doctorProvider.patientQueue.isEmpty
                            ? Center(
                                child: Text(
                                  'No appointments scheduled for today',
                                  style: TextStyle(
                                    color: themeProvider.secondaryTextColor,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: doctorProvider.patientQueue.length,
                                itemBuilder: (context, index) {
                                  final patient =
                                      doctorProvider.patientQueue[index];
                                  return _buildAppointmentCard(
                                      patient, context, themeProvider);
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    DoctorThemeProvider themeProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeProvider.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeProvider.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
          Text(
            title,
            style: TextStyle(
              color: themeProvider.secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Patient patient, BuildContext context,
      DoctorThemeProvider themeProvider) {
    final timeText =
        '${patient.appointmentTime.hour.toString().padLeft(2, '0')}:${patient.appointmentTime.minute.toString().padLeft(2, '0')}';
    final isNow =
        DateTime.now().difference(patient.appointmentTime).abs().inMinutes < 10;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNow
            ? themeProvider.accentColor.withValues(alpha: 0.1)
            : themeProvider.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: isNow
            ? Border.all(color: themeProvider.accentColor, width: 1)
            : Border.all(color: themeProvider.borderColor, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: themeProvider.accentColor,
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
                  style: TextStyle(
                    color: themeProvider.primaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  patient.symptoms,
                  style: TextStyle(
                    color: themeProvider.secondaryTextColor,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            timeText,
            style: TextStyle(
              color: isNow
                  ? themeProvider.accentColor
                  : themeProvider.secondaryTextColor,
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
                backgroundColor: themeProvider.accentColor,
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
