import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/patient_profile.dart';
import '../providers/patient_profile_provider.dart';
import '../services/auth_service.dart';
import '../services/image_upload_service.dart';
import '../services/patient_profile_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'medical_details_screen.dart';
import 'medical_records_screen.dart';
import 'package:provider/provider.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  PatientProfile? _profile;
  bool _isLoading = false;
  bool _isEditing = false;
  bool _isUploadingPhoto = false;

  String _selectedGender = '';
  String _selectedBloodGroup = '';
  DateTime? _selectedDateOfBirth;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    try {
      // Try to load from provider
      PatientProfile? profile;
      try {
        await Provider.of<PatientProfileProvider>(
          context,
          listen: false,
        ).loadProfile();

        profile = Provider.of<PatientProfileProvider>(
          context,
          listen: false,
        ).profile;
      } catch (e) {
        print('Failed to load profile: $e');
      }

      if (profile != null) {
        setState(() {
          _profile = profile;
          _populateFields();
        });
      } else {
        // Fallback to user service
        final user = await AuthService().getCurrentUser();
        if (user != null) {
          // Create profile from user data
          _profile = PatientProfile(
            id: user.id,
            fullName: user.name,
            email: user.email ?? '',
            phoneNumber: user.email ?? '',
            dateOfBirth: DateTime.now().subtract(
              const Duration(days: 365 * 25),
            ),
            gender: 'Not specified',
            bloodGroup: '',
            address: '',
            emergencyContact: '',
            emergencyContactPhone: '',
            profilePhotoUrl: '',
            allergies: [],
            medications: [],
            medicalHistory: {},
            lastVisit: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          setState(() {
            _populateFields();
          });
        } else {
          // Create default profile if no data available
          _profile = PatientProfile(
            id: 'default',
            fullName: 'User',
            email: '',
            phoneNumber: '',
            dateOfBirth: DateTime.now().subtract(
              const Duration(days: 365 * 25),
            ),
            gender: 'Not specified',
            bloodGroup: '',
            address: '',
            emergencyContact: '',
            emergencyContactPhone: '',
            profilePhotoUrl: '',
            allergies: [],
            medications: [],
            medicalHistory: {},
            lastVisit: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          setState(() {
            _populateFields();
          });
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.cast<String>();
    if (value is String) {
      try {
        // Try to parse as JSON array
        final parsed = value.replaceAll('[', '').replaceAll(']', '').split(',');
        return parsed
            .map((e) => e.trim().replaceAll('"', ''))
            .where((e) => e.isNotEmpty)
            .toList();
      } catch (e) {
        return [value];
      }
    }
    return [];
  }

  Map<String, dynamic> _parseMap(dynamic value) {
    if (value == null) return {};
    if (value is Map<String, dynamic>) return value;
    if (value is String && value.isNotEmpty) {
      return {'notes': value};
    }
    return {};
  }

  void _populateFields() {
    if (_profile != null) {
      _phoneController.text = _profile!.phoneNumber;
      _addressController.text = _profile!.address;
      _emergencyContactController.text = _profile!.emergencyContact;
      _emergencyPhoneController.text = _profile!.emergencyContactPhone;
      _selectedGender = _profile!.gender;
      _selectedBloodGroup = _profile!.bloodGroup;
      _selectedDateOfBirth = _profile!.dateOfBirth;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _profile == null) return;

    setState(() => _isLoading = true);

    try {
      final updatedProfile = _profile!.copyWith(
        phoneNumber: _phoneController.text.trim(),
        dateOfBirth: _selectedDateOfBirth ?? _profile!.dateOfBirth,
        gender: _selectedGender,
        bloodGroup: _selectedBloodGroup,
        address: _addressController.text.trim(),
        emergencyContact: _emergencyContactController.text.trim(),
        emergencyContactPhone: _emergencyPhoneController.text.trim(),
      );

      await Provider.of<PatientProfileProvider>(
        context,
        listen: false,
      ).updateProfile(updatedProfile);

      setState(() {
        _profile = updatedProfile;
        _isEditing = false;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
    );

    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  Future<void> _uploadProfilePhoto() async {
    try {
      setState(() => _isUploadingPhoto = true);

      final XFile? imageFile =
          await ImageUploadService.showImagePickerOptions();
      if (imageFile == null) return;

      final currentUser = await AuthService().getCurrentUser();
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final imageUrl = await PatientProfileService.uploadProfilePhoto(
        userId: currentUser.id,
        imageFile: imageFile,
      );

      if (imageUrl != null && mounted) {
        // Reload profile to get updated data
        await _loadProfile();
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  Future<void> _removeProfilePhoto() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Profile Photo'),
        content: const Text(
          'Are you sure you want to remove your profile photo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isUploadingPhoto = true);

      try {
        final success = await PatientProfileService.removeProfilePhoto();
        if (success && mounted) {
          await _loadProfile();
        }
      } finally {
        if (mounted) {
          setState(() => _isUploadingPhoto = false);
        }
      }
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _uploadProfilePhoto();
              },
            ),
            if (ImageUploadService.isValidImageUrl(_profile?.profilePhotoUrl))
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo'),
                textColor: Colors.red,
                onTap: () {
                  Navigator.of(context).pop();
                  _removeProfilePhoto();
                },
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
        actions: [
          if (!_isEditing && _profile != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: _profile == null
          ? const Center(child: Text('Unable to load profile'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Theme.of(context).primaryColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor:
                                    ImageUploadService.isValidImageUrl(
                                      _profile!.profilePhotoUrl,
                                    )
                                    ? null
                                    : Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                backgroundImage:
                                    ImageUploadService.isValidImageUrl(
                                      _profile!.profilePhotoUrl,
                                    )
                                    ? NetworkImage(_profile!.profilePhotoUrl)
                                    : null,
                                child:
                                    !ImageUploadService.isValidImageUrl(
                                      _profile!.profilePhotoUrl,
                                    )
                                    ? Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Theme.of(context).primaryColor,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _isUploadingPhoto
                                      ? null
                                      : () {
                                          _showPhotoOptions();
                                        },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: _isUploadingPhoto
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.camera_alt,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _profile!.fullName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _profile!.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (_profile!.age > 0) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Age: ${_profile!.age} years',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Basic Information
                    _buildSectionCard('Basic Information', [
                      CustomTextField(
                        controller: _phoneController,
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        enabled: _isEditing,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date of Birth
                      GestureDetector(
                        onTap: _isEditing ? _selectDateOfBirth : null,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                            color: _isEditing ? Colors.white : Colors.grey[100],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date of Birth',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedDateOfBirth != null
                                          ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                                          : 'Select date of birth',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_isEditing)
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Gender
                      _buildDropdownField(
                        'Gender',
                        _selectedGender,
                        _genderOptions,
                        Icons.person_outline,
                        (value) =>
                            setState(() => _selectedGender = value ?? ''),
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),

                      // Blood Group
                      _buildDropdownField(
                        'Blood Group',
                        _selectedBloodGroup,
                        _bloodGroups,
                        Icons.bloodtype,
                        (value) =>
                            setState(() => _selectedBloodGroup = value ?? ''),
                        enabled: _isEditing,
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Contact Information
                    _buildSectionCard('Contact Information', [
                      CustomTextField(
                        controller: _addressController,
                        labelText: 'Address',
                        hintText: 'Enter your address',
                        prefixIcon: Icons.location_on,
                        maxLines: 3,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _emergencyContactController,
                        labelText: 'Emergency Contact Name',
                        hintText: 'Enter emergency contact name',
                        prefixIcon: Icons.emergency,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _emergencyPhoneController,
                        labelText: 'Emergency Contact Phone',
                        hintText: 'Enter emergency contact phone',
                        prefixIcon: Icons.phone_in_talk,
                        keyboardType: TextInputType.phone,
                        enabled: _isEditing,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Medical Information
                    _buildSectionCard('Medical Information', [
                      if (_profile!.allergies.isNotEmpty) ...[
                        _buildInfoRow(
                          'Allergies',
                          _profile!.allergies.join(', '),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (_profile!.medications.isNotEmpty) ...[
                        _buildInfoRow(
                          'Current Medications',
                          _profile!.medications.join(', '),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (_profile!.lastVisit != null)
                        _buildInfoRow(
                          'Last Visit',
                          '${_profile!.lastVisit!.day}/${_profile!.lastVisit!.month}/${_profile!.lastVisit!.year}',
                        ),
                      if (_profile!.allergies.isEmpty &&
                          _profile!.medications.isEmpty &&
                          _profile!.lastVisit == null)
                        Text(
                          'No medical information available',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ]),

                    const SizedBox(height: 24),

                    // Medical Information Actions
                    if (!_isEditing)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.medical_services,
                                  color: Colors.teal,
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Medical Management',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final result = await Navigator.of(context)
                                          .push<PatientProfile>(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MedicalDetailsScreen(
                                                    profile: _profile!,
                                                  ),
                                            ),
                                          );
                                      if (result != null) {
                                        setState(() {
                                          _profile = result;
                                          _populateFields();
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.edit_note),
                                    label: const Text('Manage Medical Details'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MedicalRecordsScreen(
                                                patientId: _profile!.id,
                                              ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.folder_open),
                                    label: const Text('Medical Records'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    if (_isEditing) ...[
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Cancel',
                              onPressed: () {
                                setState(() {
                                  _isEditing = false;
                                  _populateFields(); // Reset fields
                                });
                              },
                              backgroundColor: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              text: 'Save Changes',
                              onPressed: _saveProfile,
                              isLoading: _isLoading,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> options,
    IconData icon,
    ValueChanged<String?> onChanged, {
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
            filled: true,
            fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
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
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(value: option, child: Text(option));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
