import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;
import '../models/medical_facility.dart';

class FacilityService extends ChangeNotifier {
  static const String _tableName = 'medical_facilities';
  Database? _database;
  List<MedicalFacility> _cachedFacilities = [];
  bool _isInitialized = false;

  // Singleton pattern
  static final FacilityService _instance = FacilityService._internal();
  factory FacilityService() => _instance;
  FacilityService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'facilities.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        address TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        phoneNumber TEXT NOT NULL,
        email TEXT,
        website TEXT,
        specialties TEXT NOT NULL,
        status TEXT NOT NULL,
        equipment TEXT NOT NULL,
        bloodBank TEXT,
        testCosts TEXT NOT NULL,
        procedureCosts TEXT NOT NULL,
        lastUpdated TEXT NOT NULL,
        isOnline INTEGER NOT NULL,
        rating REAL,
        reviewCount INTEGER,
        emergencyNumber TEXT,
        operatingHours TEXT NOT NULL
      )
    ''');
  }

  Future<void> initializeService() async {
    if (_isInitialized) return;

    await _loadCachedFacilities();
    await _loadSampleData(); // For demo purposes
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadCachedFacilities() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);

      _cachedFacilities = maps.map((map) {
        // Convert stored JSON strings back to objects
        map['specialties'] = jsonDecode(map['specialties']);
        map['status'] = jsonDecode(map['status']);
        map['equipment'] = jsonDecode(map['equipment']);
        if (map['bloodBank'] != null) {
          map['bloodBank'] = jsonDecode(map['bloodBank']);
        }
        map['testCosts'] = jsonDecode(map['testCosts']);
        map['procedureCosts'] = jsonDecode(map['procedureCosts']);
        map['operatingHours'] = jsonDecode(map['operatingHours']);
        map['isOnline'] = map['isOnline'] == 1;

        return MedicalFacility.fromJson(map);
      }).toList();
    } catch (e) {
      print('Error loading cached facilities: $e');
      _cachedFacilities = [];
    }
  }

  Future<List<MedicalFacility>> searchFacilities({
    String query = '',
    double? latitude,
    double? longitude,
    FacilitySearchFilter? filter,
  }) async {
    if (!_isInitialized) {
      await initializeService();
    }

    // Start with cached facilities
    List<MedicalFacility> results = List.from(_cachedFacilities);

    // Apply text search
    if (query.isNotEmpty) {
      results = results.where((facility) {
        return facility.name.toLowerCase().contains(query.toLowerCase()) ||
            facility.specialties.any(
              (specialty) =>
                  specialty.toLowerCase().contains(query.toLowerCase()),
            ) ||
            facility.address.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    // Apply filters if provided
    if (filter != null) {
      results = _applyFilters(results, filter);
    }

    // Sort by distance if location is available
    if (latitude != null && longitude != null) {
      results.sort((a, b) {
        double distanceA = _calculateDistance(
          latitude,
          longitude,
          a.latitude,
          a.longitude,
        );
        double distanceB = _calculateDistance(
          latitude,
          longitude,
          b.latitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      // Filter by maximum distance if specified
      if (filter?.maxDistance != null) {
        results = results.where((facility) {
          double distance = _calculateDistance(
            latitude,
            longitude,
            facility.latitude,
            facility.longitude,
          );
          return distance <=
              (filter!.maxDistance * 1000); // Convert km to meters
        }).toList();
      }
    }

    return results;
  }

  List<MedicalFacility> _applyFilters(
    List<MedicalFacility> facilities,
    FacilitySearchFilter filter,
  ) {
    return facilities.where((facility) {
      // Facility type filter
      if (filter.facilityType != null && facility.type != filter.facilityType) {
        return false;
      }

      // Specialties filter
      if (filter.specialties.isNotEmpty) {
        bool hasSpecialty = filter.specialties.any(
          (specialty) => facility.specialties.contains(specialty),
        );
        if (!hasSpecialty) return false;
      }

      // Open now filter
      if (filter.onlyOpenNow && !facility.operatingHours.isOpenNow()) {
        return false;
      }

      // ICU availability filter
      if (filter.hasICU && !facility.equipment.icuStatus.isAvailable) {
        return false;
      }

      // Ventilator availability filter
      if (filter.hasVentilator &&
          !facility.equipment.ventilatorStatus.isAvailable) {
        return false;
      }

      // Blood bank filter
      if (filter.hasBloodBank &&
          !(facility.bloodBank?.isOperational ?? false)) {
        return false;
      }

      // Diagnostic equipment filter
      if (filter.diagnosticEquipment.isNotEmpty) {
        bool hasEquipment = filter.diagnosticEquipment.every(
          (equipment) =>
              facility.equipment.diagnosticEquipment[equipment]?.isAvailable ??
              false,
        );
        if (!hasEquipment) return false;
      }

      return true;
    }).toList();
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // Earth's radius in meters

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  Future<MedicalFacility?> getFacilityById(String id) async {
    if (!_isInitialized) {
      await initializeService();
    }

    try {
      return _cachedFacilities.firstWhere((facility) => facility.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheFacility(MedicalFacility facility) async {
    try {
      final db = await database;

      // Convert complex objects to JSON strings for storage
      final Map<String, dynamic> facilityMap = facility.toJson();
      facilityMap['specialties'] = jsonEncode(facilityMap['specialties']);
      facilityMap['status'] = jsonEncode(facilityMap['status']);
      facilityMap['equipment'] = jsonEncode(facilityMap['equipment']);
      if (facilityMap['bloodBank'] != null) {
        facilityMap['bloodBank'] = jsonEncode(facilityMap['bloodBank']);
      }
      facilityMap['testCosts'] = jsonEncode(facilityMap['testCosts']);
      facilityMap['procedureCosts'] = jsonEncode(facilityMap['procedureCosts']);
      facilityMap['operatingHours'] = jsonEncode(facilityMap['operatingHours']);
      facilityMap['isOnline'] = facilityMap['isOnline'] ? 1 : 0;

      await db.insert(
        _tableName,
        facilityMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Update cached list
      final index = _cachedFacilities.indexWhere((f) => f.id == facility.id);
      if (index >= 0) {
        _cachedFacilities[index] = facility;
      } else {
        _cachedFacilities.add(facility);
      }

      notifyListeners();
    } catch (e) {
      print('Error caching facility: $e');
    }
  }

  Future<void> _loadSampleData() async {
    // Check if sample data already exists
    if (_cachedFacilities.isNotEmpty) return;

    final sampleFacilities = _createSampleFacilities();
    for (final facility in sampleFacilities) {
      await cacheFacility(facility);
    }
  }

  List<MedicalFacility> _createSampleFacilities() {
    return [
      MedicalFacility(
        id: '1',
        name: 'City General Hospital',
        type: 'hospital',
        address: '123 Main Street, Downtown, City 12345',
        latitude: 28.6139,
        longitude: 77.2090,
        phoneNumber: '+91 11 2345 6789',
        email: 'info@citygeneralhospital.com',
        website: 'https://citygeneralhospital.com',
        specialties: [
          'General Medicine',
          'Cardiology',
          'Emergency Medicine',
          'Orthopedics',
        ],
        status: FacilityStatus(
          isOperational: true,
          isEmergencyOpen: true,
          acceptingPatients: true,
          currentOccupancy: 85,
          totalCapacity: 150,
          statusMessage: 'Accepting emergency and general patients',
        ),
        equipment: EquipmentAvailability(
          icuStatus: ICUStatus(
            totalBeds: 20,
            availableBeds: 5,
            occupiedBeds: 15,
            isAvailable: true,
          ),
          ventilatorStatus: VentilatorStatus(
            totalVentilators: 15,
            availableVentilators: 3,
            inUse: 12,
            isAvailable: true,
          ),
          oxygenStatus: OxygenStatus(
            level: 'good',
            percentage: 85,
            isAvailable: true,
            statusMessage: 'Sufficient oxygen supply',
          ),
          diagnosticEquipment: {
            'X-Ray': EquipmentStatus(
              name: 'X-Ray',
              isAvailable: true,
              isWorking: true,
              status: 'available',
              queueLength: 2,
            ),
            'MRI': EquipmentStatus(
              name: 'MRI',
              isAvailable: true,
              isWorking: true,
              status: 'busy',
              queueLength: 5,
              nextAvailableTime: '14:30',
            ),
            'CT Scan': EquipmentStatus(
              name: 'CT Scan',
              isAvailable: true,
              isWorking: true,
              status: 'available',
              queueLength: 1,
            ),
          },
        ),
        bloodBank: BloodBankStatus(
          isOperational: true,
          emergencyContact: '+91 11 2345 6790',
          bloodStock: {
            'O+': BloodTypeStock(
              bloodType: 'O+',
              unitsAvailable: 25,
              status: 'good',
              lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
            ),
            'A+': BloodTypeStock(
              bloodType: 'A+',
              unitsAvailable: 15,
              status: 'moderate',
              lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
            ),
            'B+': BloodTypeStock(
              bloodType: 'B+',
              unitsAvailable: 8,
              status: 'low',
              lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
            ),
          },
        ),
        testCosts: [
          TestCost(
            testName: 'Complete Blood Count',
            category: 'Blood Tests',
            minCost: 300,
            maxCost: 500,
            currency: 'INR',
            isAvailable: true,
          ),
          TestCost(
            testName: 'Chest X-Ray',
            category: 'Radiology',
            minCost: 800,
            maxCost: 1200,
            currency: 'INR',
            isAvailable: true,
          ),
        ],
        procedureCosts: [
          ProcedureCost(
            procedureName: 'Consultation - General Medicine',
            category: 'Consultation',
            minCost: 500,
            maxCost: 800,
            currency: 'INR',
            isAvailable: true,
            duration: '30 minutes',
          ),
        ],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
        isOnline: true,
        rating: 4.2,
        reviewCount: 156,
        emergencyNumber: '+91 11 2345 6791',
        operatingHours: OperatingHours(is24Hours: true, schedule: {}),
      ),

      MedicalFacility(
        id: '2',
        name: 'QuickCare Clinic',
        type: 'clinic',
        address: '456 Health Avenue, Medical District, City 12346',
        latitude: 28.6200,
        longitude: 77.2150,
        phoneNumber: '+91 11 3456 7890',
        specialties: ['General Medicine', 'Pediatrics', 'Dermatology'],
        status: FacilityStatus(
          isOperational: true,
          isEmergencyOpen: false,
          acceptingPatients: true,
          currentOccupancy: 12,
          totalCapacity: 25,
          statusMessage: 'Walk-ins welcome',
        ),
        equipment: EquipmentAvailability(
          icuStatus: ICUStatus(
            totalBeds: 0,
            availableBeds: 0,
            occupiedBeds: 0,
            isAvailable: false,
          ),
          ventilatorStatus: VentilatorStatus(
            totalVentilators: 0,
            availableVentilators: 0,
            inUse: 0,
            isAvailable: false,
          ),
          oxygenStatus: OxygenStatus(
            level: 'good',
            percentage: 95,
            isAvailable: true,
            statusMessage: 'Basic oxygen support available',
          ),
          diagnosticEquipment: {
            'X-Ray': EquipmentStatus(
              name: 'X-Ray',
              isAvailable: true,
              isWorking: true,
              status: 'available',
              queueLength: 0,
            ),
            'ECG': EquipmentStatus(
              name: 'ECG',
              isAvailable: true,
              isWorking: true,
              status: 'available',
              queueLength: 1,
            ),
          },
        ),
        testCosts: [
          TestCost(
            testName: 'Basic Health Checkup',
            category: 'Preventive Care',
            minCost: 1200,
            maxCost: 1500,
            currency: 'INR',
            isAvailable: true,
          ),
        ],
        procedureCosts: [
          ProcedureCost(
            procedureName: 'General Consultation',
            category: 'Consultation',
            minCost: 300,
            maxCost: 500,
            currency: 'INR',
            isAvailable: true,
            duration: '20 minutes',
          ),
        ],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
        isOnline: true,
        rating: 4.0,
        reviewCount: 89,
        operatingHours: OperatingHours(
          is24Hours: false,
          schedule: {
            'monday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 9, minute: 0),
              closeTime: const TimeOfDay(hour: 18, minute: 0),
            ),
            'tuesday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 9, minute: 0),
              closeTime: const TimeOfDay(hour: 18, minute: 0),
            ),
            'wednesday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 9, minute: 0),
              closeTime: const TimeOfDay(hour: 18, minute: 0),
            ),
            'thursday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 9, minute: 0),
              closeTime: const TimeOfDay(hour: 18, minute: 0),
            ),
            'friday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 9, minute: 0),
              closeTime: const TimeOfDay(hour: 18, minute: 0),
            ),
            'saturday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 10, minute: 0),
              closeTime: const TimeOfDay(hour: 16, minute: 0),
            ),
            'sunday': DaySchedule(
              isOpen: false,
              openTime: const TimeOfDay(hour: 0, minute: 0),
              closeTime: const TimeOfDay(hour: 0, minute: 0),
            ),
          },
        ),
      ),

      MedicalFacility(
        id: '3',
        name: 'Advanced Diagnostics Lab',
        type: 'lab',
        address: '789 Laboratory Lane, Science Park, City 12347',
        latitude: 28.6050,
        longitude: 77.2020,
        phoneNumber: '+91 11 4567 8901',
        email: 'contact@advanceddiagnostics.com',
        website: 'https://advanceddiagnostics.com',
        specialties: ['Pathology', 'Radiology', 'Nuclear Medicine'],
        status: FacilityStatus(
          isOperational: true,
          isEmergencyOpen: false,
          acceptingPatients: true,
          currentOccupancy: 45,
          totalCapacity: 80,
          statusMessage: 'Same-day results available',
        ),
        equipment: EquipmentAvailability(
          icuStatus: ICUStatus(
            totalBeds: 0,
            availableBeds: 0,
            occupiedBeds: 0,
            isAvailable: false,
          ),
          ventilatorStatus: VentilatorStatus(
            totalVentilators: 0,
            availableVentilators: 0,
            inUse: 0,
            isAvailable: false,
          ),
          oxygenStatus: OxygenStatus(
            level: 'excellent',
            percentage: 100,
            isAvailable: true,
            statusMessage: 'Full oxygen support for emergencies',
          ),
          diagnosticEquipment: {
            'MRI': EquipmentStatus(
              name: 'MRI',
              isAvailable: true,
              isWorking: true,
              status: 'available',
              queueLength: 3,
            ),
            'CT Scan': EquipmentStatus(
              name: 'CT Scan',
              isAvailable: true,
              isWorking: true,
              status: 'available',
              queueLength: 2,
            ),
            'PET Scan': EquipmentStatus(
              name: 'PET Scan',
              isAvailable: true,
              isWorking: true,
              status: 'busy',
              queueLength: 8,
              nextAvailableTime: '16:00',
            ),
            'Ultrasound': EquipmentStatus(
              name: 'Ultrasound',
              isAvailable: true,
              isWorking: true,
              status: 'available',
              queueLength: 1,
            ),
          },
        ),
        testCosts: [
          TestCost(
            testName: 'MRI Scan - Brain',
            category: 'Radiology',
            minCost: 8000,
            maxCost: 12000,
            currency: 'INR',
            isAvailable: true,
          ),
          TestCost(
            testName: 'Full Body Health Package',
            category: 'Comprehensive',
            minCost: 3500,
            maxCost: 5000,
            currency: 'INR',
            isAvailable: true,
          ),
        ],
        procedureCosts: [],
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 45)),
        isOnline: true,
        rating: 4.5,
        reviewCount: 234,
        operatingHours: OperatingHours(
          is24Hours: false,
          schedule: {
            'monday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 7, minute: 0),
              closeTime: const TimeOfDay(hour: 20, minute: 0),
            ),
            'tuesday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 7, minute: 0),
              closeTime: const TimeOfDay(hour: 20, minute: 0),
            ),
            'wednesday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 7, minute: 0),
              closeTime: const TimeOfDay(hour: 20, minute: 0),
            ),
            'thursday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 7, minute: 0),
              closeTime: const TimeOfDay(hour: 20, minute: 0),
            ),
            'friday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 7, minute: 0),
              closeTime: const TimeOfDay(hour: 20, minute: 0),
            ),
            'saturday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 8, minute: 0),
              closeTime: const TimeOfDay(hour: 18, minute: 0),
            ),
            'sunday': DaySchedule(
              isOpen: true,
              openTime: const TimeOfDay(hour: 9, minute: 0),
              closeTime: const TimeOfDay(hour: 17, minute: 0),
            ),
          },
        ),
      ),
    ];
  }

  Future<void> clearCache() async {
    try {
      final db = await database;
      await db.delete(_tableName);
      _cachedFacilities.clear();
      notifyListeners();
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  Future<void> refreshData() async {
    // In a real app, this would fetch fresh data from the server
    // For now, we'll just reload from cache and notify listeners
    await _loadCachedFacilities();
    notifyListeners();
  }

  List<MedicalFacility> get cachedFacilities =>
      List.unmodifiable(_cachedFacilities);
  bool get isInitialized => _isInitialized;
}
