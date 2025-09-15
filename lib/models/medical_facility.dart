import 'dart:math' as Math;
import 'package:flutter/material.dart';

class MedicalFacility {
  final String id;
  final String name;
  final String type; // 'hospital', 'clinic', 'lab', 'diagnostic_center'
  final String address;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String? email;
  final String? website;
  final List<String> specialties;
  final FacilityStatus status;
  final EquipmentAvailability equipment;
  final BloodBankStatus? bloodBank;
  final List<TestCost> testCosts;
  final List<ProcedureCost> procedureCosts;
  final DateTime lastUpdated;
  final bool isOnline;
  final double? rating;
  final int? reviewCount;
  final String? emergencyNumber;
  final OperatingHours operatingHours;

  MedicalFacility({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    this.email,
    this.website,
    required this.specialties,
    required this.status,
    required this.equipment,
    this.bloodBank,
    required this.testCosts,
    required this.procedureCosts,
    required this.lastUpdated,
    required this.isOnline,
    this.rating,
    this.reviewCount,
    this.emergencyNumber,
    required this.operatingHours,
  });

  factory MedicalFacility.fromJson(Map<String, dynamic> json) {
    return MedicalFacility(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'],
      website: json['website'],
      specialties: List<String>.from(json['specialties'] ?? []),
      status: FacilityStatus.fromJson(json['status'] ?? {}),
      equipment: EquipmentAvailability.fromJson(json['equipment'] ?? {}),
      bloodBank: json['bloodBank'] != null
          ? BloodBankStatus.fromJson(json['bloodBank'])
          : null,
      testCosts: (json['testCosts'] as List<dynamic>? ?? [])
          .map((e) => TestCost.fromJson(e))
          .toList(),
      procedureCosts: (json['procedureCosts'] as List<dynamic>? ?? [])
          .map((e) => ProcedureCost.fromJson(e))
          .toList(),
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
      isOnline: json['isOnline'] ?? false,
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
      emergencyNumber: json['emergencyNumber'],
      operatingHours: OperatingHours.fromJson(json['operatingHours'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'email': email,
      'website': website,
      'specialties': specialties,
      'status': status.toJson(),
      'equipment': equipment.toJson(),
      'bloodBank': bloodBank?.toJson(),
      'testCosts': testCosts.map((e) => e.toJson()).toList(),
      'procedureCosts': procedureCosts.map((e) => e.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'isOnline': isOnline,
      'rating': rating,
      'reviewCount': reviewCount,
      'emergencyNumber': emergencyNumber,
      'operatingHours': operatingHours.toJson(),
    };
  }

  String getDistanceFrom(double userLat, double userLng) {
    // Calculate distance using Haversine formula
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degreesToRadians(latitude - userLat);
    double dLng = _degreesToRadians(longitude - userLng);

    double a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(_degreesToRadians(userLat)) *
            Math.cos(_degreesToRadians(latitude)) *
            Math.sin(dLng / 2) *
            Math.sin(dLng / 2);

    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    double distance = earthRadius * c;

    if (distance < 1) {
      return '${(distance * 1000).round()} m';
    } else {
      return '${distance.toStringAsFixed(1)} km';
    }
  }

  double _degreesToRadians(double degrees) {
    return degrees * (Math.pi / 180);
  }

  String getLastUpdatedText() {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    if (isOnline) {
      if (difference.inMinutes < 1) {
        return 'Updated just now';
      } else if (difference.inMinutes < 60) {
        return 'Updated ${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
      } else if (difference.inHours < 24) {
        return 'Updated ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else {
        return 'Updated ${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      }
    } else {
      // Offline - show last sync time
      return 'Last synced: ${_formatOfflineTimestamp(lastUpdated)}';
    }
  }

  String _formatOfflineTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final isToday =
        now.day == timestamp.day &&
        now.month == timestamp.month &&
        now.year == timestamp.year;

    if (isToday) {
      return 'Today, ${_formatTime(timestamp)}';
    } else {
      return '${timestamp.day} ${_getMonthName(timestamp.month)} ${timestamp.year}, ${_formatTime(timestamp)}';
    }
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour > 12
        ? timestamp.hour - 12
        : (timestamp.hour == 0 ? 12 : timestamp.hour);
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

class FacilityStatus {
  final bool isOperational;
  final bool isEmergencyOpen;
  final bool acceptingPatients;
  final int currentOccupancy;
  final int totalCapacity;
  final String statusMessage;

  FacilityStatus({
    required this.isOperational,
    required this.isEmergencyOpen,
    required this.acceptingPatients,
    required this.currentOccupancy,
    required this.totalCapacity,
    required this.statusMessage,
  });

  factory FacilityStatus.fromJson(Map<String, dynamic> json) {
    return FacilityStatus(
      isOperational: json['isOperational'] ?? true,
      isEmergencyOpen: json['isEmergencyOpen'] ?? true,
      acceptingPatients: json['acceptingPatients'] ?? true,
      currentOccupancy: json['currentOccupancy'] ?? 0,
      totalCapacity: json['totalCapacity'] ?? 100,
      statusMessage: json['statusMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isOperational': isOperational,
      'isEmergencyOpen': isEmergencyOpen,
      'acceptingPatients': acceptingPatients,
      'currentOccupancy': currentOccupancy,
      'totalCapacity': totalCapacity,
      'statusMessage': statusMessage,
    };
  }

  double get occupancyPercentage =>
      totalCapacity > 0 ? (currentOccupancy / totalCapacity) * 100 : 0;
}

class EquipmentAvailability {
  final ICUStatus icuStatus;
  final VentilatorStatus ventilatorStatus;
  final OxygenStatus oxygenStatus;
  final Map<String, EquipmentStatus>
  diagnosticEquipment; // X-ray, MRI, CT, etc.

  EquipmentAvailability({
    required this.icuStatus,
    required this.ventilatorStatus,
    required this.oxygenStatus,
    required this.diagnosticEquipment,
  });

  factory EquipmentAvailability.fromJson(Map<String, dynamic> json) {
    Map<String, EquipmentStatus> equipment = {};
    if (json['diagnosticEquipment'] != null) {
      json['diagnosticEquipment'].forEach((key, value) {
        equipment[key] = EquipmentStatus.fromJson(value);
      });
    }

    return EquipmentAvailability(
      icuStatus: ICUStatus.fromJson(json['icuStatus'] ?? {}),
      ventilatorStatus: VentilatorStatus.fromJson(
        json['ventilatorStatus'] ?? {},
      ),
      oxygenStatus: OxygenStatus.fromJson(json['oxygenStatus'] ?? {}),
      diagnosticEquipment: equipment,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> equipment = {};
    diagnosticEquipment.forEach((key, value) {
      equipment[key] = value.toJson();
    });

    return {
      'icuStatus': icuStatus.toJson(),
      'ventilatorStatus': ventilatorStatus.toJson(),
      'oxygenStatus': oxygenStatus.toJson(),
      'diagnosticEquipment': equipment,
    };
  }
}

class ICUStatus {
  final int totalBeds;
  final int availableBeds;
  final int occupiedBeds;
  final bool isAvailable;

  ICUStatus({
    required this.totalBeds,
    required this.availableBeds,
    required this.occupiedBeds,
    required this.isAvailable,
  });

  factory ICUStatus.fromJson(Map<String, dynamic> json) {
    return ICUStatus(
      totalBeds: json['totalBeds'] ?? 0,
      availableBeds: json['availableBeds'] ?? 0,
      occupiedBeds: json['occupiedBeds'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBeds': totalBeds,
      'availableBeds': availableBeds,
      'occupiedBeds': occupiedBeds,
      'isAvailable': isAvailable,
    };
  }

  double get occupancyPercentage =>
      totalBeds > 0 ? (occupiedBeds / totalBeds) * 100 : 0;
}

class VentilatorStatus {
  final int totalVentilators;
  final int availableVentilators;
  final int inUse;
  final bool isAvailable;

  VentilatorStatus({
    required this.totalVentilators,
    required this.availableVentilators,
    required this.inUse,
    required this.isAvailable,
  });

  factory VentilatorStatus.fromJson(Map<String, dynamic> json) {
    return VentilatorStatus(
      totalVentilators: json['totalVentilators'] ?? 0,
      availableVentilators: json['availableVentilators'] ?? 0,
      inUse: json['inUse'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalVentilators': totalVentilators,
      'availableVentilators': availableVentilators,
      'inUse': inUse,
      'isAvailable': isAvailable,
    };
  }
}

class OxygenStatus {
  final String level; // 'critical', 'low', 'moderate', 'good', 'excellent'
  final int percentage;
  final bool isAvailable;
  final String statusMessage;

  OxygenStatus({
    required this.level,
    required this.percentage,
    required this.isAvailable,
    required this.statusMessage,
  });

  factory OxygenStatus.fromJson(Map<String, dynamic> json) {
    return OxygenStatus(
      level: json['level'] ?? 'unknown',
      percentage: json['percentage'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
      statusMessage: json['statusMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'percentage': percentage,
      'isAvailable': isAvailable,
      'statusMessage': statusMessage,
    };
  }
}

class EquipmentStatus {
  final String name;
  final bool isAvailable;
  final bool isWorking;
  final String status; // 'available', 'busy', 'maintenance', 'out_of_order'
  final int queueLength;
  final String? nextAvailableTime;

  EquipmentStatus({
    required this.name,
    required this.isAvailable,
    required this.isWorking,
    required this.status,
    required this.queueLength,
    this.nextAvailableTime,
  });

  factory EquipmentStatus.fromJson(Map<String, dynamic> json) {
    return EquipmentStatus(
      name: json['name'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      isWorking: json['isWorking'] ?? true,
      status: json['status'] ?? 'unknown',
      queueLength: json['queueLength'] ?? 0,
      nextAvailableTime: json['nextAvailableTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isAvailable': isAvailable,
      'isWorking': isWorking,
      'status': status,
      'queueLength': queueLength,
      'nextAvailableTime': nextAvailableTime,
    };
  }
}

class BloodBankStatus {
  final Map<String, BloodTypeStock> bloodStock;
  final bool isOperational;
  final String? emergencyContact;

  BloodBankStatus({
    required this.bloodStock,
    required this.isOperational,
    this.emergencyContact,
  });

  factory BloodBankStatus.fromJson(Map<String, dynamic> json) {
    Map<String, BloodTypeStock> stock = {};
    if (json['bloodStock'] != null) {
      json['bloodStock'].forEach((key, value) {
        stock[key] = BloodTypeStock.fromJson(value);
      });
    }

    return BloodBankStatus(
      bloodStock: stock,
      isOperational: json['isOperational'] ?? false,
      emergencyContact: json['emergencyContact'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> stock = {};
    bloodStock.forEach((key, value) {
      stock[key] = value.toJson();
    });

    return {
      'bloodStock': stock,
      'isOperational': isOperational,
      'emergencyContact': emergencyContact,
    };
  }
}

class BloodTypeStock {
  final String bloodType;
  final int unitsAvailable;
  final String status; // 'critical', 'low', 'moderate', 'good'
  final DateTime lastUpdated;

  BloodTypeStock({
    required this.bloodType,
    required this.unitsAvailable,
    required this.status,
    required this.lastUpdated,
  });

  factory BloodTypeStock.fromJson(Map<String, dynamic> json) {
    return BloodTypeStock(
      bloodType: json['bloodType'] ?? '',
      unitsAvailable: json['unitsAvailable'] ?? 0,
      status: json['status'] ?? 'unknown',
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bloodType': bloodType,
      'unitsAvailable': unitsAvailable,
      'status': status,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class TestCost {
  final String testName;
  final String category;
  final double minCost;
  final double maxCost;
  final String currency;
  final String? description;
  final bool isAvailable;

  TestCost({
    required this.testName,
    required this.category,
    required this.minCost,
    required this.maxCost,
    required this.currency,
    this.description,
    required this.isAvailable,
  });

  factory TestCost.fromJson(Map<String, dynamic> json) {
    return TestCost(
      testName: json['testName'] ?? '',
      category: json['category'] ?? '',
      minCost: (json['minCost'] ?? 0.0).toDouble(),
      maxCost: (json['maxCost'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'INR',
      description: json['description'],
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testName': testName,
      'category': category,
      'minCost': minCost,
      'maxCost': maxCost,
      'currency': currency,
      'description': description,
      'isAvailable': isAvailable,
    };
  }

  String get costRange {
    if (minCost == maxCost) {
      return '₹${minCost.toStringAsFixed(0)}';
    } else {
      return '₹${minCost.toStringAsFixed(0)} - ₹${maxCost.toStringAsFixed(0)}';
    }
  }
}

class ProcedureCost {
  final String procedureName;
  final String category;
  final double minCost;
  final double maxCost;
  final String currency;
  final String? description;
  final bool isAvailable;
  final String? duration;

  ProcedureCost({
    required this.procedureName,
    required this.category,
    required this.minCost,
    required this.maxCost,
    required this.currency,
    this.description,
    required this.isAvailable,
    this.duration,
  });

  factory ProcedureCost.fromJson(Map<String, dynamic> json) {
    return ProcedureCost(
      procedureName: json['procedureName'] ?? '',
      category: json['category'] ?? '',
      minCost: (json['minCost'] ?? 0.0).toDouble(),
      maxCost: (json['maxCost'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'INR',
      description: json['description'],
      isAvailable: json['isAvailable'] ?? true,
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'procedureName': procedureName,
      'category': category,
      'minCost': minCost,
      'maxCost': maxCost,
      'currency': currency,
      'description': description,
      'isAvailable': isAvailable,
      'duration': duration,
    };
  }

  String get costRange {
    if (minCost == maxCost) {
      return '₹${minCost.toStringAsFixed(0)}';
    } else {
      return '₹${minCost.toStringAsFixed(0)} - ₹${maxCost.toStringAsFixed(0)}';
    }
  }
}

class OperatingHours {
  final Map<String, DaySchedule> schedule;
  final bool is24Hours;
  final String? specialHours;

  OperatingHours({
    required this.schedule,
    required this.is24Hours,
    this.specialHours,
  });

  factory OperatingHours.fromJson(Map<String, dynamic> json) {
    Map<String, DaySchedule> scheduleMap = {};
    if (json['schedule'] != null) {
      json['schedule'].forEach((key, value) {
        scheduleMap[key] = DaySchedule.fromJson(value);
      });
    }

    return OperatingHours(
      schedule: scheduleMap,
      is24Hours: json['is24Hours'] ?? false,
      specialHours: json['specialHours'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> scheduleMap = {};
    schedule.forEach((key, value) {
      scheduleMap[key] = value.toJson();
    });

    return {
      'schedule': scheduleMap,
      'is24Hours': is24Hours,
      'specialHours': specialHours,
    };
  }

  bool isOpenNow() {
    if (is24Hours) return true;

    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final todaySchedule = schedule[dayName.toLowerCase()];

    if (todaySchedule == null || !todaySchedule.isOpen) return false;

    final currentTime = TimeOfDay.fromDateTime(now);
    return _isTimeBetween(
      currentTime,
      todaySchedule.openTime,
      todaySchedule.closeTime,
    );
  }

  String _getDayName(int weekday) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[weekday - 1];
  }

  bool _isTimeBetween(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }
}

class DaySchedule {
  final bool isOpen;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  final String? notes;

  DaySchedule({
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
    this.notes,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      isOpen: json['isOpen'] ?? false,
      openTime: _parseTimeOfDay(json['openTime'] ?? '00:00'),
      closeTime: _parseTimeOfDay(json['closeTime'] ?? '00:00'),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isOpen': isOpen,
      'openTime':
          '${openTime.hour.toString().padLeft(2, '0')}:${openTime.minute.toString().padLeft(2, '0')}',
      'closeTime':
          '${closeTime.hour.toString().padLeft(2, '0')}:${closeTime.minute.toString().padLeft(2, '0')}',
      'notes': notes,
    };
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

// Search and filter models
class FacilitySearchFilter {
  final String? facilityType;
  final List<String> specialties;
  final double maxDistance;
  final bool onlyOpenNow;
  final bool hasICU;
  final bool hasVentilator;
  final bool hasBloodBank;
  final List<String> diagnosticEquipment;
  final String? sortBy; // 'distance', 'rating', 'availability'

  FacilitySearchFilter({
    this.facilityType,
    this.specialties = const [],
    this.maxDistance = 50.0,
    this.onlyOpenNow = false,
    this.hasICU = false,
    this.hasVentilator = false,
    this.hasBloodBank = false,
    this.diagnosticEquipment = const [],
    this.sortBy,
  });

  FacilitySearchFilter copyWith({
    String? facilityType,
    List<String>? specialties,
    double? maxDistance,
    bool? onlyOpenNow,
    bool? hasICU,
    bool? hasVentilator,
    bool? hasBloodBank,
    List<String>? diagnosticEquipment,
    String? sortBy,
  }) {
    return FacilitySearchFilter(
      facilityType: facilityType ?? this.facilityType,
      specialties: specialties ?? this.specialties,
      maxDistance: maxDistance ?? this.maxDistance,
      onlyOpenNow: onlyOpenNow ?? this.onlyOpenNow,
      hasICU: hasICU ?? this.hasICU,
      hasVentilator: hasVentilator ?? this.hasVentilator,
      hasBloodBank: hasBloodBank ?? this.hasBloodBank,
      diagnosticEquipment: diagnosticEquipment ?? this.diagnosticEquipment,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

// Constants for facility types and specialties
class FacilityConstants {
  static const facilityTypes = [
    'hospital',
    'clinic',
    'lab',
    'diagnostic_center',
    'pharmacy',
    'blood_bank',
  ];

  static const specialties = [
    'General Medicine',
    'Cardiology',
    'Orthopedics',
    'Neurology',
    'Pediatrics',
    'Gynecology',
    'Dermatology',
    'Ophthalmology',
    'ENT',
    'Psychiatry',
    'Emergency Medicine',
    'Radiology',
    'Pathology',
  ];

  static const diagnosticEquipment = [
    'X-Ray',
    'MRI',
    'CT Scan',
    'Ultrasound',
    'ECG',
    'Echocardiography',
    'Mammography',
    'Endoscopy',
    'Colonoscopy',
    'PET Scan',
  ];

  static const bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
}
