// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pharmacy _$PharmacyFromJson(Map<String, dynamic> json) => Pharmacy(
  id: json['id'] as String,
  name: json['name'] as String,
  licenseNumber: json['licenseNumber'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  email: json['email'] as String?,
  address: json['address'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  pincode: json['pincode'] as String,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  workingHours: json['workingHours'] as Map<String, dynamic>?,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
  rating: json['rating'] == null
      ? null
      : PharmacyRating.fromJson(json['rating'] as Map<String, dynamic>),
  specialities: (json['specialities'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  distanceKm: (json['distanceKm'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PharmacyToJson(Pharmacy instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'licenseNumber': instance.licenseNumber,
  'phoneNumber': instance.phoneNumber,
  'email': instance.email,
  'address': instance.address,
  'city': instance.city,
  'state': instance.state,
  'pincode': instance.pincode,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'workingHours': instance.workingHours,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'rating': instance.rating,
  'specialities': instance.specialities,
  'distanceKm': instance.distanceKm,
};

PharmacyRating _$PharmacyRatingFromJson(Map<String, dynamic> json) =>
    PharmacyRating(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      categoryRatings: (json['categoryRatings'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      recentReviews: (json['recentReviews'] as List<dynamic>?)
          ?.map((e) => PharmacyReview.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PharmacyRatingToJson(PharmacyRating instance) =>
    <String, dynamic>{
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'categoryRatings': instance.categoryRatings,
      'recentReviews': instance.recentReviews,
    };

PharmacyReview _$PharmacyReviewFromJson(Map<String, dynamic> json) =>
    PharmacyReview(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String?,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      categoryRatings: (json['categoryRatings'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$PharmacyReviewToJson(PharmacyReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'patientName': instance.patientName,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'categoryRatings': instance.categoryRatings,
    };
