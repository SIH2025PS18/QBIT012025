import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../services/admin_service.dart';
import '../widgets/sidebar.dart';

class AddDoctorScreen extends StatefulWidget {
  final Doctor? doctor; // For editing existing doctor

  const AddDoctorScreen({Key? key, this.doctor}) : super(key: key);

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminService _adminService = AdminService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _experienceController;
  late TextEditingController _qualificationController;
  late TextEditingController _licenseNumberController;
  late TextEditingController _consultationFeeController;

  String _selectedSpeciality = 'Cardiologist';
  bool _isAvailable = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.doctor != null) {
      // Editing existing doctor
      final doctor = widget.doctor!;
      _nameController = TextEditingController(text: doctor.name);
      _emailController = TextEditingController(text: doctor.email);
      _phoneController = TextEditingController(text: doctor.phone);
      _experienceController =
          TextEditingController(text: doctor.experience.toString());
      _qualificationController =
          TextEditingController(text: doctor.qualification);
      _licenseNumberController =
          TextEditingController(text: doctor.licenseNumber);
      _consultationFeeController =
          TextEditingController(text: doctor.consultationFee.toString());

      _selectedSpeciality = doctor.speciality;
      _isAvailable = doctor.isAvailable;
    } else {
      // Adding new doctor
      _nameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
      _experienceController = TextEditingController();
      _qualificationController = TextEditingController();
      _licenseNumberController = TextEditingController();
      _consultationFeeController = TextEditingController(text: '500');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    _qualificationController.dispose();
    _licenseNumberController.dispose();
    _consultationFeeController.dispose();
    super.dispose();
  }

  Future<void> _saveDoctor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final doctor = Doctor(
        id: widget.doctor?.id ?? '',
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        speciality: _selectedSpeciality,
        qualification: _qualificationController.text.trim(),
        experience: int.tryParse(_experienceController.text) ?? 0,
        licenseNumber: _licenseNumberController.text.trim(),
        consultationFee:
            double.tryParse(_consultationFeeController.text) ?? 500.0,
        isAvailable: _isAvailable,
      );

      bool success;
      if (widget.doctor != null) {
        // Update existing doctor
        success = await _adminService.updateDoctor(widget.doctor!.id, doctor);
      } else {
        // Create new doctor with credentials
        const defaultPassword = 'doctor123';
        final result = await _adminService.createDoctorWithCredentials(
            doctor, defaultPassword);
        success = result != null;

        if (success && result != null) {
          // Show credentials to admin
          _showCredentialsDialog(result);
        }
      }

      if (success) {
        _showSuccessSnackBar(widget.doctor != null
            ? 'Doctor updated successfully'
            : 'Doctor created successfully');
        Navigator.pop(context, true);
      } else {
        _showErrorSnackBar('Failed to save doctor. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showCredentialsDialog(Map<String, dynamic> credentials) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Doctor Created Successfully'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please save these login credentials:'),
            const SizedBox(height: 16),
            Text('Email: ${credentials['email']}'),
            Text('Password: ${credentials['password']}'),
            Text('Doctor ID: ${credentials['doctorId']}'),
            const SizedBox(height: 16),
            const Text(
              'The doctor can use these credentials to login to the doctor portal.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    widget.doctor != null ? 'Edit Doctor' : 'Add New Doctor',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form
                  Expanded(
                    child: SingleChildScrollView(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Basic Information
                                _buildSectionTitle('Basic Information'),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Full Name *',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Please enter doctor name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                          labelText: 'Email *',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Please enter email';
                                          }
                                          if (!value!.contains('@')) {
                                            return 'Please enter valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _phoneController,
                                        decoration: const InputDecoration(
                                          labelText: 'Phone Number *',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Please enter phone number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        value: _selectedSpeciality,
                                        decoration: const InputDecoration(
                                          labelText: 'Speciality *',
                                          border: OutlineInputBorder(),
                                        ),
                                        items: DoctorSpecialities.all
                                            .map((speciality) =>
                                                DropdownMenuItem(
                                                  value: speciality,
                                                  child: Text(speciality),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedSpeciality = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Professional Information
                                _buildSectionTitle('Professional Information'),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _qualificationController,
                                        decoration: const InputDecoration(
                                          labelText: 'Qualification *',
                                          border: OutlineInputBorder(),
                                          hintText: 'e.g., MBBS, MD',
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Please enter qualification';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _experienceController,
                                        decoration: const InputDecoration(
                                          labelText: 'Experience (Years) *',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Please enter experience';
                                          }
                                          final exp = int.tryParse(value!);
                                          if (exp == null || exp < 0) {
                                            return 'Please enter valid experience';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _licenseNumberController,
                                        decoration: const InputDecoration(
                                          labelText: 'License Number *',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Please enter license number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _consultationFeeController,
                                        decoration: const InputDecoration(
                                          labelText: 'Consultation Fee (₹) *',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Please enter consultation fee';
                                          }
                                          final fee = double.tryParse(value!);
                                          if (fee == null || fee < 0) {
                                            return 'Please enter valid fee';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Availability
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isAvailable,
                                      onChanged: (value) {
                                        setState(() {
                                          _isAvailable = value ?? false;
                                        });
                                      },
                                    ),
                                    const Text('Available for consultations'),
                                  ],
                                ),

                                const SizedBox(height: 32),

                                // Action Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed:
                                          _isLoading ? null : _saveDoctor,
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(widget.doctor != null
                                              ? 'Update Doctor'
                                              : 'Create Doctor'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
    );
  }
}
