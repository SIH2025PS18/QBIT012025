import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../widgets/sidebar.dart';

class AppointmentManagementScreen extends StatefulWidget {
  const AppointmentManagementScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentManagementScreen> createState() =>
      _AppointmentManagementScreenState();
}

class _AppointmentManagementScreenState
    extends State<AppointmentManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  List<Appointment> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDemoAppointments();
  }

  void _loadDemoAppointments() {
    // Demo data for appointments
    _appointments = [
      Appointment(
        id: '1',
        patientId: 'P001',
        patientName: 'John Doe',
        doctorId: 'D001',
        doctorName: 'Dr. Sarah Smith',
        department: 'Cardiology',
        appointmentDate: DateTime.now().add(const Duration(days: 1)),
        timeSlot: '10:00 AM - 10:30 AM',
        status: 'confirmed',
        reason: 'Regular checkup',
        patientPhone: '+91 9876543210',
        patientEmail: 'john.doe@email.com',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Appointment(
        id: '2',
        patientId: 'P002',
        patientName: 'Jane Smith',
        doctorId: 'D002',
        doctorName: 'Dr. Michael Johnson',
        department: 'Neurology',
        appointmentDate: DateTime.now().add(const Duration(days: 3)),
        timeSlot: '2:00 PM - 2:30 PM',
        status: 'pending',
        reason: 'Headache consultation',
        patientPhone: '+91 9876543211',
        patientEmail: 'jane.smith@email.com',
        isEmergency: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      Appointment(
        id: '3',
        patientId: 'P003',
        patientName: 'Robert Brown',
        doctorId: 'D003',
        doctorName: 'Dr. Emily Davis',
        department: 'Orthopedics',
        appointmentDate: DateTime.now().subtract(const Duration(days: 1)),
        timeSlot: '11:00 AM - 11:30 AM',
        status: 'completed',
        reason: 'Knee pain',
        notes: 'Prescribed physiotherapy',
        patientPhone: '+91 9876543212',
        patientEmail: 'robert.brown@email.com',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Appointment(
        id: '4',
        patientId: 'P004',
        patientName: 'Lisa Wilson',
        doctorId: 'D001',
        doctorName: 'Dr. Sarah Smith',
        department: 'Cardiology',
        appointmentDate: DateTime.now().add(const Duration(hours: 2)),
        timeSlot: '4:00 PM - 4:30 PM',
        status: 'confirmed',
        reason: 'Emergency consultation',
        patientPhone: '+91 9876543213',
        patientEmail: 'lisa.wilson@email.com',
        isEmergency: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Appointment(
        id: '5',
        patientId: 'P005',
        patientName: 'David Garcia',
        doctorId: 'D004',
        doctorName: 'Dr. James Wilson',
        department: 'Dermatology',
        appointmentDate: DateTime.now().add(const Duration(days: 7)),
        timeSlot: '9:00 AM - 9:30 AM',
        status: 'cancelled',
        reason: 'Skin allergy',
        notes: 'Patient cancelled due to travel',
        patientPhone: '+91 9876543214',
        patientEmail: 'david.garcia@email.com',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildAppointmentsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1D29),
        border: Border(bottom: BorderSide(color: Color(0xFF2A2D3F))),
      ),
      child: Row(
        children: [
          const Text(
            'Appointment Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _buildStatsCards(),
          const SizedBox(width: 24),
          ElevatedButton.icon(
            onPressed: _showNewAppointmentDialog,
            icon: const Icon(Icons.add),
            label: const Text('New Appointment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B9D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final today = DateTime.now();
    final todayAppointments = _appointments.where((apt) => apt.isToday).length;
    final pendingAppointments =
        _appointments.where((apt) => apt.status == 'pending').length;
    final emergencyAppointments =
        _appointments.where((apt) => apt.isEmergency && apt.isUpcoming).length;

    return Row(
      children: [
        _buildStatCard('Today', todayAppointments.toString(), Colors.blue),
        const SizedBox(width: 12),
        _buildStatCard(
            'Pending', pendingAppointments.toString(), Colors.orange),
        const SizedBox(width: 12),
        _buildStatCard(
            'Emergency', emergencyAppointments.toString(), Colors.red),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return Column(
      children: [
        _buildFiltersAndSearch(),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF6B9D)),
                )
              : _buildAppointmentsGrid(),
        ),
      ],
    );
  }

  Widget _buildFiltersAndSearch() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search appointments...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFF1A1D29),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          DropdownButton<String>(
            value: _selectedFilter,
            dropdownColor: const Color(0xFF1A1D29),
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Appointments')),
              DropdownMenuItem(value: 'today', child: Text('Today')),
              DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
              DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
              DropdownMenuItem(value: 'completed', child: Text('Completed')),
              DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              DropdownMenuItem(value: 'emergency', child: Text('Emergency')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedFilter = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsGrid() {
    final filteredAppointments = _getFilteredAppointments();

    if (filteredAppointments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        return _buildAppointmentCard(filteredAppointments[index]);
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appointment.isEmergency
              ? Colors.red.withOpacity(0.5)
              : const Color(0xFF2A2D3F),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: appointment.statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          appointment.patientName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (appointment.isEmergency) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'EMERGENCY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'with ${appointment.doctorName} • ${appointment.department}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: appointment.statusColor.withOpacity(0.1),
                  border: Border.all(
                      color: appointment.statusColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  appointment.status.toUpperCase(),
                  style: TextStyle(
                    color: appointment.statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(Icons.calendar_today, appointment.formattedDate),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.access_time, appointment.timeSlot),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.phone, appointment.patientPhone ?? 'N/A'),
            ],
          ),
          if (appointment.reason != null) ...[
            const SizedBox(height: 12),
            Text(
              'Reason: ${appointment.reason}',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
            ),
          ],
          if (appointment.notes != null) ...[
            const SizedBox(height: 4),
            Text(
              'Notes: ${appointment.notes}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
              if (appointment.status == 'pending') ...[
                ElevatedButton(
                  onPressed: () =>
                      _updateAppointmentStatus(appointment, 'confirmed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Confirm'),
                ),
                const SizedBox(width: 8),
              ],
              if (appointment.status == 'confirmed' &&
                  appointment.isUpcoming) ...[
                ElevatedButton(
                  onPressed: () =>
                      _updateAppointmentStatus(appointment, 'completed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Complete'),
                ),
                const SizedBox(width: 8),
              ],
              if (appointment.status != 'cancelled' &&
                  appointment.status != 'completed') ...[
                ElevatedButton(
                  onPressed: () =>
                      _updateAppointmentStatus(appointment, 'cancelled'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
              ],
              IconButton(
                onPressed: () => _showAppointmentDetails(appointment),
                icon: const Icon(Icons.visibility, color: Colors.blue),
                tooltip: 'View Details',
              ),
              IconButton(
                onPressed: () => _editAppointment(appointment),
                icon: const Icon(Icons.edit, color: Colors.orange),
                tooltip: 'Edit Appointment',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3F),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[400]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No Appointments Found',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Schedule your first appointment to get started',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _showNewAppointmentDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B9D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Schedule Appointment'),
          ),
        ],
      ),
    );
  }

  List<Appointment> _getFilteredAppointments() {
    var filtered = _appointments;

    // Filter by search text
    if (_searchController.text.isNotEmpty) {
      final searchLower = _searchController.text.toLowerCase();
      filtered = filtered.where((appointment) {
        return appointment.patientName.toLowerCase().contains(searchLower) ||
            appointment.doctorName.toLowerCase().contains(searchLower) ||
            appointment.department.toLowerCase().contains(searchLower) ||
            appointment.status.toLowerCase().contains(searchLower);
      }).toList();
    }

    // Filter by status/type
    switch (_selectedFilter) {
      case 'today':
        filtered =
            filtered.where((appointment) => appointment.isToday).toList();
        break;
      case 'upcoming':
        filtered =
            filtered.where((appointment) => appointment.isUpcoming).toList();
        break;
      case 'pending':
        filtered = filtered
            .where((appointment) => appointment.status == 'pending')
            .toList();
        break;
      case 'confirmed':
        filtered = filtered
            .where((appointment) => appointment.status == 'confirmed')
            .toList();
        break;
      case 'completed':
        filtered = filtered
            .where((appointment) => appointment.status == 'completed')
            .toList();
        break;
      case 'cancelled':
        filtered = filtered
            .where((appointment) => appointment.status == 'cancelled')
            .toList();
        break;
      case 'emergency':
        filtered =
            filtered.where((appointment) => appointment.isEmergency).toList();
        break;
    }

    // Sort by appointment date
    filtered.sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

    return filtered;
  }

  void _updateAppointmentStatus(Appointment appointment, String newStatus) {
    setState(() {
      final index = _appointments.indexWhere((apt) => apt.id == appointment.id);
      if (index != -1) {
        _appointments[index] = appointment.copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment ${newStatus}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D29),
        title: Text(
          'Appointment Details',
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Patient', appointment.patientName),
              _buildDetailRow('Doctor', appointment.doctorName),
              _buildDetailRow('Department', appointment.department),
              _buildDetailRow('Date', appointment.formattedDate),
              _buildDetailRow('Time', appointment.timeSlot),
              _buildDetailRow('Status', appointment.status.toUpperCase()),
              if (appointment.reason != null)
                _buildDetailRow('Reason', appointment.reason!),
              if (appointment.notes != null)
                _buildDetailRow('Notes', appointment.notes!),
              if (appointment.patientPhone != null)
                _buildDetailRow('Phone', appointment.patientPhone!),
              if (appointment.patientEmail != null)
                _buildDetailRow('Email', appointment.patientEmail!),
              _buildDetailRow(
                  'Emergency', appointment.isEmergency ? 'Yes' : 'No'),
              _buildDetailRow(
                  'Created', appointment.createdAt.toString().substring(0, 16)),
              if (appointment.updatedAt != null)
                _buildDetailRow('Updated',
                    appointment.updatedAt.toString().substring(0, 16)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Close', style: TextStyle(color: Color(0xFFFF6B9D))),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _editAppointment(Appointment appointment) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit appointment functionality coming soon'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showNewAppointmentDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New appointment scheduling coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
