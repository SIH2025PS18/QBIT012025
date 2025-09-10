import 'package:json_annotation/json_annotation.dart';

part 'medicine_stock.g.dart';

/// Medicine stock information from pharmacy inventory
@JsonSerializable()
class MedicineStock {
  final String id;
  final String pharmacyId;
  final String medicineName;
  final String? brandName;
  final String? genericName;
  final String? manufacturer;
  final String? batchNumber;
  final DateTime? expiryDate;
  final int quantityAvailable;
  final int quantityReserved;
  final double unitPrice;
  final DateTime lastUpdated;
  final MedicineCategory? category;
  final String? dosageForm; // tablet, capsule, syrup, injection
  final String? strength; // 500mg, 10ml, etc.
  final bool requiresPrescription;
  final String? pharmacyName;
  final String? pharmacyAddress;
  final double? distanceKm;

  const MedicineStock({
    required this.id,
    required this.pharmacyId,
    required this.medicineName,
    this.brandName,
    this.genericName,
    this.manufacturer,
    this.batchNumber,
    this.expiryDate,
    required this.quantityAvailable,
    this.quantityReserved = 0,
    required this.unitPrice,
    required this.lastUpdated,
    this.category,
    this.dosageForm,
    this.strength,
    this.requiresPrescription = false,
    this.pharmacyName,
    this.pharmacyAddress,
    this.distanceKm,
  });

  factory MedicineStock.fromJson(Map<String, dynamic> json) =>
      _$MedicineStockFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineStockToJson(this);

  /// Get display name for medicine
  String get displayName {
    if (brandName != null && brandName!.isNotEmpty) {
      return brandName!;
    }
    return medicineName;
  }

  /// Get complete medicine information
  String get fullMedicineInfo {
    final parts = <String>[displayName];

    if (strength != null) parts.add('($strength)');
    if (dosageForm != null) parts.add('- $dosageForm');
    if (manufacturer != null) parts.add('by $manufacturer');

    return parts.join(' ');
  }

  /// Check if medicine is in stock
  bool get isInStock => quantityAvailable > quantityReserved;

  /// Get available quantity (excluding reserved)
  int get availableQuantity => quantityAvailable - quantityReserved;

  /// Check if medicine is expiring soon (within 30 days)
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry >= 0;
  }

  /// Check if medicine is expired
  bool get isExpired {
    if (expiryDate == null) return false;
    return expiryDate!.isBefore(DateTime.now());
  }

  /// Get stock status for display
  StockStatus get stockStatus {
    if (isExpired) return StockStatus.expired;
    if (!isInStock) return StockStatus.outOfStock;
    if (availableQuantity <= 5) return StockStatus.lowStock;
    if (isExpiringSoon) return StockStatus.expiringSoon;
    return StockStatus.inStock;
  }

  /// Get formatted price
  String get formattedPrice => '₹${unitPrice.toStringAsFixed(2)}';

  /// Get expiry date formatted string
  String get formattedExpiryDate {
    if (expiryDate == null) return 'No expiry info';
    return '${expiryDate!.day}/${expiryDate!.month}/${expiryDate!.year}';
  }

  MedicineStock copyWith({
    String? id,
    String? pharmacyId,
    String? medicineName,
    String? brandName,
    String? genericName,
    String? manufacturer,
    String? batchNumber,
    DateTime? expiryDate,
    int? quantityAvailable,
    int? quantityReserved,
    double? unitPrice,
    DateTime? lastUpdated,
    MedicineCategory? category,
    String? dosageForm,
    String? strength,
    bool? requiresPrescription,
    String? pharmacyName,
    String? pharmacyAddress,
    double? distanceKm,
  }) {
    return MedicineStock(
      id: id ?? this.id,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      medicineName: medicineName ?? this.medicineName,
      brandName: brandName ?? this.brandName,
      genericName: genericName ?? this.genericName,
      manufacturer: manufacturer ?? this.manufacturer,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      quantityReserved: quantityReserved ?? this.quantityReserved,
      unitPrice: unitPrice ?? this.unitPrice,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      category: category ?? this.category,
      dosageForm: dosageForm ?? this.dosageForm,
      strength: strength ?? this.strength,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      pharmacyAddress: pharmacyAddress ?? this.pharmacyAddress,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  @override
  String toString() =>
      'MedicineStock(name: $displayName, pharmacy: $pharmacyName)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineStock &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Price comparison data for a medicine across pharmacies
@JsonSerializable()
class PriceComparison {
  final String medicineName;
  final String? genericName;
  final List<PharmacyPrice> pharmacyPrices;
  final double lowestPrice;
  final double highestPrice;
  final double averagePrice;
  final String? bestValuePharmacyId;
  final DateTime lastUpdated;

  const PriceComparison({
    required this.medicineName,
    this.genericName,
    required this.pharmacyPrices,
    required this.lowestPrice,
    required this.highestPrice,
    required this.averagePrice,
    this.bestValuePharmacyId,
    required this.lastUpdated,
  });

  factory PriceComparison.fromJson(Map<String, dynamic> json) =>
      _$PriceComparisonFromJson(json);

  Map<String, dynamic> toJson() => _$PriceComparisonToJson(this);

  /// Get price savings compared to highest price
  double get maxSavings => highestPrice - lowestPrice;

  /// Get price savings percentage
  double get savingsPercentage => highestPrice > 0
      ? ((highestPrice - lowestPrice) / highestPrice) * 100
      : 0;

  /// Sort pharmacies by price (lowest first)
  List<PharmacyPrice> get sortedByPrice =>
      List<PharmacyPrice>.from(pharmacyPrices)
        ..sort((a, b) => a.price.compareTo(b.price));

  /// Sort pharmacies by distance (nearest first)
  List<PharmacyPrice> get sortedByDistance =>
      List<PharmacyPrice>.from(pharmacyPrices)
        ..sort((a, b) => (a.distanceKm ?? double.infinity)
            .compareTo(b.distanceKm ?? double.infinity));
}

/// Individual pharmacy price information
@JsonSerializable()
class PharmacyPrice {
  final String pharmacyId;
  final String pharmacyName;
  final String? pharmacyAddress;
  final double price;
  final int quantityAvailable;
  final double? distanceKm;
  final bool isInStock;
  final DateTime? expiryDate;
  final String? batchNumber;
  final bool requiresReservation;

  const PharmacyPrice({
    required this.pharmacyId,
    required this.pharmacyName,
    this.pharmacyAddress,
    required this.price,
    required this.quantityAvailable,
    this.distanceKm,
    this.isInStock = true,
    this.expiryDate,
    this.batchNumber,
    this.requiresReservation = false,
  });

  factory PharmacyPrice.fromJson(Map<String, dynamic> json) =>
      _$PharmacyPriceFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyPriceToJson(this);

  /// Get formatted price
  String get formattedPrice => '₹${price.toStringAsFixed(2)}';

  /// Get formatted distance
  String get formattedDistance {
    if (distanceKm == null) return 'Distance unknown';
    if (distanceKm! < 1) return '${(distanceKm! * 1000).round()}m';
    return '${distanceKm!.toStringAsFixed(1)}km';
  }
}

/// Medicine reservation information
@JsonSerializable()
class MedicineReservation {
  final String id;
  final String pharmacyId;
  final String medicineId;
  final String patientId;
  final int quantityReserved;
  final DateTime reservationExpiresAt;
  final ReservationStatus status;
  final DateTime createdAt;
  final double? totalAmount;
  final String? reservationCode;

  const MedicineReservation({
    required this.id,
    required this.pharmacyId,
    required this.medicineId,
    required this.patientId,
    required this.quantityReserved,
    required this.reservationExpiresAt,
    this.status = ReservationStatus.reserved,
    required this.createdAt,
    this.totalAmount,
    this.reservationCode,
  });

  factory MedicineReservation.fromJson(Map<String, dynamic> json) =>
      _$MedicineReservationFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineReservationToJson(this);

  /// Check if reservation is still valid
  bool get isValid =>
      status == ReservationStatus.reserved &&
      reservationExpiresAt.isAfter(DateTime.now());

  /// Get time remaining for reservation
  Duration get timeRemaining => reservationExpiresAt.difference(DateTime.now());

  /// Get formatted time remaining
  String get formattedTimeRemaining {
    final remaining = timeRemaining;
    if (remaining.isNegative) return 'Expired';

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;

    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}

/// Stock status enumeration
enum StockStatus {
  @JsonValue('in_stock')
  inStock,
  @JsonValue('low_stock')
  lowStock,
  @JsonValue('out_of_stock')
  outOfStock,
  @JsonValue('expiring_soon')
  expiringSoon,
  @JsonValue('expired')
  expired,
}

/// Reservation status enumeration
enum ReservationStatus {
  @JsonValue('reserved')
  reserved,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('collected')
  collected,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('expired')
  expired,
}

/// Medicine category enumeration
enum MedicineCategory {
  @JsonValue('prescription')
  prescription,
  @JsonValue('over_the_counter')
  overTheCounter,
  @JsonValue('controlled_substance')
  controlledSubstance,
  @JsonValue('supplement')
  supplement,
  @JsonValue('medical_device')
  medicalDevice,
}
