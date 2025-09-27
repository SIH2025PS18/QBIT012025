import 'package:flutter/material.dart';
import '../models/family_hub.dart';

class FamilyHubProvider extends ChangeNotifier {
  // Family Groups
  List<FamilyGroup> _familyGroups = [];
  bool _isLoadingGroups = false;
  String? _groupsError;

  // Community Health Data
  List<CommunityHealthData> _communityHealthData = [];
  bool _isLoadingHealth = false;
  String? _healthError;

  // Health Alerts
  List<HealthAlert> _healthAlerts = [];
  bool _isLoadingAlerts = false;
  String? _alertsError;

  // Filters
  String _selectedVillage = 'all';
  String _selectedTimeRange = '30';
  String _selectedCondition = 'all';

  // Getters for Family Groups
  List<FamilyGroup> get familyGroups => _familyGroups;
  bool get isLoadingGroups => _isLoadingGroups;
  String? get groupsError => _groupsError;

  // Getters for Community Health
  List<CommunityHealthData> get communityHealthData => _communityHealthData;
  bool get isLoadingHealth => _isLoadingHealth;
  String? get healthError => _healthError;

  // Getters for Health Alerts
  List<HealthAlert> get healthAlerts => _healthAlerts;
  bool get isLoadingAlerts => _isLoadingAlerts;
  String? get alertsError => _alertsError;

  // Filter getters
  String get selectedVillage => _selectedVillage;
  String get selectedTimeRange => _selectedTimeRange;
  String get selectedCondition => _selectedCondition;

  // Statistics
  int get totalFamilyGroups => _familyGroups.length;
  int get activeFamilyGroups => _familyGroups.where((g) => g.isActive).length;
  int get totalFamilyMembers =>
      _familyGroups.fold(0, (sum, group) => sum + group.totalMembers);
  int get totalChildren =>
      _familyGroups.fold(0, (sum, group) => sum + group.children.length);
  int get activeHealthAlerts => _healthAlerts.where((a) => a.isActive).length;
  int get totalHealthReports => _communityHealthData.length;

  // Filtered data
  List<FamilyGroup> get filteredFamilyGroups {
    if (_selectedVillage == 'all') return _familyGroups;
    return _familyGroups.where((g) => g.village == _selectedVillage).toList();
  }

  List<CommunityHealthData> get filteredHealthData {
    var filtered = _communityHealthData;

    if (_selectedVillage != 'all') {
      filtered = filtered.where((d) => d.village == _selectedVillage).toList();
    }

    if (_selectedCondition != 'all') {
      filtered =
          filtered.where((d) => d.condition == _selectedCondition).toList();
    }

    // Filter by time range
    final now = DateTime.now();
    final days = int.tryParse(_selectedTimeRange) ?? 30;
    final cutoffDate = now.subtract(Duration(days: days));
    filtered = filtered.where((d) => d.reportDate.isAfter(cutoffDate)).toList();

    return filtered;
  }

  List<String> get availableVillages {
    final villages = _familyGroups.map((g) => g.village).toSet().toList();
    villages.sort();
    return ['all', ...villages];
  }

  List<String> get availableConditions {
    final conditions =
        _communityHealthData.map((d) => d.condition).toSet().toList();
    conditions.sort();
    return ['all', ...conditions];
  }

  // Load Family Groups
  Future<void> loadFamilyGroups() async {
    _isLoadingGroups = true;
    _groupsError = null;
    notifyListeners();

    try {
      // For now, use demo data - replace with actual API call
      await _loadDemoFamilyGroups();
    } catch (e) {
      _groupsError = 'Error loading family groups: $e';
    } finally {
      _isLoadingGroups = false;
      notifyListeners();
    }
  }

  // Load Community Health Data
  Future<void> loadCommunityHealthData() async {
    _isLoadingHealth = true;
    _healthError = null;
    notifyListeners();

    try {
      // For now, use demo data - replace with actual API call
      await _loadDemoCommunityHealthData();
    } catch (e) {
      _healthError = 'Error loading community health data: $e';
    } finally {
      _isLoadingHealth = false;
      notifyListeners();
    }
  }

  // Load Health Alerts
  Future<void> loadHealthAlerts() async {
    _isLoadingAlerts = true;
    _alertsError = null;
    notifyListeners();

    try {
      // For now, use demo data - replace with actual API call
      await _loadDemoHealthAlerts();
    } catch (e) {
      _alertsError = 'Error loading health alerts: $e';
    } finally {
      _isLoadingAlerts = false;
      notifyListeners();
    }
  }

  // Load all data
  Future<void> loadAllData() async {
    await Future.wait([
      loadFamilyGroups(),
      loadCommunityHealthData(),
      loadHealthAlerts(),
    ]);
  }

  // Family Group CRUD Operations
  Future<bool> createFamilyGroup(FamilyGroup group) async {
    try {
      // In real implementation, call API
      final newGroup = group.copyWith(
        id: 'fg_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );
      _familyGroups.add(newGroup);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error creating family group: $e');
      return false;
    }
  }

  Future<bool> updateFamilyGroup(String id, FamilyGroup group) async {
    try {
      final index = _familyGroups.indexWhere((g) => g.id == id);
      if (index != -1) {
        _familyGroups[index] = group.copyWith(lastUpdated: DateTime.now());
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating family group: $e');
      return false;
    }
  }

  Future<bool> deleteFamilyGroup(String id) async {
    try {
      _familyGroups.removeWhere((g) => g.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error deleting family group: $e');
      return false;
    }
  }

  // Community Health Data CRUD Operations
  Future<bool> createHealthReport(CommunityHealthData data) async {
    try {
      final newReport = data.copyWith(
        id: 'chr_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );
      _communityHealthData.add(newReport);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error creating health report: $e');
      return false;
    }
  }

  Future<bool> updateHealthReport(String id, CommunityHealthData data) async {
    try {
      final index = _communityHealthData.indexWhere((d) => d.id == id);
      if (index != -1) {
        _communityHealthData[index] = data;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating health report: $e');
      return false;
    }
  }

  Future<bool> deleteHealthReport(String id) async {
    try {
      _communityHealthData.removeWhere((d) => d.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error deleting health report: $e');
      return false;
    }
  }

  // Health Alert CRUD Operations
  Future<bool> createHealthAlert(HealthAlert alert) async {
    try {
      final newAlert = alert.copyWith(
        id: 'ha_${DateTime.now().millisecondsSinceEpoch}',
      );
      _healthAlerts.add(newAlert);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error creating health alert: $e');
      return false;
    }
  }

  Future<bool> updateHealthAlert(String id, HealthAlert alert) async {
    try {
      final index = _healthAlerts.indexWhere((a) => a.id == id);
      if (index != -1) {
        _healthAlerts[index] = alert;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating health alert: $e');
      return false;
    }
  }

  Future<bool> deleteHealthAlert(String id) async {
    try {
      _healthAlerts.removeWhere((a) => a.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error deleting health alert: $e');
      return false;
    }
  }

  // Filter methods
  void setVillageFilter(String village) {
    _selectedVillage = village;
    notifyListeners();
  }

  void setTimeRangeFilter(String timeRange) {
    _selectedTimeRange = timeRange;
    notifyListeners();
  }

  void setConditionFilter(String condition) {
    _selectedCondition = condition;
    notifyListeners();
  }

  void clearFilters() {
    _selectedVillage = 'all';
    _selectedTimeRange = '30';
    _selectedCondition = 'all';
    notifyListeners();
  }

  // Demo data loaders (replace with actual API calls)
  Future<void> _loadDemoFamilyGroups() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _familyGroups = [
      FamilyGroup(
        id: 'fg_001',
        primaryMemberId: 'pm_001',
        primaryMemberName: 'Rajesh Kumar',
        primaryMemberPhone: '+91-9876543210',
        familyName: 'Kumar Family',
        address: 'House No. 123, Gandhi Road',
        village: 'Nabha',
        pincode: '147201',
        members: [
          FamilyMember(
            id: 'fm_001',
            name: 'Rajesh Kumar',
            age: 45,
            gender: 'Male',
            relationship: 'Self',
            phoneNumber: '+91-9876543210',
            bloodGroup: 'B+',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          FamilyMember(
            id: 'fm_002',
            name: 'Sunita Kumar',
            age: 42,
            gender: 'Female',
            relationship: 'Spouse',
            bloodGroup: 'A+',
            medicalConditions: 'Diabetes',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          FamilyMember(
            id: 'fm_003',
            name: 'Arjun Kumar',
            age: 16,
            gender: 'Male',
            relationship: 'Child',
            bloodGroup: 'B+',
            allergies: 'Peanuts',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
        ],
        emergencyContact: 'Dr. Sharma',
        emergencyPhone: '+91-9876543211',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      FamilyGroup(
        id: 'fg_002',
        primaryMemberId: 'pm_002',
        primaryMemberName: 'Priya Singh',
        primaryMemberPhone: '+91-9876543220',
        familyName: 'Singh Family',
        address: 'House No. 456, Main Street',
        village: 'Patran',
        pincode: '147105',
        members: [
          FamilyMember(
            id: 'fm_004',
            name: 'Priya Singh',
            age: 35,
            gender: 'Female',
            relationship: 'Self',
            phoneNumber: '+91-9876543220',
            bloodGroup: 'O+',
            createdAt: DateTime.now().subtract(const Duration(days: 20)),
          ),
          FamilyMember(
            id: 'fm_005',
            name: 'Amit Singh',
            age: 38,
            gender: 'Male',
            relationship: 'Spouse',
            bloodGroup: 'A+',
            medicalConditions: 'Hypertension',
            createdAt: DateTime.now().subtract(const Duration(days: 20)),
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
  }

  Future<void> _loadDemoCommunityHealthData() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _communityHealthData = [
      CommunityHealthData(
        id: 'chr_001',
        village: 'Nabha',
        pincode: '147201',
        condition: 'Fever',
        symptoms: ['High temperature', 'Headache', 'Body ache'],
        severity: 'Medium',
        ageGroup: '18-30',
        gender: 'Male',
        reportDate: DateTime.now().subtract(const Duration(days: 2)),
        familyGroupId: 'fg_001',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CommunityHealthData(
        id: 'chr_002',
        village: 'Patran',
        pincode: '147105',
        condition: 'Cough',
        symptoms: ['Dry cough', 'Throat irritation'],
        severity: 'Low',
        ageGroup: '31-50',
        gender: 'Female',
        reportDate: DateTime.now().subtract(const Duration(days: 5)),
        status: 'resolved',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      CommunityHealthData(
        id: 'chr_003',
        village: 'Nabha',
        pincode: '147201',
        condition: 'Diarrhea',
        symptoms: ['Loose motions', 'Stomach pain', 'Dehydration'],
        severity: 'High',
        ageGroup: '5-17',
        gender: 'Male',
        reportDate: DateTime.now().subtract(const Duration(days: 1)),
        status: 'monitoring',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<void> _loadDemoHealthAlerts() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _healthAlerts = [
      HealthAlert(
        id: 'ha_001',
        title: 'Dengue Alert',
        description: 'Increased cases of dengue fever reported in the area',
        type: 'outbreak',
        severity: 'high',
        affectedVillages: ['Nabha', 'Patran'],
        condition: 'Dengue',
        alertDate: DateTime.now().subtract(const Duration(days: 3)),
        isActive: true,
      ),
      HealthAlert(
        id: 'ha_002',
        title: 'Water Quality Warning',
        description: 'Contaminated water supply reported in some areas',
        type: 'warning',
        severity: 'medium',
        affectedVillages: ['Patran'],
        condition: 'Water-borne diseases',
        alertDate: DateTime.now().subtract(const Duration(days: 7)),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        isActive: true,
      ),
    ];
  }

  // Utility methods for analytics
  Map<String, int> getConditionStatistics() {
    final stats = <String, int>{};
    for (final data in filteredHealthData) {
      stats[data.condition] = (stats[data.condition] ?? 0) + 1;
    }
    return stats;
  }

  Map<String, int> getVillageStatistics() {
    final stats = <String, int>{};
    for (final data in filteredHealthData) {
      stats[data.village] = (stats[data.village] ?? 0) + 1;
    }
    return stats;
  }

  Map<String, int> getAgeGroupStatistics() {
    final stats = <String, int>{};
    for (final data in filteredHealthData) {
      stats[data.ageGroup] = (stats[data.ageGroup] ?? 0) + 1;
    }
    return stats;
  }

  List<Map<String, dynamic>> getTrendData() {
    final now = DateTime.now();
    final trendData = <Map<String, dynamic>>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final count = _communityHealthData
          .where((d) => d.reportDate.day == date.day)
          .length;

      trendData.add({
        'date': date,
        'count': count,
      });
    }

    return trendData;
  }
}
