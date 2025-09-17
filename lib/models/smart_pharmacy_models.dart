import 'dart:math' show atan2, cos, pi, sin, sqrt;
import 'dart:math' as math;
import 'medicine.dart';

/// Comprehensive analysis of a prescription with cost optimization suggestions
class PrescriptionAnalysis {
  final String id;
  final String prescriptionId;
  final String patientId;
  final String doctorId;
  final List<PrescribedMedicine> originalMedicines;
  final List<PrescribedMedicine> optimizedMedicines;
  final double originalTotalCost;
  final double optimizedTotalCost;
  final double totalSavings;
  final double savingsPercentage;
  final List<GovernmentSchemeMatch> applicableSchemes;
  final List<String> nearbyPharmacies;
  final List<String> janAushadhiCenters;
  final DateTime analyzedAt;
  final bool hasGenericAlternatives;
  final bool hasSchemeEligibility;

  PrescriptionAnalysis({
    required this.id,
    required this.prescriptionId,
    required this.patientId,
    required this.doctorId,
    required this.originalMedicines,
    required this.optimizedMedicines,
    required this.originalTotalCost,
    required this.optimizedTotalCost,
    required this.totalSavings,
    required this.savingsPercentage,
    this.applicableSchemes = const [],
    this.nearbyPharmacies = const [],
    this.janAushadhiCenters = const [],
    required this.analyzedAt,
    required this.hasGenericAlternatives,
    required this.hasSchemeEligibility,
  });

  /// Create analysis from original prescription
  factory PrescriptionAnalysis.create({
    required String prescriptionId,
    required String patientId,
    required String doctorId,
    required List<PrescribedMedicine> medicines,
  }) {
    final originalCost = medicines.fold(0.0, (sum, med) => sum + med.totalCost);
    final optimizedCost = medicines.fold(0.0, (sum, med) {
      final bestGeneric = med.bestGenericAlternative;
      return sum +
          (bestGeneric != null
              ? (bestGeneric.genericMedicine.price * med.quantity)
              : med.totalCost);
    });

    final savings = originalCost - optimizedCost;
    final savingsPercentage = originalCost > 0
        ? (savings / originalCost) * 100
        : 0.0;

    return PrescriptionAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      prescriptionId: prescriptionId,
      patientId: patientId,
      doctorId: doctorId,
      originalMedicines: medicines,
      optimizedMedicines:
          medicines, // This would be processed with alternatives
      originalTotalCost: originalCost,
      optimizedTotalCost: optimizedCost,
      totalSavings: savings,
      savingsPercentage: savingsPercentage,
      analyzedAt: DateTime.now(),
      hasGenericAlternatives: medicines.any(
        (med) => med.genericAlternatives.isNotEmpty,
      ),
      hasSchemeEligibility: medicines.any(
        (med) => med.schemeEligibility.isNotEmpty,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prescriptionId': prescriptionId,
      'patientId': patientId,
      'doctorId': doctorId,
      'originalMedicines': originalMedicines
          .map((med) => med.toJson())
          .toList(),
      'optimizedMedicines': optimizedMedicines
          .map((med) => med.toJson())
          .toList(),
      'originalTotalCost': originalTotalCost,
      'optimizedTotalCost': optimizedTotalCost,
      'totalSavings': totalSavings,
      'savingsPercentage': savingsPercentage,
      'applicableSchemes': applicableSchemes
          .map((scheme) => scheme.toJson())
          .toList(),
      'nearbyPharmacies': nearbyPharmacies,
      'janAushadhiCenters': janAushadhiCenters,
      'analyzedAt': analyzedAt.toIso8601String(),
      'hasGenericAlternatives': hasGenericAlternatives,
      'hasSchemeEligibility': hasSchemeEligibility,
    };
  }

  factory PrescriptionAnalysis.fromJson(Map<String, dynamic> json) {
    return PrescriptionAnalysis(
      id: json['id'],
      prescriptionId: json['prescriptionId'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      originalMedicines: (json['originalMedicines'] as List)
          .map((med) => PrescribedMedicine.fromJson(med))
          .toList(),
      optimizedMedicines: (json['optimizedMedicines'] as List)
          .map((med) => PrescribedMedicine.fromJson(med))
          .toList(),
      originalTotalCost: (json['originalTotalCost'] as num).toDouble(),
      optimizedTotalCost: (json['optimizedTotalCost'] as num).toDouble(),
      totalSavings: (json['totalSavings'] as num).toDouble(),
      savingsPercentage: (json['savingsPercentage'] as num).toDouble(),
      applicableSchemes:
          (json['applicableSchemes'] as List?)
              ?.map((scheme) => GovernmentSchemeMatch.fromJson(scheme))
              .toList() ??
          [],
      nearbyPharmacies: List<String>.from(json['nearbyPharmacies'] ?? []),
      janAushadhiCenters: List<String>.from(json['janAushadhiCenters'] ?? []),
      analyzedAt: DateTime.parse(json['analyzedAt']),
      hasGenericAlternatives: json['hasGenericAlternatives'] ?? false,
      hasSchemeEligibility: json['hasSchemeEligibility'] ?? false,
    );
  }
}

/// Represents a government health scheme
class GovernmentScheme {
  final String id;
  final String name;
  final String shortName;
  final String description;
  final String
  state; // 'central' for central schemes, state name for state schemes
  final List<String> eligibilityCriteria;
  final List<String>
  coveredMedicines; // Medicine categories or specific medicines
  final double maxSubsidyAmount;
  final double subsidyPercentage;
  final bool isActive;
  final List<String> requiredDocuments;
  final String applicationProcess;
  final String officialWebsite;
  final String helplineNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  GovernmentScheme({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
    required this.state,
    this.eligibilityCriteria = const [],
    this.coveredMedicines = const [],
    this.maxSubsidyAmount = 0,
    this.subsidyPercentage = 0,
    this.isActive = true,
    this.requiredDocuments = const [],
    this.applicationProcess = '',
    this.officialWebsite = '',
    this.helplineNumber = '',
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if a patient is eligible for this scheme
  bool isPatientEligible(Map<String, dynamic> patientProfile) {
    // This would contain complex eligibility logic
    // For now, simplified version
    return isActive;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'description': description,
      'state': state,
      'eligibilityCriteria': eligibilityCriteria,
      'coveredMedicines': coveredMedicines,
      'maxSubsidyAmount': maxSubsidyAmount,
      'subsidyPercentage': subsidyPercentage,
      'isActive': isActive,
      'requiredDocuments': requiredDocuments,
      'applicationProcess': applicationProcess,
      'officialWebsite': officialWebsite,
      'helplineNumber': helplineNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory GovernmentScheme.fromJson(Map<String, dynamic> json) {
    return GovernmentScheme(
      id: json['id'],
      name: json['name'],
      shortName: json['shortName'],
      description: json['description'],
      state: json['state'],
      eligibilityCriteria: List<String>.from(json['eligibilityCriteria'] ?? []),
      coveredMedicines: List<String>.from(json['coveredMedicines'] ?? []),
      maxSubsidyAmount: (json['maxSubsidyAmount'] as num?)?.toDouble() ?? 0,
      subsidyPercentage: (json['subsidyPercentage'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] ?? true,
      requiredDocuments: List<String>.from(json['requiredDocuments'] ?? []),
      applicationProcess: json['applicationProcess'] ?? '',
      officialWebsite: json['officialWebsite'] ?? '',
      helplineNumber: json['helplineNumber'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

/// Represents a match between patient/medicine and government scheme
class GovernmentSchemeMatch {
  final GovernmentScheme scheme;
  final String medicineId;
  final String medicineName;
  final double originalPrice;
  final double subsidizedPrice;
  final double savingsAmount;
  final double savingsPercentage;
  final bool isFullyCovered;
  final String
  eligibilityStatus; // 'eligible', 'likely_eligible', 'not_eligible'
  final List<String> missingDocuments;
  final List<String> nearbyApprovedPharmacies;
  final String? cautionNote;

  GovernmentSchemeMatch({
    required this.scheme,
    required this.medicineId,
    required this.medicineName,
    required this.originalPrice,
    required this.subsidizedPrice,
    required this.savingsAmount,
    required this.savingsPercentage,
    this.isFullyCovered = false,
    this.eligibilityStatus = 'eligible',
    this.missingDocuments = const [],
    this.nearbyApprovedPharmacies = const [],
    this.cautionNote,
  });

  factory GovernmentSchemeMatch.create({
    required GovernmentScheme scheme,
    required Medicine medicine,
    required Map<String, dynamic> patientProfile,
  }) {
    final subsidizedPrice = scheme.subsidyPercentage > 0
        ? medicine.price * (1 - scheme.subsidyPercentage / 100)
        : math.max(0.0, medicine.price - scheme.maxSubsidyAmount);

    final savings = medicine.price - subsidizedPrice;
    final savingsPercentage = medicine.price > 0
        ? (savings / medicine.price) * 100
        : 0.0;

    return GovernmentSchemeMatch(
      scheme: scheme,
      medicineId: medicine.id,
      medicineName: medicine.name,
      originalPrice: medicine.price,
      subsidizedPrice: subsidizedPrice,
      savingsAmount: savings,
      savingsPercentage: savingsPercentage,
      isFullyCovered: subsidizedPrice <= 0,
      eligibilityStatus: scheme.isPatientEligible(patientProfile)
          ? 'eligible'
          : 'not_eligible',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheme': scheme.toJson(),
      'medicineId': medicineId,
      'medicineName': medicineName,
      'originalPrice': originalPrice,
      'subsidizedPrice': subsidizedPrice,
      'savingsAmount': savingsAmount,
      'savingsPercentage': savingsPercentage,
      'isFullyCovered': isFullyCovered,
      'eligibilityStatus': eligibilityStatus,
      'missingDocuments': missingDocuments,
      'nearbyApprovedPharmacies': nearbyApprovedPharmacies,
      'cautionNote': cautionNote,
    };
  }

  factory GovernmentSchemeMatch.fromJson(Map<String, dynamic> json) {
    return GovernmentSchemeMatch(
      scheme: GovernmentScheme.fromJson(json['scheme']),
      medicineId: json['medicineId'],
      medicineName: json['medicineName'],
      originalPrice: (json['originalPrice'] as num).toDouble(),
      subsidizedPrice: (json['subsidizedPrice'] as num).toDouble(),
      savingsAmount: (json['savingsAmount'] as num).toDouble(),
      savingsPercentage: (json['savingsPercentage'] as num).toDouble(),
      isFullyCovered: json['isFullyCovered'] ?? false,
      eligibilityStatus: json['eligibilityStatus'] ?? 'eligible',
      missingDocuments: List<String>.from(json['missingDocuments'] ?? []),
      nearbyApprovedPharmacies: List<String>.from(
        json['nearbyApprovedPharmacies'] ?? [],
      ),
      cautionNote: json['cautionNote'],
    );
  }
}

/// Represents a pharmacy with scheme support information
class Pharmacy {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final bool isJanAushadhiCenter;
  final List<String> supportedSchemes;
  final double rating;
  final List<String> availableMedicines;
  final Map<String, double> medicinesPricing;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional properties for Smart Pharmacy UI
  final double distanceFromUser;
  final bool isOpen;
  final bool hasGenericMedicines;
  final List<String> specialFeatures;
  final String openingHours;

  Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.phoneNumber = '',
    required this.latitude,
    required this.longitude,
    this.isJanAushadhiCenter = false,
    this.supportedSchemes = const [],
    this.rating = 0.0,
    this.availableMedicines = const [],
    this.medicinesPricing = const {},
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
    this.distanceFromUser = 0.0,
    this.isOpen = true,
    this.hasGenericMedicines = false,
    this.specialFeatures = const [],
    this.openingHours = '9:00 AM - 9:00 PM',
  });

  /// Calculate distance from a given location
  double distanceFrom(double lat, double lon) {
    // Simplified distance calculation
    // In real implementation, use proper geographical distance formula
    const earthRadius = 6371; // km
    final latDelta = (lat - latitude) * (pi / 180);
    final lonDelta = (lon - longitude) * (pi / 180);

    final a =
        sin(latDelta / 2) * sin(latDelta / 2) +
        cos(latitude * (pi / 180)) *
            cos(lat * (pi / 180)) *
            sin(lonDelta / 2) *
            sin(lonDelta / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'isJanAushadhiCenter': isJanAushadhiCenter,
      'supportedSchemes': supportedSchemes,
      'rating': rating,
      'availableMedicines': availableMedicines,
      'medicinesPricing': medicinesPricing,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'distanceFromUser': distanceFromUser,
      'isOpen': isOpen,
      'hasGenericMedicines': hasGenericMedicines,
      'specialFeatures': specialFeatures,
      'openingHours': openingHours,
    };
  }

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      phoneNumber: json['phoneNumber'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isJanAushadhiCenter: json['isJanAushadhiCenter'] ?? false,
      supportedSchemes: List<String>.from(json['supportedSchemes'] ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      availableMedicines: List<String>.from(json['availableMedicines'] ?? []),
      medicinesPricing: Map<String, double>.from(
        json['medicinesPricing'] ?? {},
      ),
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      distanceFromUser: (json['distanceFromUser'] as num?)?.toDouble() ?? 0.0,
      isOpen: json['isOpen'] ?? true,
      hasGenericMedicines: json['hasGenericMedicines'] ?? false,
      specialFeatures: List<String>.from(json['specialFeatures'] ?? []),
      openingHours: json['openingHours'] ?? '9:00 AM - 9:00 PM',
    );
  }
}

/// Patient savings summary for analytics
class PatientSavingsSummary {
  final String patientId;
  final double totalSavingsToDate;
  final double averageSavingsPerPrescription;
  final int totalPrescriptionsAnalyzed;
  final int genericAlternativesUsed;
  final int schemeBenefitsAvailed;
  final Map<String, double> savingsByCategory;
  final List<String> mostUsedSchemes;
  final DateTime lastUpdated;

  PatientSavingsSummary({
    required this.patientId,
    required this.totalSavingsToDate,
    required this.averageSavingsPerPrescription,
    required this.totalPrescriptionsAnalyzed,
    required this.genericAlternativesUsed,
    required this.schemeBenefitsAvailed,
    this.savingsByCategory = const {},
    this.mostUsedSchemes = const [],
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'totalSavingsToDate': totalSavingsToDate,
      'averageSavingsPerPrescription': averageSavingsPerPrescription,
      'totalPrescriptionsAnalyzed': totalPrescriptionsAnalyzed,
      'genericAlternativesUsed': genericAlternativesUsed,
      'schemeBenefitsAvailed': schemeBenefitsAvailed,
      'savingsByCategory': savingsByCategory,
      'mostUsedSchemes': mostUsedSchemes,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory PatientSavingsSummary.fromJson(Map<String, dynamic> json) {
    return PatientSavingsSummary(
      patientId: json['patientId'],
      totalSavingsToDate: (json['totalSavingsToDate'] as num).toDouble(),
      averageSavingsPerPrescription:
          (json['averageSavingsPerPrescription'] as num).toDouble(),
      totalPrescriptionsAnalyzed: json['totalPrescriptionsAnalyzed'],
      genericAlternativesUsed: json['genericAlternativesUsed'],
      schemeBenefitsAvailed: json['schemeBenefitsAvailed'],
      savingsByCategory: Map<String, double>.from(
        json['savingsByCategory'] ?? {},
      ),
      mostUsedSchemes: List<String>.from(json['mostUsedSchemes'] ?? []),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
