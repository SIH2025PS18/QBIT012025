import 'package:flutter/material.dart';
import '../models/emergency_medical_data.dart';
import '../services/emergency_data_service.dart';

class EmergencyDataProvider extends ChangeNotifier {
  final EmergencyDataService _dataService = EmergencyDataService();

  EmergencyMedicalData? _emergencyData;
  GeneralMedicalData? _generalData;
  SensitiveMedicalData? _sensitiveData;
  List<EmergencyAccessLog> _accessLogs = [];

  bool _isLoading = false;
  String? _error;

  // Getters
  EmergencyMedicalData? get emergencyData => _emergencyData;
  GeneralMedicalData? get generalData => _generalData;
  SensitiveMedicalData? get sensitiveData => _sensitiveData;
  List<EmergencyAccessLog> get accessLogs => _accessLogs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all medical data for a patient
  Future<void> loadPatientData(String patientId) async {
    _setLoading(true);
    try {
      _emergencyData = await _dataService.getEmergencyData(patientId);
      _generalData = await _dataService.getGeneralData(patientId);
      _sensitiveData = await _dataService.getSensitiveData(patientId);
      _accessLogs = await _dataService.getAccessLogs(patientId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Update emergency data (Level 1)
  Future<void> updateEmergencyData(EmergencyMedicalData data) async {
    _setLoading(true);
    try {
      await _dataService.saveEmergencyData(data);
      _emergencyData = data;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Update general data (Level 2)
  Future<void> updateGeneralData(GeneralMedicalData data) async {
    _setLoading(true);
    try {
      await _dataService.saveGeneralData(data);
      _generalData = data;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Update sensitive data (Level 3)
  Future<void> updateSensitiveData(SensitiveMedicalData data) async {
    _setLoading(true);
    try {
      await _dataService.saveSensitiveData(data);
      _sensitiveData = data;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Add emergency contact
  Future<void> updateEmergencyContact(
    String patientId,
    EmergencyContact contact,
  ) async {
    if (_emergencyData != null) {
      final updatedData = EmergencyMedicalData(
        patientId: _emergencyData!.patientId,
        bloodType: _emergencyData!.bloodType,
        allergies: _emergencyData!.allergies,
        chronicConditions: _emergencyData!.chronicConditions,
        emergencyContact: contact,
        criticalMedications: _emergencyData!.criticalMedications,
        medicalAlerts: _emergencyData!.medicalAlerts,
        lastUpdated: DateTime.now(),
      );
      await updateEmergencyData(updatedData);
    }
  }

  // Add allergy
  Future<void> addAllergy(String patientId, String allergy) async {
    if (_emergencyData != null) {
      final updatedAllergies = List<String>.from(_emergencyData!.allergies);
      if (!updatedAllergies.contains(allergy)) {
        updatedAllergies.add(allergy);

        final updatedData = EmergencyMedicalData(
          patientId: _emergencyData!.patientId,
          bloodType: _emergencyData!.bloodType,
          allergies: updatedAllergies,
          chronicConditions: _emergencyData!.chronicConditions,
          emergencyContact: _emergencyData!.emergencyContact,
          criticalMedications: _emergencyData!.criticalMedications,
          medicalAlerts: _emergencyData!.medicalAlerts,
          lastUpdated: DateTime.now(),
        );
        await updateEmergencyData(updatedData);
      }
    }
  }

  // Remove allergy
  Future<void> removeAllergy(String patientId, String allergy) async {
    if (_emergencyData != null) {
      final updatedAllergies = List<String>.from(_emergencyData!.allergies);
      updatedAllergies.remove(allergy);

      final updatedData = EmergencyMedicalData(
        patientId: _emergencyData!.patientId,
        bloodType: _emergencyData!.bloodType,
        allergies: updatedAllergies,
        chronicConditions: _emergencyData!.chronicConditions,
        emergencyContact: _emergencyData!.emergencyContact,
        criticalMedications: _emergencyData!.criticalMedications,
        medicalAlerts: _emergencyData!.medicalAlerts,
        lastUpdated: DateTime.now(),
      );
      await updateEmergencyData(updatedData);
    }
  }

  // Add chronic condition
  Future<void> addChronicCondition(String patientId, String condition) async {
    if (_emergencyData != null) {
      final updatedConditions = List<String>.from(
        _emergencyData!.chronicConditions,
      );
      if (!updatedConditions.contains(condition)) {
        updatedConditions.add(condition);

        final updatedData = EmergencyMedicalData(
          patientId: _emergencyData!.patientId,
          bloodType: _emergencyData!.bloodType,
          allergies: _emergencyData!.allergies,
          chronicConditions: updatedConditions,
          emergencyContact: _emergencyData!.emergencyContact,
          criticalMedications: _emergencyData!.criticalMedications,
          medicalAlerts: _emergencyData!.medicalAlerts,
          lastUpdated: DateTime.now(),
        );
        await updateEmergencyData(updatedData);
      }
    }
  }

  // Add critical medication
  Future<void> addCriticalMedication(
    String patientId,
    String medication,
  ) async {
    if (_emergencyData != null) {
      final updatedMedications = List<String>.from(
        _emergencyData!.criticalMedications,
      );
      if (!updatedMedications.contains(medication)) {
        updatedMedications.add(medication);

        final updatedData = EmergencyMedicalData(
          patientId: _emergencyData!.patientId,
          bloodType: _emergencyData!.bloodType,
          allergies: _emergencyData!.allergies,
          chronicConditions: _emergencyData!.chronicConditions,
          emergencyContact: _emergencyData!.emergencyContact,
          criticalMedications: updatedMedications,
          medicalAlerts: _emergencyData!.medicalAlerts,
          lastUpdated: DateTime.now(),
        );
        await updateEmergencyData(updatedData);
      }
    }
  }

  // Update blood type
  Future<void> updateBloodType(String patientId, String bloodType) async {
    if (_emergencyData != null) {
      final updatedData = EmergencyMedicalData(
        patientId: _emergencyData!.patientId,
        bloodType: bloodType,
        allergies: _emergencyData!.allergies,
        chronicConditions: _emergencyData!.chronicConditions,
        emergencyContact: _emergencyData!.emergencyContact,
        criticalMedications: _emergencyData!.criticalMedications,
        medicalAlerts: _emergencyData!.medicalAlerts,
        lastUpdated: DateTime.now(),
      );
      await updateEmergencyData(updatedData);
    }
  }

  // Update medical alerts
  Future<void> updateMedicalAlerts(String patientId, String? alerts) async {
    if (_emergencyData != null) {
      final updatedData = EmergencyMedicalData(
        patientId: _emergencyData!.patientId,
        bloodType: _emergencyData!.bloodType,
        allergies: _emergencyData!.allergies,
        chronicConditions: _emergencyData!.chronicConditions,
        emergencyContact: _emergencyData!.emergencyContact,
        criticalMedications: _emergencyData!.criticalMedications,
        medicalAlerts: alerts,
        lastUpdated: DateTime.now(),
      );
      await updateEmergencyData(updatedData);
    }
  }

  // Log emergency access
  Future<void> logEmergencyAccess(EmergencyAccessLog log) async {
    _accessLogs.insert(0, log); // Add to beginning of list
    notifyListeners();

    try {
      await _dataService.saveAccessLog(log);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Initialize default emergency data for new patients
  Future<void> initializeEmergencyData(String patientId) async {
    final defaultData = EmergencyMedicalData(
      patientId: patientId,
      bloodType: '',
      allergies: [],
      chronicConditions: [],
      emergencyContact: EmergencyContact(
        name: '',
        relationship: '',
        phoneNumber: '',
      ),
      criticalMedications: [],
      lastUpdated: DateTime.now(),
    );

    await updateEmergencyData(defaultData);
  }

  // Check if emergency data is complete
  bool isEmergencyDataComplete() {
    if (_emergencyData == null) return false;

    return _emergencyData!.bloodType.isNotEmpty &&
        _emergencyData!.emergencyContact.name.isNotEmpty &&
        _emergencyData!.emergencyContact.phoneNumber.isNotEmpty;
  }

  // Get data completeness percentage
  double getDataCompletenessPercentage() {
    if (_emergencyData == null) return 0.0;

    int completedFields = 0;
    int totalFields =
        5; // bloodType, emergencyContact.name, emergencyContact.phone, allergies, chronicConditions

    if (_emergencyData!.bloodType.isNotEmpty) completedFields++;
    if (_emergencyData!.emergencyContact.name.isNotEmpty) completedFields++;
    if (_emergencyData!.emergencyContact.phoneNumber.isNotEmpty)
      completedFields++;
    if (_emergencyData!.allergies.isNotEmpty) completedFields++;
    if (_emergencyData!.chronicConditions.isNotEmpty) completedFields++;

    return completedFields / totalFields;
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear all data (for logout)
  void clearData() {
    _emergencyData = null;
    _generalData = null;
    _sensitiveData = null;
    _accessLogs.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
