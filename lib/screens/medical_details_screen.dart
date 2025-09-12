import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/patient_profile.dart';
import '../providers/patient_profile_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class MedicalDetailsScreen extends StatefulWidget {
  final PatientProfile profile;

  const MedicalDetailsScreen({super.key, required this.profile});

  @override
  State<MedicalDetailsScreen> createState() => _MedicalDetailsScreenState();
}

class _MedicalDetailsScreenState extends State<MedicalDetailsScreen> {
  final _allergyController = TextEditingController();
  final _medicationController = TextEditingController();
  final _medicalConditionController = TextEditingController();
  final _notesController = TextEditingController();

  List<String> _allergies = [];
  List<String> _medications = [];
  Map<String, dynamic> _medicalHistory = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMedicalData();
  }

  @override
  void dispose() {
    _allergyController.dispose();
    _medicationController.dispose();
    _medicalConditionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadMedicalData() {
    setState(() {
      _allergies = List<String>.from(widget.profile.allergies);
      _medications = List<String>.from(widget.profile.medications);
      _medicalHistory = Map<String, dynamic>.from(
        widget.profile.medicalHistory,
      );
      _notesController.text = _medicalHistory['notes'] ?? '';
    });
  }

  Future<void> _saveMedicalData() async {
    setState(() => _isLoading = true);

    try {
      // Update medical history with notes
      final updatedMedicalHistory = Map<String, dynamic>.from(_medicalHistory);
      updatedMedicalHistory['notes'] = _notesController.text.trim();
      updatedMedicalHistory['lastUpdated'] = DateTime.now().toIso8601String();

      final updatedProfile = widget.profile.copyWith(
        allergies: _allergies,
        medications: _medications,
        medicalHistory: updatedMedicalHistory,
      );

      await Provider.of<PatientProfileProvider>(
        context,
        listen: false,
      ).updateProfile(updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.medicalDetailsSaved),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(updatedProfile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.failedToSaveMedicalDetails}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
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
          content: Text(
            '${AppLocalizations.of(context)!.addedAllergy}: $allergy',
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text('Medical Details'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveMedicalData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                      Icons.local_hospital,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Medical Information',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Update your medical history, allergies, and current medications',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Allergies Section
            _buildSectionCard(
              'Allergies',
              Icons.warning_amber_rounded,
              Colors.orange,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'List any food, drug, or environmental allergies',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _allergyController,
                          labelText: 'Add Allergy',
                          hintText:
                              'Add an allergy (e.g., Peanuts, Dust, etc.)',
                          prefixIcon: Icons.add,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addAllergy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
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
                  const SizedBox(height: 16),
                  if (_allergies.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'No allergies recorded',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[100]!),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _allergies.map((allergy) {
                          return Chip(
                            label: Text(
                              allergy,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            deleteIcon: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.orange,
                            ),
                            onDeleted: () => _removeAllergy(allergy),
                            backgroundColor: Colors.orange[100],
                            deleteIconColor: Colors.orange[700],
                            elevation: 1,
                            shadowColor: Colors.orange.withOpacity(0.2),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Current Medications Section
            _buildSectionCard(
              'Current Medications',
              Icons.medication,
              Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'List all medicines you are currently taking',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _medicationController,
                          labelText: 'Add Medication',
                          hintText: 'Add a medication (e.g., Aspirin 100mg)',
                          prefixIcon: Icons.add,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addMedication,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
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
                  const SizedBox(height: 16),
                  if (_medications.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'No current medications',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
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
                            onDeleted: () => _removeMedication(medication),
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
            ),

            const SizedBox(height: 20),

            // Medical Notes Section
            _buildSectionCard(
              'Medical Notes',
              Icons.note_alt,
              Colors.teal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Additional medical information, conditions, or notes:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Enter any additional medical information...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Save Medical Details',
                onPressed: _isLoading ? null : () => _saveMedicalData(),
                isLoading: _isLoading,
                icon: Icons.save,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    String title,
    IconData icon,
    Color color, {
    required Widget child,
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
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
          child,
        ],
      ),
    );
  }
}
