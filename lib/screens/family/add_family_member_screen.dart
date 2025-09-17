import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/dependent_profile.dart';
import '../../providers/family_profile_provider.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  final DependentProfile? existingMember;

  const AddFamilyMemberScreen({super.key, this.existingMember});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  String _selectedRelation = 'father';
  String _selectedGender = 'male';
  String _selectedBloodGroup = 'unknown';
  DateTime? _selectedDateOfBirth;

  List<String> _medicalConditions = [];
  List<String> _allergies = [];
  final _conditionController = TextEditingController();
  final _allergyController = TextEditingController();

  bool _isLoading = false;

  static const List<String> _relations = [
    'father',
    'mother',
    'spouse',
    'son',
    'daughter',
    'brother',
    'sister',
    'grandfather',
    'grandmother',
    'uncle',
    'aunt',
    'cousin',
    'other',
  ];

  static const List<String> _bloodGroups = [
    'unknown',
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
    if (widget.existingMember != null) {
      _populateExistingData();
    }
  }

  void _populateExistingData() {
    final member = widget.existingMember!;
    _nameController.text = member.name;
    _phoneController.text = member.phoneNumber;
    _emailController.text = member.email;
    // Get emergency info from emergencyInfo map
    final emergencyInfo = member.emergencyInfo;
    _emergencyContactController.text = emergencyInfo['contactName'] ?? '';
    _emergencyPhoneController.text = emergencyInfo['contactPhone'] ?? '';
    _selectedRelation = member.relation;
    _selectedGender = member.gender;
    _selectedBloodGroup = member.bloodGroup.isEmpty
        ? 'unknown'
        : member.bloodGroup;
    _selectedDateOfBirth = member.dateOfBirth;
    _medicalConditions = List.from(member.medicalConditions);
    _allergies = List.from(member.allergies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingMember != null
              ? 'Edit Family Member'
              : 'Add Family Member',
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildContactInfoSection(),
              const SizedBox(height: 24),
              _buildMedicalInfoSection(),
              const SizedBox(height: 24),
              _buildEmergencyContactSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection('Basic Information', [
      TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Full Name *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.person),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter name';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Relation Dropdown
      DropdownButtonFormField<String>(
        value: _selectedRelation,
        decoration: const InputDecoration(
          labelText: 'Relationship *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.family_restroom),
        ),
        items: _relations.map((relation) {
          return DropdownMenuItem(
            value: relation,
            child: Text(_capitalizeFirst(relation)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedRelation = value!;
          });
        },
      ),
      const SizedBox(height: 16),

      // Gender Selection
      DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: const InputDecoration(
          labelText: 'Gender *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.person_outline),
        ),
        items: const [
          DropdownMenuItem(value: 'male', child: Text('Male')),
          DropdownMenuItem(value: 'female', child: Text('Female')),
          DropdownMenuItem(value: 'other', child: Text('Other')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGender = value!;
          });
        },
      ),
      const SizedBox(height: 16),

      // Date of Birth
      InkWell(
        onTap: _selectDateOfBirth,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Date of Birth *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today),
          ),
          child: Text(
            _selectedDateOfBirth != null
                ? DateFormat('dd/MM/yyyy').format(_selectedDateOfBirth!)
                : 'Select date',
            style: TextStyle(
              color: _selectedDateOfBirth != null
                  ? Theme.of(context).textTheme.bodyMedium?.color
                  : Theme.of(context).hintColor,
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildContactInfoSection() {
    return _buildSection('Contact Information', [
      TextFormField(
        controller: _phoneController,
        decoration: const InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.phone),
          hintText: '+91 XXXXX XXXXX',
        ),
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: 'Email Address',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.email),
          hintText: 'example@email.com',
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    ]);
  }

  Widget _buildMedicalInfoSection() {
    return _buildSection('Medical Information', [
      // Blood Group
      DropdownButtonFormField<String>(
        value: _selectedBloodGroup,
        decoration: const InputDecoration(
          labelText: 'Blood Group',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.bloodtype),
        ),
        items: _bloodGroups.map((group) {
          return DropdownMenuItem(
            value: group,
            child: Text(group == 'unknown' ? 'Unknown' : group),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedBloodGroup = value!;
          });
        },
      ),
      const SizedBox(height: 16),

      // Medical Conditions
      _buildListInputSection(
        'Medical Conditions',
        _medicalConditions,
        _conditionController,
        'Add condition (e.g., Diabetes, Hypertension)',
        Icons.medical_services,
      ),
      const SizedBox(height: 16),

      // Allergies
      _buildListInputSection(
        'Allergies',
        _allergies,
        _allergyController,
        'Add allergy (e.g., Peanuts, Penicillin)',
        Icons.warning_amber,
      ),
    ]);
  }

  Widget _buildEmergencyContactSection() {
    return _buildSection('Emergency Contact', [
      TextFormField(
        controller: _emergencyContactController,
        decoration: const InputDecoration(
          labelText: 'Emergency Contact Name',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.contact_emergency),
        ),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _emergencyPhoneController,
        decoration: const InputDecoration(
          labelText: 'Emergency Contact Phone',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.phone_in_talk),
          hintText: '+91 XXXXX XXXXX',
        ),
        keyboardType: TextInputType.phone,
      ),
    ]);
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildListInputSection(
    String title,
    List<String> items,
    TextEditingController controller,
    String hintText,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        // Add new item
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(icon),
                  isDense: true,
                ),
                onSubmitted: (value) => _addItemToList(items, controller),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _addItemToList(items, controller),
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Display existing items
        if (items.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: items.map((item) {
              return Chip(
                label: Text(item),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() {
                    items.remove(item);
                  });
                },
                backgroundColor: Colors.teal.withOpacity(0.1),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveFamilyMember,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          widget.existingMember != null
              ? 'Update Family Member'
              : 'Add Family Member',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _addItemToList(List<String> items, TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isNotEmpty && !items.contains(value)) {
      setState(() {
        items.add(value);
        controller.clear();
      });
    }
  }

  Future<void> _selectDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  Future<void> _saveFamilyMember() async {
    if (!_formKey.currentState!.validate() || _selectedDateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<FamilyProfileProvider>(
        context,
        listen: false,
      );

      final profile = DependentProfile(
        id:
            widget.existingMember?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        relation: _selectedRelation,
        dateOfBirth: _selectedDateOfBirth!,
        gender: _selectedGender,
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        bloodGroup: _selectedBloodGroup,
        medicalConditions: _medicalConditions,
        allergies: _allergies,
        emergencyInfo: {
          'contactName': _emergencyContactController.text.trim(),
          'contactPhone': _emergencyPhoneController.text.trim(),
        },
        caregiverPermissions: _getDefaultCaregiverPermissions(),
        primaryUserId: 'current_user', // This would come from auth
        createdAt: widget.existingMember?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success = false;
      if (widget.existingMember != null) {
        await provider.updateDependentProfile(profile);
        success = provider.error == null;
      } else {
        await provider.addDependentProfile(profile);
        success = provider.error == null;
      }

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.existingMember != null
                    ? 'Family member updated successfully'
                    : 'Family member added successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.error ?? 'Failed to save family member'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<String> _getDefaultCaregiverPermissions() {
    final age = DateTime.now().difference(_selectedDateOfBirth!).inDays ~/ 365;

    List<String> permissions = [
      'view_medical_history',
      'book_appointments',
      'receive_notifications',
    ];

    // Age-based permissions
    if (age < 18) {
      permissions.addAll([
        'full_access',
        'emergency_access',
        'manage_medications',
      ]);
    } else if (age > 65) {
      permissions.addAll([
        'manage_medications',
        'emergency_access',
        'update_profile',
      ]);
    }

    // Condition-based permissions
    if (_medicalConditions.isNotEmpty) {
      permissions.add('manage_medications');
    }

    return permissions.toSet().toList();
  }

  String _capitalizeFirst(String text) {
    return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _conditionController.dispose();
    _allergyController.dispose();
    super.dispose();
  }
}
