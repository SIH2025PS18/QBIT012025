import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/doctor.dart';
import '../services/doctor_provider.dart';
import 'realtime_video_call_screen.dart';

/// Screen for selecting an online doctor and starting video consultation
class DoctorSelectionScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const DoctorSelectionScreen({
    Key? key,
    required this.patientId,
    required this.patientName,
  }) : super(key: key);

  @override
  State<DoctorSelectionScreen> createState() => _DoctorSelectionScreenState();
}

class _DoctorSelectionScreenState extends State<DoctorSelectionScreen> {
  late DoctorService _doctorService;
  String _selectedSpeciality = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  final List<String> _specialities = [
    'All',
    'General Medicine',
    'Cardiology',
    'Dermatology',
    'Neurology',
    'Orthopedics',
    'Pediatrics',
    'Psychiatry',
    'Gynecology',
    'Ophthalmology',
  ];

  @override
  void initState() {
    super.initState();
    _doctorService = Provider.of<DoctorService>(context, listen: false);
    // Start real-time connection
    _doctorService.initialize();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  List<Doctor> _getFilteredDoctors() {
    List<Doctor> doctors = _doctorService.onlineDoctors;

    // Filter by speciality
    if (_selectedSpeciality != 'All') {
      doctors = doctors
          .where(
            (doctor) => doctor.speciality.toLowerCase().contains(
              _selectedSpeciality.toLowerCase(),
            ),
          )
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      doctors = doctors
          .where(
            (doctor) =>
                doctor.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                doctor.speciality.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    // Sort by availability and rating
    doctors.sort((a, b) {
      // Online doctors first
      if (a.status == 'online' && b.status != 'online') return -1;
      if (b.status == 'online' && a.status != 'online') return 1;

      // Then by rating
      return b.rating.compareTo(a.rating);
    });

    return doctors;
  }

  Future<void> _joinDoctorQueue(Doctor doctor) async {
    if (_symptomsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe your symptoms before joining queue'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Joining queue...'),
          ],
        ),
      ),
    );

    try {
      final result = await _doctorService.joinDoctorQueue(
        doctor.id,
        widget.patientId,
      );

      if (mounted) Navigator.pop(context); // Close loading dialog

      if (result['success']) {
        final position = result['position'];
        final estimatedWaitTime = result['estimatedWaitTime'];

        // Show queue position dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Joined Queue for Dr. ${doctor.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your position: #$position'),
                const SizedBox(height: 8),
                Text('Estimated wait time: $estimatedWaitTime minutes'),
                const SizedBox(height: 16),
                const Text(
                  'You will be notified when it\'s your turn. If you are next in line, the video call will start automatically.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // If patient is first in queue, start video call immediately
                  if (position == 1) {
                    _startVideoConsultation(doctor);
                  }
                },
                child: Text(position == 1 ? 'Start Video Call' : 'OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join queue: ${result['error']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error joining queue: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startVideoConsultation(Doctor doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RealtimeVideoCallScreen(
          doctor: doctor,
          patientId: widget.patientId,
          patientName: widget.patientName,
          symptoms: _symptomsController.text.trim(),
        ),
      ),
    );
  }

  void _showDoctorDetails(Doctor doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DoctorDetailsSheet(
        doctor: doctor,
        patientId: widget.patientId,
        patientName: widget.patientName,
        symptoms: _symptomsController.text.trim(),
        onJoinQueue: () {
          Navigator.pop(context);
          _joinDoctorQueue(doctor);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Choose Doctor'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search doctors by name or speciality',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Speciality filter
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _specialities.length,
                    itemBuilder: (context, index) {
                      final speciality = _specialities[index];
                      final isSelected = _selectedSpeciality == speciality;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(speciality),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedSpeciality = speciality;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: Colors.blue[100],
                          checkmarkColor: Colors.blue[600],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Symptoms input
                TextField(
                  controller: _symptomsController,
                  decoration: InputDecoration(
                    hintText: 'Describe your symptoms (required)',
                    prefixIcon: const Icon(Icons.medical_services),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),

          // Doctors list
          Expanded(
            child: Consumer<DoctorService>(
              builder: (context, doctorService, child) {
                final filteredDoctors = _getFilteredDoctors();

                if (doctorService.onlineDoctors.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No doctors online',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Please try again later',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (filteredDoctors.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No doctors found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await doctorService.refreshDoctors();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = filteredDoctors[index];
                      final queueCount = doctorService
                          .getDoctorQueue(doctor.id)
                          .length;
                      final isInQueue = doctorService.isPatientInQueue(
                        doctor.id,
                        widget.patientId,
                      );
                      final position = isInQueue
                          ? doctorService.getPatientPosition(
                              doctor.id,
                              widget.patientId,
                            )
                          : -1;

                      return DoctorCard(
                        doctor: doctor,
                        queueCount: queueCount,
                        isInQueue: isInQueue,
                        position: position,
                        onTap: () => _showDoctorDetails(doctor),
                        onJoinQueue: () => _joinDoctorQueue(doctor),
                        onStartConsultation: () =>
                            _startVideoConsultation(doctor),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual doctor card widget
class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final int queueCount;
  final bool isInQueue;
  final int position;
  final VoidCallback onTap;
  final VoidCallback onJoinQueue;
  final VoidCallback onStartConsultation;

  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.queueCount,
    required this.isInQueue,
    required this.position,
    required this.onTap,
    required this.onJoinQueue,
    required this.onStartConsultation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Doctor avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue[100],
                    backgroundImage: doctor.profileImage != null
                        ? NetworkImage(doctor.profileImage!)
                        : null,
                    child: doctor.profileImage == null
                        ? Icon(Icons.person, size: 30, color: Colors.blue[600])
                        : null,
                  ),
                  const SizedBox(width: 16),

                  // Doctor info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Dr. ${doctor.name}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: doctor.status == 'online'
                                    ? Colors.green
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    doctor.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor.speciality,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${doctor.rating.toStringAsFixed(1)} (${doctor.totalRatings})',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${doctor.experience} years',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Queue info and consultation fee
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isInQueue
                            ? Colors.blue[50]
                            : queueCount > 0
                            ? Colors.orange[50]
                            : Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isInQueue
                              ? Colors.blue[200]!
                              : queueCount > 0
                              ? Colors.orange[200]!
                              : Colors.green[200]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isInQueue ? Icons.schedule : Icons.people,
                            size: 16,
                            color: isInQueue
                                ? Colors.blue[600]
                                : queueCount > 0
                                ? Colors.orange[600]
                                : Colors.green[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isInQueue
                                ? 'You are #$position in queue'
                                : queueCount > 0
                                ? '$queueCount patients waiting'
                                : 'Available now',
                            style: TextStyle(
                              fontSize: 12,
                              color: isInQueue
                                  ? Colors.blue[600]
                                  : queueCount > 0
                                  ? Colors.orange[600]
                                  : Colors.green[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '₹${doctor.consultationFee.toInt()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isInQueue && position == 1
                      ? onStartConsultation
                      : !isInQueue
                      ? onJoinQueue
                      : null,
                  icon: Icon(
                    isInQueue && position == 1
                        ? Icons.video_call
                        : Icons.schedule,
                  ),
                  label: Text(
                    isInQueue && position == 1
                        ? 'Start Video Call Now'
                        : isInQueue
                        ? 'Waiting in Queue (#$position)'
                        : 'Join Queue for Video Call',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInQueue && position == 1
                        ? Colors.green[600]
                        : Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet showing detailed doctor information
class DoctorDetailsSheet extends StatelessWidget {
  final Doctor doctor;
  final String patientId;
  final String patientName;
  final String symptoms;
  final VoidCallback onJoinQueue;

  const DoctorDetailsSheet({
    Key? key,
    required this.doctor,
    required this.patientId,
    required this.patientName,
    required this.symptoms,
    required this.onJoinQueue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue[100],
                      backgroundImage: doctor.profileImage != null
                          ? NetworkImage(doctor.profileImage!)
                          : null,
                      child: doctor.profileImage == null
                          ? Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.blue[600],
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. ${doctor.name}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            doctor.speciality,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.amber[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${doctor.rating.toStringAsFixed(1)} (${doctor.totalRatings} reviews)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Details
                _buildDetailRow('Experience', '${doctor.experience} years'),
                _buildDetailRow('Qualification', doctor.qualification),
                _buildDetailRow('Languages', doctor.languages.join(', ')),
                _buildDetailRow(
                  'Consultation Fee',
                  '₹${doctor.consultationFee.toInt()}',
                ),
                _buildDetailRow(
                  'Total Consultations',
                  '${doctor.totalConsultations}',
                ),

                const SizedBox(height: 24),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onJoinQueue,
                    icon: const Icon(Icons.schedule),
                    label: const Text('Join Queue for Video Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
