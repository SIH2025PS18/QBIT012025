import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/emergency_medical_data.dart';
import '../providers/emergency_data_provider.dart';

class EmergencyDataForm extends StatefulWidget {
  final String patientId;
  final VoidCallback? onDataUpdated;

  const EmergencyDataForm({
    Key? key,
    required this.patientId,
    this.onDataUpdated,
  }) : super(key: key);

  @override
  State<EmergencyDataForm> createState() => _EmergencyDataFormState();
}

class _EmergencyDataFormState extends State<EmergencyDataForm> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _bloodTypeController = TextEditingController();
  final _medicalAlertsController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyRelationshipController = TextEditingController();
  final _emergencyEmailController = TextEditingController();
  final _emergencyAlternatePhoneController = TextEditingController();

  List<String> _allergies = [];
  List<String> _chronicConditions = [];
  List<String> _criticalMedications = [];

  final List<String> _commonAllergies = [
    'Penicillin',
    'Aspirin',
    'Shellfish',
    'Nuts',
    'Dairy',
    'Eggs',
    'Latex',
    'Dust mites',
    'Pollen',
    'Iodine',
  ];

  final List<String> _commonConditions = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Asthma',
    'Epilepsy',
    'Kidney Disease',
    'Liver Disease',
    'COPD',
    'Stroke',
    'Cancer',
  ];

  final List<String> _bloodTypes = [
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
    _loadExistingData();
  }

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _medicalAlertsController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationshipController.dispose();
    _emergencyEmailController.dispose();
    _emergencyAlternatePhoneController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    final provider = Provider.of<EmergencyDataProvider>(context, listen: false);
    provider.loadPatientData(widget.patientId).then((_) {
      final data = provider.emergencyData;
      if (data != null) {
        setState(() {
          _bloodTypeController.text = data.bloodType;
          _medicalAlertsController.text = data.medicalAlerts ?? '';
          _allergies = List.from(data.allergies);
          _chronicConditions = List.from(data.chronicConditions);
          _criticalMedications = List.from(data.criticalMedications);

          _emergencyNameController.text = data.emergencyContact.name;
          _emergencyPhoneController.text = data.emergencyContact.phoneNumber;
          _emergencyRelationshipController.text =
              data.emergencyContact.relationship;
          _emergencyEmailController.text = data.emergencyContact.email ?? '';
          _emergencyAlternatePhoneController.text =
              data.emergencyContact.alternatePhone ?? '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmergencyDataProvider>(
      builder: (context, provider, child) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressIndicator(provider),
              const SizedBox(height: 20),
              _buildBasicInfoSection(),
              const SizedBox(height: 20),
              _buildEmergencyContactSection(),
              const SizedBox(height: 20),
              _buildAllergiesSection(),
              const SizedBox(height: 20),
              _buildChronicConditionsSection(),
              const SizedBox(height: 20),
              _buildCriticalMedicationsSection(),
              const SizedBox(height: 20),
              _buildMedicalAlertsSection(),
              const SizedBox(height: 30),
              _buildSaveButton(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(EmergencyDataProvider provider) {
    final completeness = provider.getDataCompletenessPercentage();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile Completeness',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(completeness * 100).toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: completeness > 0.8 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: completeness,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                completeness > 0.8 ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Complete your emergency information for better medical care',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection(
      title: 'Basic Information',
      icon: Icons.person,
      children: [
        DropdownButtonFormField<String>(
          value: _bloodTypeController.text.isEmpty
              ? null
              : _bloodTypeController.text,
          decoration: const InputDecoration(
            labelText: 'Blood Type *',
            border: OutlineInputBorder(),
          ),
          items: _bloodTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: (value) {
            _bloodTypeController.text = value ?? '';
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Blood type is required for emergency care';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmergencyContactSection() {
    return _buildSection(
      title: 'Emergency Contact',
      icon: Icons.contact_phone,
      children: [
        TextFormField(
          controller: _emergencyNameController,
          decoration: const InputDecoration(
            labelText: 'Contact Name *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Emergency contact name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emergencyRelationshipController,
          decoration: const InputDecoration(
            labelText: 'Relationship *',
            border: OutlineInputBorder(),
            hintText: 'e.g., Spouse, Parent, Sibling',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Relationship is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emergencyPhoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number *',
            border: OutlineInputBorder(),
            prefixText: '+91 ',
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Emergency contact phone is required';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emergencyAlternatePhoneController,
          decoration: const InputDecoration(
            labelText: 'Alternate Phone (Optional)',
            border: OutlineInputBorder(),
            prefixText: '+91 ',
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emergencyEmailController,
          decoration: const InputDecoration(
            labelText: 'Email (Optional)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildAllergiesSection() {
    return _buildSection(
      title: 'Allergies',
      icon: Icons.warning,
      children: [
        _buildTagSection(
          items: _allergies,
          commonItems: _commonAllergies,
          onAdd: (allergy) {
            setState(() {
              if (!_allergies.contains(allergy)) {
                _allergies.add(allergy);
              }
            });
          },
          onRemove: (allergy) {
            setState(() {
              _allergies.remove(allergy);
            });
          },
          hintText: 'Add allergies',
          emptyText: 'No allergies recorded',
        ),
      ],
    );
  }

  Widget _buildChronicConditionsSection() {
    return _buildSection(
      title: 'Chronic Conditions',
      icon: Icons.medical_information,
      children: [
        _buildTagSection(
          items: _chronicConditions,
          commonItems: _commonConditions,
          onAdd: (condition) {
            setState(() {
              if (!_chronicConditions.contains(condition)) {
                _chronicConditions.add(condition);
              }
            });
          },
          onRemove: (condition) {
            setState(() {
              _chronicConditions.remove(condition);
            });
          },
          hintText: 'Add chronic conditions',
          emptyText: 'No chronic conditions recorded',
        ),
      ],
    );
  }

  Widget _buildCriticalMedicationsSection() {
    return _buildSection(
      title: 'Critical Medications',
      icon: Icons.medication,
      children: [
        _buildTagSection(
          items: _criticalMedications,
          commonItems: [], // Let users add custom medications
          onAdd: (medication) {
            setState(() {
              if (!_criticalMedications.contains(medication)) {
                _criticalMedications.add(medication);
              }
            });
          },
          onRemove: (medication) {
            setState(() {
              _criticalMedications.remove(medication);
            });
          },
          hintText: 'Add critical medications',
          emptyText: 'No critical medications recorded',
          customInput: true,
        ),
      ],
    );
  }

  Widget _buildMedicalAlertsSection() {
    return _buildSection(
      title: 'Medical Alerts',
      icon: Icons.priority_high,
      children: [
        TextFormField(
          controller: _medicalAlertsController,
          decoration: const InputDecoration(
            labelText: 'Special Medical Alerts (Optional)',
            border: OutlineInputBorder(),
            hintText:
                'e.g., Severe reaction to Penicillin, Pacemaker implanted',
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.red.shade700),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTagSection({
    required List<String> items,
    required List<String> commonItems,
    required Function(String) onAdd,
    required Function(String) onRemove,
    required String hintText,
    required String emptyText,
    bool customInput = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display current items
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              emptyText,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (item) => Chip(
                    label: Text(item),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => onRemove(item),
                    backgroundColor: Colors.red.shade50,
                    deleteIconColor: Colors.red.shade700,
                  ),
                )
                .toList(),
          ),

        const SizedBox(height: 16),

        // Add new item
        if (customInput || commonItems.isEmpty) ...[
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: hintText,
                    border: const OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      onAdd(value.trim());
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // Implementation would get text from field and add
                },
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],

        // Common items selection
        if (commonItems.isNotEmpty) ...[
          const Text(
            'Common options:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: commonItems
                .where((item) => !items.contains(item))
                .map(
                  (item) => ActionChip(
                    label: Text(item),
                    onPressed: () => onAdd(item),
                    backgroundColor: Colors.grey.shade100,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSaveButton(EmergencyDataProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: provider.isLoading ? null : _saveData,
        icon: provider.isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
        label: Text(provider.isLoading ? 'Saving...' : 'Save Emergency Data'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = Provider.of<EmergencyDataProvider>(context, listen: false);

    final emergencyContact = EmergencyContact(
      name: _emergencyNameController.text.trim(),
      relationship: _emergencyRelationshipController.text.trim(),
      phoneNumber: _emergencyPhoneController.text.trim(),
      alternatePhone: _emergencyAlternatePhoneController.text.trim().isEmpty
          ? null
          : _emergencyAlternatePhoneController.text.trim(),
      email: _emergencyEmailController.text.trim().isEmpty
          ? null
          : _emergencyEmailController.text.trim(),
    );

    final emergencyData = EmergencyMedicalData(
      patientId: widget.patientId,
      bloodType: _bloodTypeController.text.trim(),
      allergies: _allergies,
      chronicConditions: _chronicConditions,
      emergencyContact: emergencyContact,
      criticalMedications: _criticalMedications,
      medicalAlerts: _medicalAlertsController.text.trim().isEmpty
          ? null
          : _medicalAlertsController.text.trim(),
      lastUpdated: DateTime.now(),
    );

    try {
      await provider.updateEmergencyData(emergencyData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Emergency data saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      widget.onDataUpdated?.call();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
