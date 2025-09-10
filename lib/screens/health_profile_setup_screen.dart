import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/patient_profile.dart';
import '../services/supabase_patient_profile_service.dart';
import '../services/supabase_auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'nabha_home_screen.dart';

class HealthProfileSetupScreen extends StatefulWidget {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;

  const HealthProfileSetupScreen({
    super.key,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  @override
  State<HealthProfileSetupScreen> createState() =>
      _HealthProfileSetupScreenState();
}

class _HealthProfileSetupScreenState extends State<HealthProfileSetupScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _dateOfBirthController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _allergyController = TextEditingController();
  final _medicationController = TextEditingController();

  // State variables
  String _selectedGender = '';
  String _selectedBloodGroup = '';
  DateTime? _selectedDateOfBirth;
  List<String> _allergies = [];
  List<String> _medications = [];

  bool _isLoading = false;

  // Animation controllers
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  // Options
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];
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
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutBack,
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _dateOfBirthController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _allergyController.dispose();
    _medicationController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
        _dateOfBirthController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _addAllergy() {
    final allergy = _allergyController.text.trim();
    if (allergy.isNotEmpty && !_allergies.contains(allergy)) {
      setState(() {
        _allergies.add(allergy);
        _allergyController.clear();
      });
      // Show a brief confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added allergy: $allergy'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green.withOpacity(0.8),
        ),
      );
    }
  }

  void _removeAllergy(String allergy) {
    setState(() {
      _allergies.remove(allergy);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed allergy: $allergy'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.orange.withOpacity(0.8),
      ),
    );
  }

  void _addMedication() {
    final medication = _medicationController.text.trim();
    if (medication.isNotEmpty && !_medications.contains(medication)) {
      setState(() {
        _medications.add(medication);
        _medicationController.clear();
      });
      // Show a brief confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added medication: $medication'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green.withOpacity(0.8),
        ),
      );
    }
  }

  void _removeMedication(String medication) {
    setState(() {
      _medications.remove(medication);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed medication: $medication'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.orange.withOpacity(0.8),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Create a new patient profile with all the information
      final profile = PatientProfile(
        id: widget.userId,
        fullName: widget.fullName,
        email: widget.email,
        phoneNumber: widget.phoneNumber,
        dateOfBirth: _selectedDateOfBirth ?? DateTime.now(),
        gender: _selectedGender,
        bloodGroup: _selectedBloodGroup,
        address: _addressController.text.trim(),
        emergencyContact: _emergencyContactController.text.trim(),
        emergencyContactPhone: _emergencyPhoneController.text.trim(),
        allergies: _allergies,
        medications: _medications,
        medicalHistory: {
          'notes': '',
          'lastUpdated': DateTime.now().toIso8601String(),
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = await PatientProfileService.savePatientProfile(profile);

      if (success && mounted) {
        // Show success message and navigate to home
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile setup completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const NabhaHomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text(
          'Health Profile Setup',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const NabhaHomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: constraints.maxWidth * 0.9,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Step 3 of 3',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with animation
                      ScaleTransition(
                        scale: _headerAnimation,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor.withOpacity(0.1),
                                Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.05),
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
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.health_and_safety,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Complete Your Health Profile',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'This information helps doctors provide better care during consultations',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Personal Information Section
                      _buildSectionCard(
                        title: 'Personal Information',
                        icon: Icons.person,
                        children: [
                          // Full Name (read-only)
                          _buildReadOnlyField(
                            label: 'Full Name',
                            value: widget.fullName,
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),

                          // Phone Number (read-only)
                          _buildReadOnlyField(
                            label: 'Phone Number',
                            value: widget.phoneNumber,
                            icon: Icons.phone,
                          ),
                          const SizedBox(height: 16),

                          // Date of Birth
                          GestureDetector(
                            onTap: _selectDateOfBirth,
                            child: AbsorbPointer(
                              child: CustomTextField(
                                controller: _dateOfBirthController,
                                labelText: 'Date of Birth',
                                hintText: 'Select your date of birth',
                                prefixIcon: Icons.calendar_today,
                                validator: (value) {
                                  if (_selectedDateOfBirth == null) {
                                    return 'Please select your date of birth';
                                  }
                                  return null;
                                },
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your gender';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Blood Group
                          _buildDropdownField(
                            'Blood Group',
                            _selectedBloodGroup,
                            _bloodGroups,
                            Icons.bloodtype,
                            (value) => setState(
                              () => _selectedBloodGroup = value ?? '',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Address
                          CustomTextField(
                            controller: _addressController,
                            labelText: 'Address',
                            hintText: 'Enter your full address',
                            prefixIcon: Icons.location_on,
                            maxLines: 3,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Emergency Contact Section
                      _buildSectionCard(
                        title: 'Emergency Contact',
                        icon: Icons.emergency,
                        children: [
                          CustomTextField(
                            controller: _emergencyContactController,
                            labelText: 'Emergency Contact Name',
                            hintText: 'Full name of emergency contact',
                            prefixIcon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Emergency contact name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _emergencyPhoneController,
                            labelText: 'Emergency Contact Phone',
                            hintText: 'Phone number of emergency contact',
                            prefixIcon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Emergency contact phone is required';
                              }
                              if (value.length < 10) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Medical Information Section
                      _buildSectionCard(
                        title: 'Medical Information',
                        icon: Icons.local_hospital,
                        children: [
                          // Allergies
                          const Text(
                            'Allergies',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'List any food, drug, or environmental allergies',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _allergyController,
                                  labelText: 'Add Allergy',
                                  hintText: 'Add an allergy (e.g., Peanuts)',
                                  prefixIcon: Icons.add,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _addAllergy,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (_allergies.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red[100]!),
                              ),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _allergies.map((allergy) {
                                  return Chip(
                                    label: Text(
                                      allergy,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    onDeleted: () => _removeAllergy(allergy),
                                    backgroundColor: Colors.red[100],
                                    deleteIconColor: Colors.red[700],
                                    elevation: 1,
                                    shadowColor: Colors.red.withOpacity(0.2),
                                  );
                                }).toList(),
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Current Medications
                          const Text(
                            'Current Medications',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'List all medicines you are currently taking',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _medicationController,
                                  labelText: 'Add Medication',
                                  hintText:
                                      'Add a medication (e.g., Metformin)',
                                  prefixIcon: Icons.add,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _addMedication,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (_medications.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _medications.map((medication) {
                                  return Chip(
                                    label: Text(
                                      medication,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                    onDeleted: () =>
                                        _removeMedication(medication),
                                    backgroundColor: Colors.blue[100],
                                    deleteIconColor: Colors.blue[700],
                                    elevation: 1,
                                    shadowColor: Colors.blue.withOpacity(0.2),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Complete Profile Setup',
                          onPressed: _saveProfile,
                          isLoading: _isLoading,
                          icon: Icons.check_circle,
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const Icon(Icons.lock, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> options,
    IconData icon,
    ValueChanged<String?> onChanged, {
    String? Function(String?)? validator,
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
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[50],
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
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            );
          }).toList(),
          hint: Text('Select $label'),
        ),
      ],
    );
  }
}
