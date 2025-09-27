class Pharmacy {
  final String id;
  final String name;
  final String licenseNumber;
  final String ownerName;
  final String email;
  final String phone;
  final PharmacyAddress address;
  final bool isActive;
  final bool isVerified;
  final PharmacyTimings timings;
  final List<String> services;
  final double rating;
  final int totalOrders;
  final DateTime registeredAt;
  final String? profileImage;

  Pharmacy({
    required this.id,
    required this.name,
    required this.licenseNumber,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.address,
    this.isActive = true,
    this.isVerified = false,
    required this.timings,
    this.services = const [],
    this.rating = 0.0,
    this.totalOrders = 0,
    required this.registeredAt,
    this.profileImage,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      ownerName: json['ownerName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: PharmacyAddress.fromJson(json['address'] ?? {}),
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      timings: PharmacyTimings.fromJson(json['timings'] ?? {}),
      services: List<String>.from(json['services'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalOrders: json['totalOrders'] ?? 0,
      registeredAt: DateTime.parse(
        json['registeredAt'] ?? DateTime.now().toIso8601String(),
      ),
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'licenseNumber': licenseNumber,
      'ownerName': ownerName,
      'email': email,
      'phone': phone,
      'address': address.toJson(),
      'isActive': isActive,
      'isVerified': isVerified,
      'timings': timings.toJson(),
      'services': services,
      'rating': rating,
      'totalOrders': totalOrders,
      'registeredAt': registeredAt.toIso8601String(),
      'profileImage': profileImage,
    };
  }
}

class PharmacyAddress {
  final String street;
  final String area;
  final String city;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;
  final String? landmark;

  PharmacyAddress({
    required this.street,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    this.landmark,
  });

  factory PharmacyAddress.fromJson(Map<String, dynamic> json) {
    return PharmacyAddress(
      street: json['street'] ?? '',
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      landmark: json['landmark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'area': area,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'landmark': landmark,
    };
  }
}

class PharmacyTimings {
  final String openTime;
  final String closeTime;
  final List<String> workingDays;
  final bool is24Hours;

  PharmacyTimings({
    required this.openTime,
    required this.closeTime,
    required this.workingDays,
    this.is24Hours = false,
  });

  factory PharmacyTimings.fromJson(Map<String, dynamic> json) {
    return PharmacyTimings(
      openTime: json['openTime'] ?? '09:00',
      closeTime: json['closeTime'] ?? '21:00',
      workingDays: List<String>.from(
        json['workingDays'] ??
            [
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
              'Saturday',
            ],
      ),
      is24Hours: json['is24Hours'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openTime': openTime,
      'closeTime': closeTime,
      'workingDays': workingDays,
      'is24Hours': is24Hours,
    };
  }

  bool get isOpenNow {
    if (is24Hours) return true;

    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);

    if (!workingDays.contains(dayName)) return false;

    final currentTime = TimeOfDay.fromDateTime(now);
    final openTime = _parseTime(this.openTime);
    final closeTime = _parseTime(this.closeTime);

    return _isTimeBetween(currentTime, openTime, closeTime);
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  bool _isTimeBetween(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (startMinutes <= endMinutes) {
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      // Handles cases where closing time is past midnight
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }
}

class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute});

  factory TimeOfDay.fromDateTime(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
}
