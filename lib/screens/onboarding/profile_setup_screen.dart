import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

import '../../providers/language_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../nabha_home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _medicalHistoryController = TextEditingController();

  // Form data
  DateTime? _dateOfBirth;
  String? _gender;
  String? _bloodGroup;
  File? _profileImage;
  bool _isLoading = false;

  // Options
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];
  final List<String> _bloodGroupOptions = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
    'Unknown',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _medicalHistoryController.dispose();
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
      case 0: // Language step - no validation needed
        return true;
      case 1: // Personal info step
        if (_phoneController.text.trim().isEmpty) {
          _showValidationError('Please enter your phone number');
          return false;
        }
        if (_dateOfBirth == null) {
          _showValidationError('Please select your date of birth');
          return false;
        }
        if (_gender == null || _gender!.isEmpty) {
          _showValidationError('Please select your gender');
          return false;
        }
        if (_addressController.text.trim().isEmpty) {
          _showValidationError('Please enter your address');
          return false;
        }
        return true;
      case 2: // Medical info step
        if (_emergencyContactController.text.trim().isEmpty) {
          _showValidationError('Please enter emergency contact name');
          return false;
        }
        if (_emergencyPhoneController.text.trim().isEmpty) {
          _showValidationError('Please enter emergency contact phone');
          return false;
        }
        return true;
      case 3: // Photo step - optional, no validation needed
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedFile != null) {
                  setState(() {
                    _profileImage = File(pickedFile.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (pickedFile != null) {
                  setState(() {
                    _profileImage = File(pickedFile.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _completeSetup() async {
    // Final validation before saving
    if (!_validateCurrentStep()) return;

    setState(() {
      _isLoading = true;
    });

    // Show progress dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Saving your profile...'),
            ],
          ),
        ),
      );
    }

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Prepare profile data
      final profileData = {
        'phone_number': _phoneController.text.trim(),
        'date_of_birth': _dateOfBirth?.toIso8601String(),
        'gender': _gender,
        'blood_group': _bloodGroup,
        'address': _addressController.text.trim(),
        'emergency_contact': _emergencyContactController.text.trim(),
        'emergency_contact_phone': _emergencyPhoneController.text.trim(),
        'allergies': _allergiesController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        'medications': _medicationsController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        'medical_history': {
          'notes': _medicalHistoryController.text.trim(),
          'lastUpdated': DateTime.now().toIso8601String(),
        },
        'profile_setup_completed': true,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Upload profile image if available
      String? imageUrl;
      if (_profileImage != null) {
        try {
          final fileName =
              '${user.id}_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final uploadResponse = await Supabase.instance.client.storage
              .from('profile-photos')
              .upload(fileName, _profileImage!);

          if (uploadResponse.isNotEmpty) {
            imageUrl = Supabase.instance.client.storage
                .from('profile-photos')
                .getPublicUrl(fileName);
            profileData['profile_photo_url'] = imageUrl;
          }
        } catch (uploadError) {
          // Continue without photo if upload fails
          print('Failed to upload profile photo: $uploadError');
        }
      }

      // Update user profile
      await Supabase.instance.client
          .from('user_profiles')
          .update(profileData)
          .eq('id', user.id);

      if (mounted) {
        // Close progress dialog
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Profile setup completed successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to nabha home screen after a brief delay
        await Future.delayed(const Duration(milliseconds: 1000));

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const NabhaHomeScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // Close progress dialog
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to save profile: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _completeSetup,
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Profile Setup'),
        centerTitle: true,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_totalSteps, (index) {
                    return Container(
                      width:
                          (MediaQuery.of(context).size.width - 80) /
                          _totalSteps,
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  'Step ${_currentStep + 1} of $_totalSteps',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildLanguageStep(),
                _buildPersonalInfoStep(),
                _buildMedicalInfoStep(),
                _buildPhotoStep(),
              ],
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: _currentStep == _totalSteps - 1
                        ? 'Complete Setup'
                        : 'Next',
                    onPressed: _isLoading ? null : _nextStep,
                    isLoading: _currentStep == _totalSteps - 1
                        ? _isLoading
                        : false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageStep() {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your Language',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your preferred language for the app interface',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              ...LanguageProvider.supportedLocales.map((locale) {
                String languageName = 'English';
                String flag = '🇺🇸';

                switch (locale.languageCode) {
                  case 'hi':
                    languageName = 'हिंदी';
                    flag = '🇮🇳';
                    break;
                  case 'pa':
                    languageName = 'ਪੰਜਾਬੀ';
                    flag = '🇮🇳';
                    break;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(flag, style: const TextStyle(fontSize: 24)),
                    title: Text(
                      languageName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Radio<String>(
                      value: locale.languageCode,
                      groupValue: languageProvider.currentLanguageCode,
                      onChanged: (value) {
                        if (value != null) {
                          languageProvider.changeLanguage(value);
                        }
                      },
                    ),
                    onTap: () {
                      languageProvider.changeLanguage(locale.languageCode);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color:
                            languageProvider.currentLanguageCode ==
                                locale.languageCode
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    tileColor:
                        languageProvider.currentLanguageCode ==
                            locale.languageCode
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.white,
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalInfoStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Help us provide you with personalized care',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date of Birth
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _dateOfBirth == null
                      ? 'Select Date of Birth'
                      : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _selectDate,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              const SizedBox(height: 16),

              // Gender selection
              Text('Gender', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _genderOptions.map((gender) {
                  return ChoiceChip(
                    label: Text(gender),
                    selected: _gender == gender,
                    onSelected: (selected) {
                      setState(() {
                        _gender = selected ? gender : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Blood Group
              Text(
                'Blood Group',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _bloodGroupOptions.map((bloodGroup) {
                  return ChoiceChip(
                    label: Text(bloodGroup),
                    selected: _bloodGroup == bloodGroup,
                    onSelected: (selected) {
                      setState(() {
                        _bloodGroup = selected ? bloodGroup : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _addressController,
                labelText: 'Address',
                hintText: 'Enter your current address',
                maxLines: 3,
                prefixIcon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _emergencyContactController,
                labelText: 'Emergency Contact Name',
                hintText: 'Family member or friend name',
                prefixIcon: Icons.person_add,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Emergency contact is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _emergencyPhoneController,
                labelText: 'Emergency Contact Phone',
                hintText: 'Emergency contact phone number',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.emergency,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Emergency contact phone is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalInfoStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Information',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'This information helps doctors provide better care',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            CustomTextField(
              controller: _allergiesController,
              labelText: 'Allergies',
              hintText:
                  'List allergies separated by commas (e.g., peanuts, dust, pollen)',
              maxLines: 2,
              prefixIcon: Icons.warning,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _medicationsController,
              labelText: 'Current Medications',
              hintText: 'List medications separated by commas',
              maxLines: 3,
              prefixIcon: Icons.medication,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _medicalHistoryController,
              labelText: 'Medical History',
              hintText:
                  'Previous surgeries, chronic conditions, family history',
              maxLines: 4,
              prefixIcon: Icons.history,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All medical information is encrypted and only shared with your chosen healthcare providers.',
                      style: TextStyle(color: Colors.blue[800], fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Photo',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a profile photo to help doctors identify you during video consultations',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                    ),
                    child: _profileImage != null
                        ? ClipOval(
                            child: Image.file(
                              _profileImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt,
                            size: 48,
                            color: Colors.grey[600],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(
                    _profileImage != null ? Icons.edit : Icons.add_a_photo,
                  ),
                  label: Text(
                    _profileImage != null ? 'Change Photo' : 'Add Photo',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[600],
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Almost Done!',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your profile is ready. You can add a photo now or skip and add it later from settings.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
