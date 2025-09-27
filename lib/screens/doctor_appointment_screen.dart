import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telemed/providers/theme_provider.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../services/doctor_provider.dart';
import '../services/appointment_service.dart';
import 'appointment_booking_screen.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  const DoctorAppointmentScreen({super.key});

  @override
  State<DoctorAppointmentScreen> createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Doctor> _doctors = [];
  List<Appointment> _myAppointments = [];
  bool _isLoading = true;
  String _selectedSpecialty = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Load doctors from the provider
      final doctorService = Provider.of<DoctorService>(context, listen: false);
      doctorService.initialize();

      // Load user appointments
      final appointments = await AppointmentService.getUserAppointments();

      setState(() {
        _doctors = doctorService.allDoctors;
        _myAppointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
      }
    }
  }

  List<Doctor> get _filteredDoctors {
    return _doctors.where((doctor) {
      bool matchesSpecialty =
          _selectedSpecialty == 'All' ||
          doctor.speciality.toLowerCase().contains(
            _selectedSpecialty.toLowerCase(),
          );
      bool matchesSearch =
          _searchQuery.isEmpty ||
          doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.speciality.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSpecialty && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.cardBackgroundColor,
        elevation: 1,
        title: Text(
          'Book Appointment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: themeProvider.primaryTextColor),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue[600],
          unselectedLabelColor: themeProvider.secondaryTextColor,
          indicatorColor: Colors.blue[600],
          tabs: [
            Tab(icon: Icon(Icons.person_search), text: 'Find Doctors'),
            Tab(icon: Icon(Icons.calendar_today), text: 'My Appointments'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildDoctorListTab(), _buildMyAppointmentsTab()],
      ),
    );
  }

  Widget _buildDoctorListTab() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Search and filter section
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search bar
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search doctors by name or specialty...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue[600]!),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Specialty filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildSpecialtyChip('All'),
                    _buildSpecialtyChip('General Medicine'),
                    _buildSpecialtyChip('Pediatrics'),
                    _buildSpecialtyChip('Cardiology'),
                    _buildSpecialtyChip('Dermatology'),
                    _buildSpecialtyChip('Gynecology'),
                    _buildSpecialtyChip('Orthopedics'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Doctors list
        Expanded(
          child: _filteredDoctors.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No doctors found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your search or filters',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = _filteredDoctors[index];
                    return _buildDoctorCard(doctor);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSpecialtyChip(String specialty) {
    final isSelected = _selectedSpecialty == specialty;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(specialty),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedSpecialty = specialty);
        },
        backgroundColor: Colors.grey[100],
        selectedColor: Colors.blue[100],
        labelStyle: TextStyle(
          color: isSelected ? Colors.blue[700] : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  child: Text(
                    doctor.name.isNotEmpty ? doctor.name[0].toUpperCase() : 'D',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Doctor info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.speciality,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${doctor.rating} (${doctor.totalRatings} reviews)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Online status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: doctor.status == 'online'
                        ? Colors.green[100]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    doctor.status == 'online' ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: doctor.status == 'online'
                          ? Colors.green[700]
                          : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Experience and fee
            Row(
              children: [
                Icon(Icons.work_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${doctor.experience} years experience',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.currency_rupee, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '₹${doctor.consultationFee}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Book appointment button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AppointmentBookingScreen(doctor: doctor),
                    ),
                  ).then((_) => _loadData()); // Refresh data when returning
                },
                icon: Icon(Icons.calendar_today),
                label: Text('Book Appointment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
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
    );
  }

  Widget _buildMyAppointmentsTab() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_myAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No appointments yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Book your first appointment from the Find Doctors tab',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(0),
              icon: Icon(Icons.add),
              label: Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _myAppointments.length,
      itemBuilder: (context, index) {
        final appointment = _myAppointments[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final isUpcoming = appointment.appointmentDate.isAfter(DateTime.now());
    final statusColor = _getStatusColor(appointment.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.doctorSpecialization,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    appointment.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '${appointment.appointmentDate.day}/${appointment.appointmentDate.month}/${appointment.appointmentDate.year}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '${appointment.appointmentDate.hour.toString().padLeft(2, '0')}:${appointment.appointmentDate.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),

            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${appointment.notes}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            if (isUpcoming) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Handle reschedule
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Reschedule feature coming soon'),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit_calendar, size: 16),
                      label: Text('Reschedule'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[600],
                        side: BorderSide(color: Colors.blue[600]!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showCancelConfirmation(appointment);
                      },
                      icon: Icon(Icons.cancel, size: 16),
                      label: Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[600],
                        side: BorderSide(color: Colors.red[600]!),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'no-show':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showCancelConfirmation(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Appointment'),
        content: Text(
          'Are you sure you want to cancel this appointment with ${appointment.doctorName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelAppointment(appointment);
            },
            child: Text('Yes, Cancel'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelAppointment(Appointment appointment) async {
    try {
      await AppointmentService.cancelAppointment(appointment.id);
      await _loadData(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel appointment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
