import 'package:flutter/foundation.dart';
import '../models/patient.dart';
import '../services/admin_service.dart';

class PatientProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<Patient> _patients = [];
  bool _isLoading = false;
  String? _error;

  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PatientProvider() {
    loadPatients();
  }

  Future<void> loadPatients() async {
    _setLoading(true);
    _setError(null);

    try {
      _patients = await _adminService.getAllPatients();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load patients: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addPatient(Patient patient) async {
    _setError(null);

    try {
      final result = await _adminService.createPatientWithCredentials(
          patient, 'defaultPassword123');
      if (result != null) {
        await loadPatients(); // Refresh the list
        return true;
      } else {
        _setError('Failed to add patient');
        return false;
      }
    } catch (e) {
      _setError('Error adding patient: $e');
      return false;
    }
  }

  Future<bool> updatePatient(Patient patient) async {
    _setError(null);

    try {
      final success = await _adminService.updatePatient(patient.id, patient);
      if (success) {
        await loadPatients(); // Refresh the list
        return true;
      } else {
        _setError('Failed to update patient');
        return false;
      }
    } catch (e) {
      _setError('Error updating patient: $e');
      return false;
    }
  }

  Future<bool> deletePatient(String patientId) async {
    _setError(null);

    try {
      final success = await _adminService.deletePatient(patientId);
      if (success) {
        await loadPatients(); // Refresh the list
        return true;
      } else {
        _setError('Failed to delete patient');
        return false;
      }
    } catch (e) {
      _setError('Error deleting patient: $e');
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
