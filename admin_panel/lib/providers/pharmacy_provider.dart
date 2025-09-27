import 'package:flutter/foundation.dart';
import '../models/pharmacy.dart';
import '../services/admin_service.dart';

class PharmacyProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<Pharmacy> _pharmacies = [];
  bool _isLoading = false;
  String? _error;

  List<Pharmacy> get pharmacies => _pharmacies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPharmacies() async {
    _setLoading(true);
    _clearError();

    try {
      _pharmacies = await _adminService.getAllPharmacies();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load pharmacies: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addPharmacy(Pharmacy pharmacy) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _adminService.addPharmacy(pharmacy);
      if (success) {
        await loadPharmacies(); // Reload the list
        return true;
      } else {
        _setError('Failed to add pharmacy');
        return false;
      }
    } catch (e) {
      _setError('Error adding pharmacy: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updatePharmacy(Pharmacy pharmacy) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _adminService.updatePharmacy(pharmacy);
      if (success) {
        await loadPharmacies(); // Reload the list
        return true;
      } else {
        _setError('Failed to update pharmacy');
        return false;
      }
    } catch (e) {
      _setError('Error updating pharmacy: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deletePharmacy(String pharmacyId) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _adminService.deletePharmacy(pharmacyId);
      if (success) {
        await loadPharmacies(); // Reload the list
        return true;
      } else {
        _setError('Failed to delete pharmacy');
        return false;
      }
    } catch (e) {
      _setError('Error deleting pharmacy: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> togglePharmacyVerification(
      String pharmacyId, bool isVerified) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _adminService.updatePharmacyVerification(
          pharmacyId, isVerified);
      if (success) {
        await loadPharmacies(); // Reload the list
        return true;
      } else {
        _setError('Failed to update pharmacy verification');
        return false;
      }
    } catch (e) {
      _setError('Error updating pharmacy verification: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> togglePharmacyStatus(String pharmacyId, bool isActive) async {
    _setLoading(true);
    _clearError();

    try {
      final success =
          await _adminService.updatePharmacyStatus(pharmacyId, isActive);
      if (success) {
        await loadPharmacies(); // Reload the list
        return true;
      } else {
        _setError('Failed to update pharmacy status');
        return false;
      }
    } catch (e) {
      _setError('Error updating pharmacy status: $e');
      return false;
    } finally {
      _setLoading(false);
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

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
  }
}
