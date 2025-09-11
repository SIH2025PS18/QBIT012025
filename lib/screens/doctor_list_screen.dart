import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/doctor.dart';
import '../services/doctor_service.dart';
import '../widgets/custom_text_field.dart';
import 'appointment_booking_screen.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final _searchController = TextEditingController();

  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  List<String> _specialities = [];

  bool _isLoading = true;
  bool _isSearching = false;
  String _selectedSpeciality = '';
  bool _showOnlineOnly = false;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    _loadSpecialities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);

    try {
      // Load doctors from backend API
      final doctors = await DoctorService.getAvailableDoctors();
      setState(() {
        _doctors = doctors;
        _filteredDoctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.errorLoadingDoctors}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadSpecialities() async {
    final specialities = await DoctorService.getSpecializations();
    setState(() {
      _specialities = ['All Specialities', ...specialities];
    });
  }

  void _filterDoctors() {
    setState(() => _isSearching = true);

    List<Doctor> filtered = List.from(_doctors);

    // Filter by search query
    final searchQuery = _searchController.text.trim().toLowerCase();
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((doctor) {
        return doctor.name.toLowerCase().contains(searchQuery) ||
            doctor.speciality.toLowerCase().contains(searchQuery) ||
            doctor.qualification.toLowerCase().contains(searchQuery);
      }).toList();
    }

    // Filter by speciality
    if (_selectedSpeciality.isNotEmpty &&
        _selectedSpeciality != 'All Specialities') {
      filtered = filtered.where((doctor) {
        return doctor.speciality.toLowerCase().contains(
          _selectedSpeciality.toLowerCase(),
        );
      }).toList();
    }

    // Filter by online status
    if (_showOnlineOnly) {
      filtered = filtered.where((doctor) => doctor.isAvailable).toList();
    }

    setState(() {
      _filteredDoctors = filtered;
      _isSearching = false;
    });
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedSpeciality = '';
      _showOnlineOnly = false;
      _filteredDoctors = _doctors;
    });
  }

  Future<void> _createSampleData() async {
    setState(() => _isLoading = true);
    await DoctorService.createSampleDoctors();
    await _loadDoctors();
    await _loadSpecialities();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.findDoctors),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: _createSampleData,
            tooltip: 'Add Sample Doctors',
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadDoctors),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: [
                // Search Bar
                CustomTextField(
                  controller: _searchController,
                  labelText: 'Search doctors',
                  hintText: 'Enter doctor name or speciality',
                  prefixIcon: Icons.search,
                  onChanged: (value) => _filterDoctors(),
                ),

                const SizedBox(height: 16),

                // Filters
                Row(
                  children: [
                    // Speciality Dropdown
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedSpeciality.isEmpty
                            ? null
                            : _selectedSpeciality,
                        decoration: InputDecoration(
                          labelText: 'Speciality',
                          prefixIcon: const Icon(
                            Icons.medical_services,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        items: _specialities.map((String speciality) {
                          return DropdownMenuItem<String>(
                            value: speciality,
                            child: Text(
                              speciality,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedSpeciality = value ?? '';
                          });
                          _filterDoctors();
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Online Only Toggle
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CheckboxListTile(
                          title: const Text(
                            'Online Now',
                            style: TextStyle(fontSize: 12),
                          ),
                          value: _showOnlineOnly,
                          onChanged: (bool? value) {
                            setState(() {
                              _showOnlineOnly = value ?? false;
                            });
                            _filterDoctors();
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Clear Filters Button
                if (_searchController.text.isNotEmpty ||
                    _selectedSpeciality.isNotEmpty ||
                    _showOnlineOnly)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear, size: 16),
                        label: Text(l10n.clearFilters),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredDoctors.isEmpty
                ? _buildEmptyState(l10n)
                : _buildDoctorList(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _doctors.isEmpty ? 'No doctors available' : 'No doctors found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _doctors.isEmpty
                ? 'Please add some doctors first'
                : 'Try adjusting your search or filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          if (_doctors.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createSampleData,
              icon: const Icon(Icons.add),
              label: Text(l10n.addSampleDoctors),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDoctorList(AppLocalizations l10n) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredDoctors.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doctor = _filteredDoctors[index];
        return _buildDoctorCard(doctor, l10n);
      },
    );
  }

  Widget _buildDoctorCard(Doctor doctor, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Header
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                child: Text(
                  doctor.name.split(' ').map((name) => name[0]).take(2).join(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.speciality,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.qualification,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: doctor.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: doctor.statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      doctor.availabilityStatus,
                      style: TextStyle(
                        fontSize: 10,
                        color: doctor.statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Doctor Details
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.work_outline,
                  doctor.experienceText,
                ),
              ),
              Expanded(
                child: _buildDetailItem(Icons.star_outline, doctor.ratingText),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.language,
                  doctor.languages.take(2).join(', '),
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  Icons.payment,
                  doctor.consultationFeeText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDoctorDetails(doctor);
                  },
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: Text(l10n.viewDetails),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: doctor.isAvailable
                      ? () {
                          _bookAppointment(doctor);
                        }
                      : null,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(l10n.bookNow),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showDoctorDetails(Doctor doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DoctorDetailsModal(doctor: doctor),
    );
  }

  void _bookAppointment(Doctor doctor) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AppointmentBookingScreen(doctor: doctor),
      ),
    );
  }
}

class DoctorDetailsModal extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsModal({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Doctor Header
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                child: Text(
                  doctor.name.split(' ').map((name) => name[0]).take(2).join(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.speciality,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.qualification,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Details Cards
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDetailCard(
                    'Experience',
                    doctor.experienceText,
                    Icons.work,
                  ),
                  _buildDetailCard('Rating', doctor.ratingText, Icons.star),
                  _buildDetailCard(
                    'Consultation Fee',
                    doctor.consultationFeeText,
                    Icons.payment,
                  ),
                  _buildDetailCard(
                    'Languages',
                    doctor.languages.join(', '),
                    Icons.language,
                  ),
                  _buildDetailCard(
                    'Availability',
                    doctor.availabilityStatus,
                    Icons.schedule,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: doctor.isAvailable
                  ? () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AppointmentBookingScreen(doctor: doctor),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.calendar_today),
              label: const Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
