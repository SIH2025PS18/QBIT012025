import 'package:flutter/material.dart';
import '../widgets/modern_sidebar.dart';
import '../models/doctor.dart';
import '../services/admin_service.dart';

class ModernAddDoctorScreen extends StatefulWidget {
  const ModernAddDoctorScreen({Key? key}) : super(key: key);

  @override
  State<ModernAddDoctorScreen> createState() => _ModernAddDoctorScreenState();
}

class _ModernAddDoctorScreenState extends State<ModernAddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminService _adminService = AdminService();

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _consultationFeeController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _licenseExpiryController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  // Dropdown values
  String _selectedSpeciality = 'General Practitioner';
  String _selectedDepartment = 'General Medicine';
  bool _isAvailable = true;
  bool _isEnabled = true;
  bool _generateAutoPassword = true;
  List<String> _selectedPermissions = ['consultation', 'profile_update'];
  List<String> _selectedLanguages = ['English'];

  bool _isLoading = false;

  final List<String> _specialities = [
    'General Practitioner',
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'Neurologist',
    'Psychiatrist',
    'Orthopedic',
    'Gynecologist',
    'ENT Specialist',
    'Ophthalmologist',
  ];

  final List<String> _departments = [
    'General Medicine',
    'Cardiology',
    'Dermatology',
    'Pediatrics',
    'Neurology',
    'Psychiatry',
    'Orthopedics',
    'Gynecology',
    'ENT',
    'Ophthalmology',
    'Urology',
    'Gastroenterology',
    'Emergency',
    'ICU',
  ];

  final List<String> _availablePermissions = [
    'consultation',
    'profile_update',
    'patient_management',
    'reports',
    'admin',
  ];

  final List<String> _availableLanguages = [
    'English',
    'Hindi',
    'Bengali',
    'Tamil',
    'Telugu',
    'Marathi',
    'Gujarati',
    'Kannada',
    'Malayalam',
    'Punjabi',
  ];

  @override
  void initState() {
    super.initState();
    _generateEmployeeId();
    if (_generateAutoPassword) {
      _generatePassword();
    }
  }

  void _generateEmployeeId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _employeeIdController.text = 'EMP${timestamp.toString().substring(8)}';
  }

  void _generatePassword() {
    final chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#\$';
    final random = DateTime.now().millisecondsSinceEpoch;
    String password = '';
    for (int i = 0; i < 10; i++) {
      password += chars[(random + i) % chars.length];
    }
    _passwordController.text = password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          const ModernAdminSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildContent(),
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
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              foregroundColor: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Doctor',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Create a new doctor profile with complete credentials and permissions.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildPersonalInfoCard(),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildQuickInfoCard(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildProfessionalInfoCard(),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildCredentialsCard(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildPermissionsCard(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _nameController,
            label: 'Full Name *',
            hint: 'Enter doctor\'s full name',
            icon: Icons.person_rounded,
            validator: (value) =>
                value?.isEmpty == true ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'Email Address *',
            hint: 'doctor@sehatsarthi.com',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty == true) return 'Email is required';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value!)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            label: 'Phone Number *',
            hint: '+91-9876543210',
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value?.isEmpty == true ? 'Phone is required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emergencyContactController,
            label: 'Emergency Contact',
            hint: '+91-9876543211',
            icon: Icons.emergency,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _addressController,
            label: 'Address',
            hint: 'Enter complete address',
            icon: Icons.location_on_rounded,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Setup',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 24),
          _buildDropdownField(
            value: _selectedSpeciality,
            label: 'Speciality *',
            icon: Icons.medical_services_rounded,
            items: _specialities,
            onChanged: (value) => setState(() => _selectedSpeciality = value!),
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            value: _selectedDepartment,
            label: 'Department',
            icon: Icons.business_rounded,
            items: _departments,
            onChanged: (value) => setState(() => _selectedDepartment = value!),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _employeeIdController,
            label: 'Employee ID *',
            hint: 'Auto-generated',
            icon: Icons.badge_rounded,
            readOnly: true,
            suffixIcon: IconButton(
              onPressed: _generateEmployeeId,
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Generate new ID',
            ),
          ),
          const SizedBox(height: 24),
          _buildSwitchTile(
            title: 'Available for Consultations',
            subtitle: 'Doctor can accept new appointments',
            value: _isAvailable,
            onChanged: (value) => setState(() => _isAvailable = value),
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            title: 'Account Enabled',
            subtitle: 'Doctor can login to the system',
            value: _isEnabled,
            onChanged: (value) => setState(() => _isEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Professional Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _qualificationController,
            label: 'Qualification *',
            hint: 'MBBS, MD, MS, etc.',
            icon: Icons.school_rounded,
            validator: (value) =>
                value?.isEmpty == true ? 'Qualification is required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _experienceController,
            label: 'Experience (Years) *',
            hint: 'Enter years of experience',
            icon: Icons.timeline_rounded,
            keyboardType: TextInputType.number,
            validator: (value) =>
                value?.isEmpty == true ? 'Experience is required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _licenseNumberController,
            label: 'Medical License Number *',
            hint: 'MCI-12345',
            icon: Icons.verified_rounded,
            validator: (value) =>
                value?.isEmpty == true ? 'License number is required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _licenseExpiryController,
            label: 'License Expiry Date',
            hint: 'YYYY-MM-DD',
            icon: Icons.calendar_today_rounded,
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _consultationFeeController,
            label: 'Consultation Fee (₹) *',
            hint: 'Enter consultation fee',
            icon: Icons.currency_rupee_rounded,
            keyboardType: TextInputType.number,
            validator: (value) =>
                value?.isEmpty == true ? 'Consultation fee is required' : null,
          ),
          const SizedBox(height: 24),
          _buildMultiSelectField(
            label: 'Languages Spoken',
            selectedItems: _selectedLanguages,
            availableItems: _availableLanguages,
            onChanged: (selected) =>
                setState(() => _selectedLanguages = selected),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Login Credentials',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: const Color(0xFF22C55E).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: const Color(0xFF22C55E),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Login credentials will be created automatically using the email address provided above.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF166534),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSwitchTile(
            title: 'Auto-generate Password',
            subtitle: 'Create secure random password',
            value: _generateAutoPassword,
            onChanged: (value) {
              setState(() {
                _generateAutoPassword = value;
                if (value) {
                  _generatePassword();
                } else {
                  _passwordController.clear();
                }
              });
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            label: _generateAutoPassword
                ? 'Generated Password'
                : 'Custom Password *',
            hint: _generateAutoPassword
                ? 'Auto-generated secure password'
                : 'Enter custom password',
            icon: Icons.lock_rounded,
            readOnly: _generateAutoPassword,
            obscureText: !_generateAutoPassword,
            validator: (value) =>
                value?.isEmpty == true ? 'Password is required' : null,
            suffixIcon: _generateAutoPassword
                ? IconButton(
                    onPressed: _generatePassword,
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Generate new password',
                  )
                : IconButton(
                    onPressed: () {
                      // Toggle password visibility
                    },
                    icon: const Icon(Icons.visibility_rounded),
                  ),
          ),
          if (_generateAutoPassword) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFB45309),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Doctor will be required to change password on first login.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPermissionsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Access Permissions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select what features the doctor can access in the system.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _availablePermissions.map((permission) {
              final isSelected = _selectedPermissions.contains(permission);
              return InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedPermissions.remove(permission);
                    } else {
                      _selectedPermissions.add(permission);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF10B981)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        size: 16,
                        color:
                            isSelected ? Colors.white : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatPermissionName(permission),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF374151),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF64748B),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Create Doctor Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
    bool obscureText = false,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          obscureText: obscureText,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: readOnly ? const Color(0xFFF8FAFC) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 14)),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectField({
    required String label,
    required List<String> selectedItems,
    required List<String> availableItems,
    required ValueChanged<List<String>> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableItems.map((item) {
              final isSelected = selectedItems.contains(item);
              return InkWell(
                onTap: () {
                  final newSelection = List<String>.from(selectedItems);
                  if (isSelected) {
                    newSelection.remove(item);
                  } else {
                    newSelection.add(item);
                  }
                  onChanged(newSelection);
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF10B981) : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF10B981)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected ? Colors.white : const Color(0xFF374151),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _formatPermissionName(String permission) {
    return permission
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final doctor = Doctor(
        id: '', // Will be generated by backend
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        speciality: _selectedSpeciality,
        qualification: _qualificationController.text.trim(),
        experience: int.tryParse(_experienceController.text) ?? 0,
        licenseNumber: _licenseNumberController.text.trim(),
        consultationFee:
            double.tryParse(_consultationFeeController.text) ?? 0.0,
        isAvailable: _isAvailable,
        isEnabled: _isEnabled,
        languages: _selectedLanguages,
        isVerified: true, // Admin-created doctors are automatically verified
        department: _selectedDepartment,
        employeeId: _employeeIdController.text.trim(),
        emergencyContact: _emergencyContactController.text.trim().isNotEmpty
            ? _emergencyContactController.text.trim()
            : null,
        licenseExpiryDate: _licenseExpiryController.text.trim().isNotEmpty
            ? _licenseExpiryController.text.trim()
            : null,
        permissions: _selectedPermissions,
        hasTemporaryPassword: _generateAutoPassword,
        defaultPassword: _passwordController.text,
        address: _addressController.text.trim().isNotEmpty
            ? {'full': _addressController.text.trim()}
            : null,
      );

      final result = await _adminService.createDoctorWithCredentials(
        doctor,
        _passwordController.text,
      );

      if (result != null && mounted) {
        // Show success dialog
        _showSuccessDialog(result);
      } else {
        _showErrorSnackBar('Failed to create doctor profile');
      }
    } catch (e) {
      _showErrorSnackBar('Error creating doctor: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF10B981),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Doctor Created Successfully!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The doctor profile has been created with the following credentials:',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCredentialRow('Doctor Name:', _nameController.text),
                  _buildCredentialRow('Email:', result['email'] ?? ''),
                  _buildCredentialRow('Password:', result['password'] ?? ''),
                  _buildCredentialRow(
                      'Employee ID:', _employeeIdController.text),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFB45309),
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please share these credentials securely with the doctor.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context)
                  .pop(true); // Go back to doctors list with success result
            },
            child: const Text('Go to Doctors List'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _resetForm(); // Reset form for another entry
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
            ),
            child: const Text('Add Another Doctor'),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontFamily: 'Courier',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _qualificationController.clear();
    _experienceController.clear();
    _licenseNumberController.clear();
    _consultationFeeController.clear();
    _emergencyContactController.clear();
    _licenseExpiryController.clear();
    _addressController.clear();
    _passwordController.clear();

    setState(() {
      _selectedSpeciality = 'General Practitioner';
      _selectedDepartment = 'General Medicine';
      _isAvailable = true;
      _isEnabled = true;
      _generateAutoPassword = true;
      _selectedPermissions = ['consultation', 'profile_update'];
      _selectedLanguages = ['English'];
    });

    _generateEmployeeId();
    if (_generateAutoPassword) {
      _generatePassword();
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    _licenseNumberController.dispose();
    _consultationFeeController.dispose();
    _employeeIdController.dispose();
    _emergencyContactController.dispose();
    _licenseExpiryController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
