import 'package:json_annotation/json_annotation.dart';

part 'pharmacy.g.dart';

/// Pharmacy model for medicine finder integration
@JsonSerializable()
class Pharmacy {
  final String id;
  final String name;
  final String licenseNumber;
  final String? phoneNumber;
  final String? email;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? workingHours;
  final bool isActive;
  final DateTime createdAt;
  final PharmacyRating? rating;
  final List<String>? specialities;
  final double? distanceKm; // Calculated field for nearby searches

  const Pharmacy({
    required this.id,
    required this.name,
    required this.licenseNumber,
    this.phoneNumber,
    this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
    this.workingHours,
    this.isActive = true,
    required this.createdAt,
    this.rating,
    this.specialities,
    this.distanceKm,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) =>
      _$PharmacyFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyToJson(this);

  /// Get formatted address
  String get fullAddress => '$address, $city, $state - $pincode';

  /// Check if pharmacy is currently open
  bool get isCurrentlyOpen {
    if (workingHours == null) return true;

    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final todayHours = workingHours![dayName] as Map<String, dynamic>?;
    if (todayHours == null || todayHours['closed'] == true) return false;

    final openTime = todayHours['open'] as String?;
    final closeTime = todayHours['close'] as String?;

    if (openTime == null || closeTime == null) return true;

    return _isTimeInRange(currentTime, openTime, closeTime);
  }

  /// Get today's working hours
  String get todayHours {
    if (workingHours == null) return 'Hours not specified';

    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final todayHours = workingHours![dayName] as Map<String, dynamic>?;

    if (todayHours == null || todayHours['closed'] == true) {
      return 'Closed today';
    }

    final openTime = todayHours['open'] as String? ?? '09:00';
    final closeTime = todayHours['close'] as String? ?? '21:00';

    return '$openTime - $closeTime';
  }

  String _getDayName(int weekday) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    return days[weekday - 1];
  }

  bool _isTimeInRange(String currentTime, String openTime, String closeTime) {
    final current = _timeToMinutes(currentTime);
    final open = _timeToMinutes(openTime);
    final close = _timeToMinutes(closeTime);

    if (close < open) {
      // Overnight hours (e.g., 22:00 - 06:00)
      return current >= open || current <= close;
    } else {
      return current >= open && current <= close;
    }
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  Pharmacy copyWith({
    String? id,
    String? name,
    String? licenseNumber,
    String? phoneNumber,
    String? email,
    String? address,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    Map<String, dynamic>? workingHours,
    bool? isActive,
    DateTime? createdAt,
    PharmacyRating? rating,
    List<String>? specialities,
    double? distanceKm,
  }) {
    return Pharmacy(
      id: id ?? this.id,
      name: name ?? this.name,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      workingHours: workingHours ?? this.workingHours,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
      specialities: specialities ?? this.specialities,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  @override
  String toString() => 'Pharmacy(name: $name, city: $city)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pharmacy && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Pharmacy rating and review information
@JsonSerializable()
class PharmacyRating {
  final double averageRating;
  final int totalReviews;
  final Map<String, double>? categoryRatings; // service, pricing, availability
  final List<PharmacyReview>? recentReviews;

  const PharmacyRating({
    required this.averageRating,
    required this.totalReviews,
    this.categoryRatings,
    this.recentReviews,
  });

  factory PharmacyRating.fromJson(Map<String, dynamic> json) =>
      _$PharmacyRatingFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyRatingToJson(this);

  /// Get star rating display (1-5 stars)
  int get starRating => averageRating.round().clamp(1, 5);
}

/// Individual pharmacy review
@JsonSerializable()
class PharmacyReview {
  final String id;
  final String patientId;
  final String? patientName;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final Map<String, double>? categoryRatings;

  const PharmacyReview({
    required this.id,
    required this.patientId,
    this.patientName,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.categoryRatings,
  });

  factory PharmacyReview.fromJson(Map<String, dynamic> json) =>
      _$PharmacyReviewFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyReviewToJson(this);
}
