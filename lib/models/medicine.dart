/// Represents a medicine with brand and generic information
class Medicine {
  final String id;
  final String name;
  final String chemicalComposition;
  final String manufacturer;
  final String category;
  final double price;
  final String strength; // e.g., "500mg", "10ml"
  final String form; // tablet, syrup, injection, etc.
  final bool isPrescriptionRequired;
  final bool isGeneric;
  final String? brandEquivalentId;
  final List<String> alternatives; // IDs of alternative medicines
  final DateTime createdAt;
  final DateTime updatedAt;

  Medicine({
    required this.id,
    required this.name,
    required this.chemicalComposition,
    required this.manufacturer,
    required this.category,
    required this.price,
    required this.strength,
    required this.form,
    this.isPrescriptionRequired = true,
    this.isGeneric = false,
    this.brandEquivalentId,
    this.alternatives = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate cost savings compared to another medicine
  double calculateSavings(Medicine comparedMedicine) {
    return comparedMedicine.price - price;
  }

  /// Calculate percentage savings
  double calculateSavingsPercentage(Medicine comparedMedicine) {
    if (comparedMedicine.price == 0) return 0;
    return ((comparedMedicine.price - price) / comparedMedicine.price) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'chemicalComposition': chemicalComposition,
      'manufacturer': manufacturer,
      'category': category,
      'price': price,
      'strength': strength,
      'form': form,
      'isPrescriptionRequired': isPrescriptionRequired,
      'isGeneric': isGeneric,
      'brandEquivalentId': brandEquivalentId,
      'alternatives': alternatives,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      chemicalComposition: json['chemicalComposition'],
      manufacturer: json['manufacturer'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      strength: json['strength'],
      form: json['form'],
      isPrescriptionRequired: json['isPrescriptionRequired'] ?? true,
      isGeneric: json['isGeneric'] ?? false,
      brandEquivalentId: json['brandEquivalentId'],
      alternatives: List<String>.from(json['alternatives'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Medicine copyWith({
    String? id,
    String? name,
    String? chemicalComposition,
    String? manufacturer,
    String? category,
    double? price,
    String? strength,
    String? form,
    bool? isPrescriptionRequired,
    bool? isGeneric,
    String? brandEquivalentId,
    List<String>? alternatives,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      chemicalComposition: chemicalComposition ?? this.chemicalComposition,
      manufacturer: manufacturer ?? this.manufacturer,
      category: category ?? this.category,
      price: price ?? this.price,
      strength: strength ?? this.strength,
      form: form ?? this.form,
      isPrescriptionRequired:
          isPrescriptionRequired ?? this.isPrescriptionRequired,
      isGeneric: isGeneric ?? this.isGeneric,
      brandEquivalentId: brandEquivalentId ?? this.brandEquivalentId,
      alternatives: alternatives ?? this.alternatives,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Represents a generic alternative suggestion for a branded medicine
class GenericAlternative {
  final Medicine brandedMedicine;
  final Medicine genericMedicine;
  final double costSavings;
  final double savingsPercentage;
  final String efficacyRating; // equivalent, near-equivalent, etc.
  final List<String> availablePharmacies;
  final bool isRecommended;
  final String? cautionNote;

  GenericAlternative({
    required this.brandedMedicine,
    required this.genericMedicine,
    required this.costSavings,
    required this.savingsPercentage,
    this.efficacyRating = 'equivalent',
    this.availablePharmacies = const [],
    this.isRecommended = true,
    this.cautionNote,
  });

  factory GenericAlternative.create(Medicine branded, Medicine generic) {
    final savings = branded.price - generic.price;
    final percentage = branded.price > 0
        ? (savings / branded.price) * 100
        : 0.0;

    return GenericAlternative(
      brandedMedicine: branded,
      genericMedicine: generic,
      costSavings: savings,
      savingsPercentage: percentage,
      isRecommended: savings > 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brandedMedicine': brandedMedicine.toJson(),
      'genericMedicine': genericMedicine.toJson(),
      'costSavings': costSavings,
      'savingsPercentage': savingsPercentage,
      'efficacyRating': efficacyRating,
      'availablePharmacies': availablePharmacies,
      'isRecommended': isRecommended,
      'cautionNote': cautionNote,
    };
  }

  factory GenericAlternative.fromJson(Map<String, dynamic> json) {
    return GenericAlternative(
      brandedMedicine: Medicine.fromJson(json['brandedMedicine']),
      genericMedicine: Medicine.fromJson(json['genericMedicine']),
      costSavings: (json['costSavings'] as num).toDouble(),
      savingsPercentage: (json['savingsPercentage'] as num).toDouble(),
      efficacyRating: json['efficacyRating'] ?? 'equivalent',
      availablePharmacies: List<String>.from(json['availablePharmacies'] ?? []),
      isRecommended: json['isRecommended'] ?? true,
      cautionNote: json['cautionNote'],
    );
  }
}

/// Represents a prescribed medicine in a prescription
class PrescribedMedicine {
  final String id;
  final Medicine medicine;
  final String dosage;
  final String frequency;
  final int durationDays;
  final String instructions;
  final int quantity;
  final double totalCost;
  final List<GenericAlternative> genericAlternatives;
  final List<GovernmentSchemeEligibility> schemeEligibility;

  PrescribedMedicine({
    required this.id,
    required this.medicine,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    this.instructions = '',
    required this.quantity,
    required this.totalCost,
    this.genericAlternatives = const [],
    this.schemeEligibility = const [],
  });

  /// Calculate total savings if all generic alternatives are used
  double get totalPotentialSavings {
    return genericAlternatives.fold(
      0.0,
      (sum, alt) => sum + (alt.costSavings * quantity),
    );
  }

  /// Get the best generic alternative (highest savings)
  GenericAlternative? get bestGenericAlternative {
    if (genericAlternatives.isEmpty) return null;
    return genericAlternatives.reduce(
      (a, b) => a.costSavings > b.costSavings ? a : b,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicine': medicine.toJson(),
      'dosage': dosage,
      'frequency': frequency,
      'durationDays': durationDays,
      'instructions': instructions,
      'quantity': quantity,
      'totalCost': totalCost,
      'genericAlternatives': genericAlternatives
          .map((alt) => alt.toJson())
          .toList(),
      'schemeEligibility': schemeEligibility
          .map((scheme) => scheme.toJson())
          .toList(),
    };
  }

  factory PrescribedMedicine.fromJson(Map<String, dynamic> json) {
    return PrescribedMedicine(
      id: json['id'],
      medicine: Medicine.fromJson(json['medicine']),
      dosage: json['dosage'],
      frequency: json['frequency'],
      durationDays: json['durationDays'],
      instructions: json['instructions'] ?? '',
      quantity: json['quantity'],
      totalCost: (json['totalCost'] as num).toDouble(),
      genericAlternatives:
          (json['genericAlternatives'] as List?)
              ?.map((alt) => GenericAlternative.fromJson(alt))
              .toList() ??
          [],
      schemeEligibility:
          (json['schemeEligibility'] as List?)
              ?.map((scheme) => GovernmentSchemeEligibility.fromJson(scheme))
              .toList() ??
          [],
    );
  }
}

/// Represents government scheme eligibility for medicines
class GovernmentSchemeEligibility {
  final String schemeId;
  final String schemeName;
  final String description;
  final double subsidyAmount;
  final double subsidyPercentage;
  final bool isFullyCovered;
  final List<String> eligibilityCriteria;
  final List<String> requiredDocuments;
  final List<String> approvedPharmacies;
  final String applicationProcess;
  final String contactInfo;

  GovernmentSchemeEligibility({
    required this.schemeId,
    required this.schemeName,
    required this.description,
    this.subsidyAmount = 0,
    this.subsidyPercentage = 0,
    this.isFullyCovered = false,
    this.eligibilityCriteria = const [],
    this.requiredDocuments = const [],
    this.approvedPharmacies = const [],
    this.applicationProcess = '',
    this.contactInfo = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'schemeId': schemeId,
      'schemeName': schemeName,
      'description': description,
      'subsidyAmount': subsidyAmount,
      'subsidyPercentage': subsidyPercentage,
      'isFullyCovered': isFullyCovered,
      'eligibilityCriteria': eligibilityCriteria,
      'requiredDocuments': requiredDocuments,
      'approvedPharmacies': approvedPharmacies,
      'applicationProcess': applicationProcess,
      'contactInfo': contactInfo,
    };
  }

  factory GovernmentSchemeEligibility.fromJson(Map<String, dynamic> json) {
    return GovernmentSchemeEligibility(
      schemeId: json['schemeId'],
      schemeName: json['schemeName'],
      description: json['description'],
      subsidyAmount: (json['subsidyAmount'] as num?)?.toDouble() ?? 0,
      subsidyPercentage: (json['subsidyPercentage'] as num?)?.toDouble() ?? 0,
      isFullyCovered: json['isFullyCovered'] ?? false,
      eligibilityCriteria: List<String>.from(json['eligibilityCriteria'] ?? []),
      requiredDocuments: List<String>.from(json['requiredDocuments'] ?? []),
      approvedPharmacies: List<String>.from(json['approvedPharmacies'] ?? []),
      applicationProcess: json['applicationProcess'] ?? '',
      contactInfo: json['contactInfo'] ?? '',
    );
  }
}
