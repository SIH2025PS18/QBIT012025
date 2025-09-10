// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineStock _$MedicineStockFromJson(Map<String, dynamic> json) =>
    MedicineStock(
      id: json['id'] as String,
      pharmacyId: json['pharmacyId'] as String,
      medicineName: json['medicineName'] as String,
      brandName: json['brandName'] as String?,
      genericName: json['genericName'] as String?,
      manufacturer: json['manufacturer'] as String?,
      batchNumber: json['batchNumber'] as String?,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      quantityAvailable: (json['quantityAvailable'] as num).toInt(),
      quantityReserved: (json['quantityReserved'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      category: $enumDecodeNullable(
        _$MedicineCategoryEnumMap,
        json['category'],
      ),
      dosageForm: json['dosageForm'] as String?,
      strength: json['strength'] as String?,
      requiresPrescription: json['requiresPrescription'] as bool? ?? false,
      pharmacyName: json['pharmacyName'] as String?,
      pharmacyAddress: json['pharmacyAddress'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MedicineStockToJson(MedicineStock instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pharmacyId': instance.pharmacyId,
      'medicineName': instance.medicineName,
      'brandName': instance.brandName,
      'genericName': instance.genericName,
      'manufacturer': instance.manufacturer,
      'batchNumber': instance.batchNumber,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'quantityAvailable': instance.quantityAvailable,
      'quantityReserved': instance.quantityReserved,
      'unitPrice': instance.unitPrice,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'category': _$MedicineCategoryEnumMap[instance.category],
      'dosageForm': instance.dosageForm,
      'strength': instance.strength,
      'requiresPrescription': instance.requiresPrescription,
      'pharmacyName': instance.pharmacyName,
      'pharmacyAddress': instance.pharmacyAddress,
      'distanceKm': instance.distanceKm,
    };

const _$MedicineCategoryEnumMap = {
  MedicineCategory.prescription: 'prescription',
  MedicineCategory.overTheCounter: 'over_the_counter',
  MedicineCategory.controlledSubstance: 'controlled_substance',
  MedicineCategory.supplement: 'supplement',
  MedicineCategory.medicalDevice: 'medical_device',
};

PriceComparison _$PriceComparisonFromJson(Map<String, dynamic> json) =>
    PriceComparison(
      medicineName: json['medicineName'] as String,
      genericName: json['genericName'] as String?,
      pharmacyPrices: (json['pharmacyPrices'] as List<dynamic>)
          .map((e) => PharmacyPrice.fromJson(e as Map<String, dynamic>))
          .toList(),
      lowestPrice: (json['lowestPrice'] as num).toDouble(),
      highestPrice: (json['highestPrice'] as num).toDouble(),
      averagePrice: (json['averagePrice'] as num).toDouble(),
      bestValuePharmacyId: json['bestValuePharmacyId'] as String?,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$PriceComparisonToJson(PriceComparison instance) =>
    <String, dynamic>{
      'medicineName': instance.medicineName,
      'genericName': instance.genericName,
      'pharmacyPrices': instance.pharmacyPrices,
      'lowestPrice': instance.lowestPrice,
      'highestPrice': instance.highestPrice,
      'averagePrice': instance.averagePrice,
      'bestValuePharmacyId': instance.bestValuePharmacyId,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

PharmacyPrice _$PharmacyPriceFromJson(Map<String, dynamic> json) =>
    PharmacyPrice(
      pharmacyId: json['pharmacyId'] as String,
      pharmacyName: json['pharmacyName'] as String,
      pharmacyAddress: json['pharmacyAddress'] as String?,
      price: (json['price'] as num).toDouble(),
      quantityAvailable: (json['quantityAvailable'] as num).toInt(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      isInStock: json['isInStock'] as bool? ?? true,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      batchNumber: json['batchNumber'] as String?,
      requiresReservation: json['requiresReservation'] as bool? ?? false,
    );

Map<String, dynamic> _$PharmacyPriceToJson(PharmacyPrice instance) =>
    <String, dynamic>{
      'pharmacyId': instance.pharmacyId,
      'pharmacyName': instance.pharmacyName,
      'pharmacyAddress': instance.pharmacyAddress,
      'price': instance.price,
      'quantityAvailable': instance.quantityAvailable,
      'distanceKm': instance.distanceKm,
      'isInStock': instance.isInStock,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'batchNumber': instance.batchNumber,
      'requiresReservation': instance.requiresReservation,
    };

MedicineReservation _$MedicineReservationFromJson(Map<String, dynamic> json) =>
    MedicineReservation(
      id: json['id'] as String,
      pharmacyId: json['pharmacyId'] as String,
      medicineId: json['medicineId'] as String,
      patientId: json['patientId'] as String,
      quantityReserved: (json['quantityReserved'] as num).toInt(),
      reservationExpiresAt: DateTime.parse(
        json['reservationExpiresAt'] as String,
      ),
      status:
          $enumDecodeNullable(_$ReservationStatusEnumMap, json['status']) ??
          ReservationStatus.reserved,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      reservationCode: json['reservationCode'] as String?,
    );

Map<String, dynamic> _$MedicineReservationToJson(
  MedicineReservation instance,
) => <String, dynamic>{
  'id': instance.id,
  'pharmacyId': instance.pharmacyId,
  'medicineId': instance.medicineId,
  'patientId': instance.patientId,
  'quantityReserved': instance.quantityReserved,
  'reservationExpiresAt': instance.reservationExpiresAt.toIso8601String(),
  'status': _$ReservationStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'totalAmount': instance.totalAmount,
  'reservationCode': instance.reservationCode,
};

const _$ReservationStatusEnumMap = {
  ReservationStatus.reserved: 'reserved',
  ReservationStatus.confirmed: 'confirmed',
  ReservationStatus.collected: 'collected',
  ReservationStatus.cancelled: 'cancelled',
  ReservationStatus.expired: 'expired',
};
