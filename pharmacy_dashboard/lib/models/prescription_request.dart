class PrescriptionRequest {
  final String id;
  final String patientId;
  final String patientName;
  final String patientPhone;
  final String doctorName;
  final List<Medicine> medicines;
  final DateTime requestedAt;
  final String
  status; // 'pending', 'accepted', 'partially_available', 'rejected', 'expired'
  final DateTime? responseDeadline;
  final String? pharmacyResponse;
  final String? notes;
  final double? estimatedCost;
  final String? patientLocation;
  final double? distanceFromPharmacy;
  final String? preferredLanguage; // 'en', 'hi', 'regional'
  final Map<String, String>?
  multiLanguageResponses; // Suggested responses in multiple languages

  PrescriptionRequest({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    required this.doctorName,
    required this.medicines,
    required this.requestedAt,
    required this.status,
    this.responseDeadline,
    this.pharmacyResponse,
    this.notes,
    this.estimatedCost,
    this.patientLocation,
    this.distanceFromPharmacy,
    this.preferredLanguage = 'en',
    this.multiLanguageResponses,
  });

  factory PrescriptionRequest.fromJson(Map<String, dynamic> json) {
    return PrescriptionRequest(
      id: json['id'] ?? json['_id'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      patientPhone: json['patientPhone'] ?? '',
      doctorName: json['doctorName'] ?? '',
      medicines:
          (json['medicines'] as List?)
              ?.map((m) => Medicine.fromJson(m))
              .toList() ??
          [],
      requestedAt: DateTime.parse(
        json['requestedAt'] ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] ?? 'pending',
      responseDeadline: json['responseDeadline'] != null
          ? DateTime.parse(json['responseDeadline'])
          : null,
      pharmacyResponse: json['pharmacyResponse'],
      notes: json['notes'],
      estimatedCost: json['estimatedCost']?.toDouble(),
      patientLocation: json['patientLocation'],
      distanceFromPharmacy: json['distanceFromPharmacy']?.toDouble(),
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      multiLanguageResponses: json['multiLanguageResponses'] != null
          ? Map<String, String>.from(json['multiLanguageResponses'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'patientPhone': patientPhone,
      'doctorName': doctorName,
      'medicines': medicines.map((m) => m.toJson()).toList(),
      'requestedAt': requestedAt.toIso8601String(),
      'status': status,
      'responseDeadline': responseDeadline?.toIso8601String(),
      'pharmacyResponse': pharmacyResponse,
      'notes': notes,
      'estimatedCost': estimatedCost,
      'patientLocation': patientLocation,
      'distanceFromPharmacy': distanceFromPharmacy,
      'preferredLanguage': preferredLanguage,
      'multiLanguageResponses': multiLanguageResponses,
    };
  }

  bool get isExpired {
    if (responseDeadline == null) return false;
    return DateTime.now().isAfter(responseDeadline!);
  }

  Duration get timeRemaining {
    if (responseDeadline == null) return Duration.zero;
    final remaining = responseDeadline!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  PrescriptionRequest copyWith({
    String? status,
    String? pharmacyResponse,
    String? notes,
    double? estimatedCost,
    String? preferredLanguage,
    Map<String, String>? multiLanguageResponses,
  }) {
    return PrescriptionRequest(
      id: id,
      patientId: patientId,
      patientName: patientName,
      patientPhone: patientPhone,
      doctorName: doctorName,
      medicines: medicines,
      requestedAt: requestedAt,
      status: status ?? this.status,
      responseDeadline: responseDeadline,
      pharmacyResponse: pharmacyResponse ?? this.pharmacyResponse,
      notes: notes ?? this.notes,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      patientLocation: patientLocation,
      distanceFromPharmacy: distanceFromPharmacy,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      multiLanguageResponses:
          multiLanguageResponses ?? this.multiLanguageResponses,
    );
  }
}

class Medicine {
  final String name;
  final String? brand;
  final String dosage;
  final int quantity;
  final String? instructions;
  final bool? isAvailable;
  final double? price;
  final String? alternativeOptions;

  Medicine({
    required this.name,
    this.brand,
    required this.dosage,
    required this.quantity,
    this.instructions,
    this.isAvailable,
    this.price,
    this.alternativeOptions,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'] ?? '',
      brand: json['brand'],
      dosage: json['dosage'] ?? '',
      quantity: json['quantity'] ?? 1,
      instructions: json['instructions'],
      isAvailable: json['isAvailable'],
      price: json['price']?.toDouble(),
      alternativeOptions: json['alternativeOptions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'dosage': dosage,
      'quantity': quantity,
      'instructions': instructions,
      'isAvailable': isAvailable,
      'price': price,
      'alternativeOptions': alternativeOptions,
    };
  }

  Medicine copyWith({
    bool? isAvailable,
    double? price,
    String? alternativeOptions,
  }) {
    return Medicine(
      name: name,
      brand: brand,
      dosage: dosage,
      quantity: quantity,
      instructions: instructions,
      isAvailable: isAvailable ?? this.isAvailable,
      price: price ?? this.price,
      alternativeOptions: alternativeOptions ?? this.alternativeOptions,
    );
  }
}
