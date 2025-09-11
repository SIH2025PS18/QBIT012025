import 'package:flutter/foundation.dart';
import '../models/doctor.dart';
import '../services/admin_service.dart';
import '../services/websocket_service.dart';

class DoctorProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  final WebSocketService _webSocketService = WebSocketService();

  List<Doctor> _doctors = [];
  bool _isLoading = false;
  String _error = '';

  List<Doctor> get doctors => _doctors;
  bool get isLoading => _isLoading;
  String get error => _error;

  DoctorProvider() {
    _initializeWebSocket();
    loadDoctors();
  }

  void _initializeWebSocket() {
    _webSocketService.connect();
    _webSocketService.setDoctorCallbacks(
      onAdded: _handleDoctorAdded,
      onUpdated: _handleDoctorUpdated,
      onDeleted: _handleDoctorDeleted,
    );
  }

  void _handleDoctorAdded(Doctor doctor) {
    if (!_doctors.any((d) => d.id == doctor.id)) {
      _doctors.add(doctor);
      notifyListeners();
    }
  }

  void _handleDoctorUpdated(Doctor updatedDoctor) {
    final index = _doctors.indexWhere((d) => d.id == updatedDoctor.id);
    if (index != -1) {
      _doctors[index] = updatedDoctor;
      notifyListeners();
    }
  }

  void _handleDoctorDeleted(String doctorId) {
    _doctors.removeWhere((d) => d.id == doctorId);
    notifyListeners();
  }

  Future<void> loadDoctors() async {
    _setLoading(true);
    try {
      _doctors = await _adminService.getAllDoctors();
      _error = '';
    } catch (e) {
      _error = 'Failed to load doctors: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addDoctor(Doctor doctor) async {
    try {
      final success = await _adminService.createDoctor(doctor);
      if (success) {
        // The WebSocket will handle adding to the list
        _error = '';
        return true;
      } else {
        _error = 'Failed to add doctor';
        return false;
      }
    } catch (e) {
      _error = 'Error adding doctor: $e';
      return false;
    }
  }

  Future<bool> updateDoctor(Doctor doctor) async {
    try {
      final success = await _adminService.updateDoctor(doctor.id, doctor);
      if (success) {
        // The WebSocket will handle updating the list
        _error = '';
        return true;
      } else {
        _error = 'Failed to update doctor';
        return false;
      }
    } catch (e) {
      _error = 'Error updating doctor: $e';
      return false;
    }
  }

  Future<bool> deleteDoctor(String doctorId) async {
    try {
      final success = await _adminService.deleteDoctor(doctorId);
      if (success) {
        // The WebSocket will handle removing from the list
        _error = '';
        return true;
      } else {
        _error = 'Failed to delete doctor';
        return false;
      }
    } catch (e) {
      _error = 'Error deleting doctor: $e';
      return false;
    }
  }

  Future<bool> updateDoctorAvailability(
      String doctorId, bool isAvailable) async {
    try {
      final success =
          await _adminService.updateDoctorAvailability(doctorId, isAvailable);
      if (success) {
        // Update local state immediately for better UX
        final index = _doctors.indexWhere((d) => d.id == doctorId);
        if (index != -1) {
          _doctors[index] = _doctors[index].copyWith(isAvailable: isAvailable);
          notifyListeners();
        }
        _error = '';
        return true;
      } else {
        _error = 'Failed to update doctor availability';
        return false;
      }
    } catch (e) {
      _error = 'Error updating doctor availability: $e';
      return false;
    }
  }

  List<Doctor> searchDoctors(String query) {
    if (query.isEmpty) return _doctors;

    return _doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(query.toLowerCase()) ||
          doctor.speciality.toLowerCase().contains(query.toLowerCase()) ||
          doctor.qualification.toLowerCase().contains(query.toLowerCase()) ||
          doctor.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Doctor> getDoctorsBySpeciality(String speciality) {
    if (speciality == 'All') return _doctors;
    return _doctors.where((doctor) => doctor.speciality == speciality).toList();
  }

  List<Doctor> getAvailableDoctors() {
    return _doctors.where((doctor) => doctor.isAvailable).toList();
  }

  List<Doctor> getRecentDoctors([int limit = 5]) {
    final sortedDoctors = List<Doctor>.from(_doctors);
    sortedDoctors.sort((a, b) => (b.createdAt ?? DateTime.now())
        .compareTo(a.createdAt ?? DateTime.now()));
    return sortedDoctors.take(limit).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _webSocketService.clearCallbacks();
    _webSocketService.disconnect();
    super.dispose();
  }
}
