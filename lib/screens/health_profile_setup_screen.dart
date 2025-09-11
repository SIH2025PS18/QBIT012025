import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/villages.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'nabha_home_screen.dart';

// Model for family member
class FamilyMember {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String relationship;

  FamilyMember({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.relationship,
  });
}

class HealthProfileSetupScreen extends StatefulWidget {
  final String? userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;

  const HealthProfileSetupScreen({
    super.key,
    this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
  });

  @override
  State<HealthProfileSetupScreen> createState() =>
      _HealthProfileSetupScreenState();
}

class _HealthProfileSetupScreenState extends State<HealthProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  // Family member controllers
  final _familyNameController = TextEditingController();
  final _familyAgeController = TextEditingController();
  final _familyRelationshipController = TextEditingController();

  // Form data
  String? _gender;
  String? _selectedVillage;
  String? _familyGender;
  bool _isLoading = false;
  List<FamilyMember> _familyMembers = [];

  // Options
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _familyGenderOptions = ['Male', 'Female', 'Other'];
  final List<String> _relationshipOptions = [
    'Child',
    'Parent',
    'Spouse',
    'Sibling',
    'Grandparent',
    'Other',
  ];
  final List<String> _villages = Villages.nabhaVillages;

  @override
  void initState() {
    super.initState();
    // Pre-fill with passed data if available
    if (widget.fullName != null) {
      _fullNameController.text = widget.fullName!;
    }
    if (widget.phoneNumber != null) {
      _phoneController.text = widget.phoneNumber!;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _familyNameController.dispose();
    _familyAgeController.dispose();
    _familyRelationshipController.dispose();
    super.dispose();
  }

  void _nextStep() {
    // Validate current step before proceeding
    if (!_validateCurrentStep()) return;

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup();
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Personal info step
        if (_fullNameController.text.trim().isEmpty) {
          _showValidationError('Please enter your full name');
          return false;
        }
        if (_ageController.text.trim().isEmpty) {
          _showValidationError('Please enter your age');
          return false;
        }
        if (int.tryParse(_ageController.text.trim()) == null) {
          _showValidationError('Please enter a valid age');
          return false;
        }
        if (_gender == null || _gender!.isEmpty) {
          _showValidationError('Please select your gender');
          return false;
        }
        return true;
      case 1: // Village selection step
        if (_selectedVillage == null || _selectedVillage!.isEmpty) {
          _showValidationError('Please select your village');
          return false;
        }
        return true;
      case 2: // Phone and emergency contact step
        if (_phoneController.text.trim().isEmpty) {
          _showValidationError('Please enter your phone number');
          return false;
        }
        if (_phoneController.text.trim().length < 10) {
          _showValidationError('Please enter a valid phone number');
          return false;
        }
        if (_emergencyContactController.text.trim().isEmpty) {
          _showValidationError('Please enter emergency contact name');
          return false;
        }
        if (_emergencyPhoneController.text.trim().isEmpty) {
          _showValidationError('Please enter emergency contact phone');
          return false;
        }
        if (_emergencyPhoneController.text.trim().length < 10) {
          _showValidationError('Please enter a valid emergency phone number');
          return false;
        }
        return true;
      case 3: // Family members step
        return true;
      default:
        return true;
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _addFamilyMember() {
    if (_familyNameController.text.trim().isEmpty) {
      _showValidationError('Please enter family member name');
      return;
    }

    if (_familyAgeController.text.trim().isEmpty) {
      _showValidationError('Please enter family member age');
      return;
    }

    if (int.tryParse(_familyAgeController.text.trim()) == null) {
      _showValidationError('Please enter a valid age');
      return;
    }

    if (_familyGender == null || _familyGender!.isEmpty) {
      _showValidationError('Please select family member gender');
      return;
    }

    if (_familyRelationshipController.text.trim().isEmpty) {
      _showValidationError('Please enter relationship');
      return;
    }

    final newMember = FamilyMember(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _familyNameController.text.trim(),
      age: int.parse(_familyAgeController.text.trim()),
      gender: _familyGender!,
      relationship: _familyRelationshipController.text.trim(),
    );

    setState(() {
      _familyMembers.add(newMember);
      // Clear form
      _familyNameController.clear();
      _familyAgeController.clear();
      _familyGender = null;
      _familyRelationshipController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Family member added successfully')),
    );
  }

  void _removeFamilyMember(String id) {
    setState(() {
      _familyMembers.removeWhere((member) => member.id == id);
    });
  }

  Future<void> _completeSetup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate profile creation
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to nabha home screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const NabhaHomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to complete setup: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile Setup',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
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
            _buildProgressIndicator(),
            const SizedBox(height: 20),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPersonalInfoPage(),
                  _buildVillageSelectionPage(),
                  _buildContactInfoPage(),
                  _buildFamilyMembersPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          return Expanded(
            child: Container(
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please provide your basic information',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Full name field
            CustomTextField(
              controller: _fullNameController,
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: 20),

            // Age field
            CustomTextField(
              controller: _ageController,
              labelText: 'Age',
              hintText: 'Enter your age',
              prefixIcon: Icons.calendar_today_outlined,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            const SizedBox(height: 20),

            // Gender selection
            _buildGenderSelection(),

            const SizedBox(height: 32),

            // Navigation buttons
            _buildNavigationButtons(showPrevious: false),
          ],
        ),
      ),
    );
  }

  Widget _buildVillageSelectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Your Village',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This determines your priority in the healthcare system',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Village search field
          CustomTextField(
            controller: TextEditingController(),
            labelText: 'Search Village',
            hintText: 'Search for your village',
            prefixIcon: Icons.search,
            onChanged: (value) {
              // In a real implementation, this would filter the village list
            },
          ),

          const SizedBox(height: 20),

          // Village list
          Container(
            height: 300,
            child: ListView.builder(
              itemCount: _villages.length,
              itemBuilder: (context, index) {
                final village = _villages[index];
                return ListTile(
                  title: Text(village),
                  selected: _selectedVillage == village,
                  selectedTileColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  onTap: () {
                    setState(() {
                      _selectedVillage = village;
                    });
                  },
                  trailing: _selectedVillage == village
                      ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                      : null,
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          // Navigation buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildContactInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We need this for appointment reminders and emergencies',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Phone number field
            CustomTextField(
              controller: _phoneController,
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            const SizedBox(height: 20),

            // Emergency contact name
            CustomTextField(
              controller: _emergencyContactController,
              labelText: 'Emergency Contact Name',
              hintText: 'Name of family member or friend',
              prefixIcon: Icons.contact_emergency_outlined,
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: 20),

            // Emergency contact phone
            CustomTextField(
              controller: _emergencyPhoneController,
              labelText: 'Emergency Contact Phone',
              hintText: 'Phone number of emergency contact',
              prefixIcon: Icons.phone_android,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            const SizedBox(height: 32),

            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMembersPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Family Members',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add family members under your account',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Information text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You can add family members (children, elderly parents) under your phone number. '
                    'They will have access to the same healthcare services.',
                    style: TextStyle(color: Colors.blue[800], fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Add family member form
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Family Member',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // Family member name
                CustomTextField(
                  controller: _familyNameController,
                  labelText: 'Full Name',
                  hintText: 'Enter family member name',
                  prefixIcon: Icons.person_outline,
                ),

                const SizedBox(height: 16),

                // Family member age
                CustomTextField(
                  controller: _familyAgeController,
                  labelText: 'Age',
                  hintText: 'Enter age',
                  prefixIcon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),

                const SizedBox(height: 16),

                // Family member gender
                _buildFamilyGenderSelection(),

                const SizedBox(height: 16),

                // Relationship
                CustomTextField(
                  controller: _familyRelationshipController,
                  labelText: 'Relationship',
                  hintText: 'e.g., Child, Parent, Spouse',
                  prefixIcon: Icons.family_restroom,
                ),

                const SizedBox(height: 16),

                // Add button
                CustomButton(
                  text: 'Add Family Member',
                  onPressed: _addFamilyMember,
                  icon: Icons.add,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Family members list
          if (_familyMembers.isNotEmpty) ...[
            const Text(
              'Added Family Members',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _familyMembers.length,
              itemBuilder: (context, index) {
                final member = _familyMembers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.1),
                      child: Icon(
                        member.gender == 'Male'
                            ? Icons.male
                            : member.gender == 'Female'
                            ? Icons.female
                            : Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(member.name),
                    subtitle: Text(
                      '${member.age} years old • ${member.relationship}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFamilyMember(member.id),
                    ),
                  ),
                );
              },
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.family_restroom,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No family members added yet',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Navigation buttons
          _buildNavigationButtons(showNext: false, showComplete: true),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: _genderOptions.map((option) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _gender = option;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: _gender == option
                        ? Theme.of(context).primaryColor
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _gender == option
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: TextStyle(
                        color: _gender == option
                            ? Colors.white
                            : Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFamilyGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: _familyGenderOptions.map((option) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _familyGender = option;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: _familyGender == option
                        ? Theme.of(context).primaryColor
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _familyGender == option
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: TextStyle(
                        color: _familyGender == option
                            ? Colors.white
                            : Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons({
    bool showPrevious = true,
    bool showNext = true,
    bool showComplete = false,
  }) {
    return Row(
      children: [
        if (showPrevious)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Text(
                'Previous',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        if (showPrevious && (showNext || showComplete))
          const SizedBox(width: 12),
        if (showNext)
          Expanded(
            flex: 2,
            child: CustomButton(
              text: 'Next',
              onPressed: _nextStep,
              isLoading: _isLoading,
            ),
          ),
        if (showComplete)
          Expanded(
            flex: 2,
            child: CustomButton(
              text: 'Complete Setup',
              onPressed: _completeSetup,
              isLoading: _isLoading,
              icon: Icons.check,
            ),
          ),
      ],
    );
  }
}
