class MedicineInventory {
  final String id;
  final String medicineName;
  final String brandName;
  final String genericName;
  final String manufacturer;
  final String strength;
  final String dosageForm;
  final int quantityInStock;
  final int minStockLevel;
  final double costPrice;
  final double sellingPrice;
  final String batchNumber;
  final DateTime manufacturingDate;
  final DateTime expiryDate;
  final DateTime lastUpdated;
  final String updatedBy;
  final bool requiresPrescription;
  final MedicineCategory category;
  final double rating;
  final int reviewCount;
  final String? rackLocation;
  final String? supplier;
  final List<String> alternativeBrands;
  final String status; // 'active', 'low_stock', 'expired', 'discontinued'

  MedicineInventory({
    required this.id,
    required this.medicineName,
    required this.brandName,
    required this.genericName,
    required this.manufacturer,
    required this.strength,
    required this.dosageForm,
    required this.quantityInStock,
    required this.minStockLevel,
    required this.costPrice,
    required this.sellingPrice,
    required this.batchNumber,
    required this.manufacturingDate,
    required this.expiryDate,
    required this.lastUpdated,
    required this.updatedBy,
    required this.requiresPrescription,
    required this.category,
    this.rating = 4.0,
    this.reviewCount = 0,
    this.rackLocation,
    this.supplier,
    this.alternativeBrands = const [],
    this.status = 'active',
  });

  // Computed properties
  bool get isLowStock => quantityInStock <= minStockLevel;
  bool get isExpiringSoon =>
      expiryDate.isBefore(DateTime.now().add(const Duration(days: 30)));
  bool get isExpired => expiryDate.isBefore(DateTime.now());
  double get profitMargin => ((sellingPrice - costPrice) / costPrice) * 100;
  String get formattedSellingPrice => '₹${sellingPrice.toStringAsFixed(2)}';
  String get formattedCostPrice => '₹${costPrice.toStringAsFixed(2)}';

  MedicineInventory copyWith({
    String? id,
    String? medicineName,
    String? brandName,
    String? genericName,
    String? manufacturer,
    String? strength,
    String? dosageForm,
    int? quantityInStock,
    int? minStockLevel,
    double? costPrice,
    double? sellingPrice,
    String? batchNumber,
    DateTime? manufacturingDate,
    DateTime? expiryDate,
    DateTime? lastUpdated,
    String? updatedBy,
    bool? requiresPrescription,
    MedicineCategory? category,
    double? rating,
    int? reviewCount,
    String? rackLocation,
    String? supplier,
    List<String>? alternativeBrands,
    String? status,
  }) {
    return MedicineInventory(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      brandName: brandName ?? this.brandName,
      genericName: genericName ?? this.genericName,
      manufacturer: manufacturer ?? this.manufacturer,
      strength: strength ?? this.strength,
      dosageForm: dosageForm ?? this.dosageForm,
      quantityInStock: quantityInStock ?? this.quantityInStock,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      batchNumber: batchNumber ?? this.batchNumber,
      manufacturingDate: manufacturingDate ?? this.manufacturingDate,
      expiryDate: expiryDate ?? this.expiryDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      updatedBy: updatedBy ?? this.updatedBy,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      rackLocation: rackLocation ?? this.rackLocation,
      supplier: supplier ?? this.supplier,
      alternativeBrands: alternativeBrands ?? this.alternativeBrands,
      status: status ?? this.status,
    );
  }

  factory MedicineInventory.fromJson(Map<String, dynamic> json) {
    return MedicineInventory(
      id: json['id'] ?? '',
      medicineName: json['medicineName'] ?? '',
      brandName: json['brandName'] ?? '',
      genericName: json['genericName'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      strength: json['strength'] ?? '',
      dosageForm: json['dosageForm'] ?? '',
      quantityInStock: json['quantityInStock'] ?? 0,
      minStockLevel: json['minStockLevel'] ?? 0,
      costPrice: (json['costPrice'] ?? 0).toDouble(),
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      batchNumber: json['batchNumber'] ?? '',
      manufacturingDate: DateTime.parse(
        json['manufacturingDate'] ?? DateTime.now().toIso8601String(),
      ),
      expiryDate: DateTime.parse(
        json['expiryDate'] ?? DateTime.now().toIso8601String(),
      ),
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
      updatedBy: json['updatedBy'] ?? '',
      requiresPrescription: json['requiresPrescription'] ?? false,
      category: MedicineCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => MedicineCategory.overTheCounter,
      ),
      rating: (json['rating'] ?? 4.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      rackLocation: json['rackLocation'],
      supplier: json['supplier'],
      alternativeBrands: List<String>.from(json['alternativeBrands'] ?? []),
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineName': medicineName,
      'brandName': brandName,
      'genericName': genericName,
      'manufacturer': manufacturer,
      'strength': strength,
      'dosageForm': dosageForm,
      'quantityInStock': quantityInStock,
      'minStockLevel': minStockLevel,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'batchNumber': batchNumber,
      'manufacturingDate': manufacturingDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'updatedBy': updatedBy,
      'requiresPrescription': requiresPrescription,
      'category': category.toString().split('.').last,
      'rating': rating,
      'reviewCount': reviewCount,
      'rackLocation': rackLocation,
      'supplier': supplier,
      'alternativeBrands': alternativeBrands,
      'status': status,
    };
  }
}

enum MedicineCategory {
  prescription,
  overTheCounter,
  supplement,
  ayurvedic,
  homeopathic,
  surgical,
  babycare,
  diabetic,
}

class InventoryStats {
  final int totalMedicines;
  final int lowStockItems;
  final int expiringSoonItems;
  final int expiredItems;
  final double totalInventoryValue;
  final double monthlyRevenue;
  final double averageRating;

  InventoryStats({
    required this.totalMedicines,
    required this.lowStockItems,
    required this.expiringSoonItems,
    required this.expiredItems,
    required this.totalInventoryValue,
    required this.monthlyRevenue,
    required this.averageRating,
  });
}
