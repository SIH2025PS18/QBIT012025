/// Doctor model matching the telemedicine backend structure
class DoctorModel {
  final String id;
  final String doctorId;
  final String name;
  final String email;
  final String phone;
  final String speciality;
  final String qualification;
  final int experience;
  final String licenseNumber;
  final double consultationFee;
  final int consultationDuration;

  // Status and availability
  final String status; // 'online', 'offline', 'busy', 'break'
  final bool isAvailable;
  final bool isActive;
  final bool isVerified;
  final DateTime? verificationDate;

  // Address
  final AddressModel? address;

  // Working hours
  final Map<String, WorkingDay>? workingHours;

  // Rating and reviews
  final RatingModel rating;

  // Statistics
  final int totalConsultations;
  final int completedConsultations;
  final int cancelledConsultations;

  // Profile details
  final String? profileImage;
  final String? bio;
  final List<String> languages;

  // Consultation preferences
  final int maxPatientsPerDay;
  final String preferredLanguage;
  final bool emergencyAvailable;

  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;

  DoctorModel({
    required this.id,
    required this.doctorId,
    required this.name,
    required this.email,
    required this.phone,
    required this.speciality,
    required this.qualification,
    required this.experience,
    required this.licenseNumber,
    required this.consultationFee,
    this.consultationDuration = 30,
    this.status = 'offline',
    this.isAvailable = false,
    this.isActive = true,
    this.isVerified = false,
    this.verificationDate,
    this.address,
    this.workingHours,
    required this.rating,
    this.totalConsultations = 0,
    this.completedConsultations = 0,
    this.cancelledConsultations = 0,
    this.profileImage,
    this.bio,
    this.languages = const ['Hindi', 'English'],
    this.maxPatientsPerDay = 50,
    this.preferredLanguage = 'Hindi',
    this.emergencyAvailable = false,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'] ?? json['id'] ?? '',
      doctorId: json['doctorId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      speciality: json['speciality'] ?? '',
      qualification: json['qualification'] ?? '',
      experience: json['experience'] ?? 0,
      licenseNumber: json['licenseNumber'] ?? '',
      consultationFee: (json['consultationFee'] ?? 0).toDouble(),
      consultationDuration: json['consultationDuration'] ?? 30,
      status: json['status'] ?? 'offline',
      isAvailable: json['isAvailable'] ?? false,
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      verificationDate: json['verificationDate'] != null
          ? DateTime.parse(json['verificationDate'])
          : null,
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
      workingHours: json['workingHours'] != null
          ? (json['workingHours'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, WorkingDay.fromJson(value)),
            )
          : null,
      rating: RatingModel.fromJson(json['rating'] ?? {}),
      totalConsultations: json['totalConsultations'] ?? 0,
      completedConsultations: json['completedConsultations'] ?? 0,
      cancelledConsultations: json['cancelledConsultations'] ?? 0,
      profileImage: json['profileImage'],
      bio: json['bio'],
      languages: List<String>.from(json['languages'] ?? ['Hindi', 'English']),
      maxPatientsPerDay: json['maxPatientsPerDay'] ?? 50,
      preferredLanguage: json['preferredLanguage'] ?? 'Hindi',
      emergencyAvailable: json['emergencyAvailable'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'name': name,
      'email': email,
      'phone': phone,
      'speciality': speciality,
      'qualification': qualification,
      'experience': experience,
      'licenseNumber': licenseNumber,
      'consultationFee': consultationFee,
      'consultationDuration': consultationDuration,
      'status': status,
      'isAvailable': isAvailable,
      'isActive': isActive,
      'isVerified': isVerified,
      'verificationDate': verificationDate?.toIso8601String(),
      'address': address?.toJson(),
      'workingHours': workingHours?.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'rating': rating.toJson(),
      'totalConsultations': totalConsultations,
      'completedConsultations': completedConsultations,
      'cancelledConsultations': cancelledConsultations,
      'profileImage': profileImage,
      'bio': bio,
      'languages': languages,
      'maxPatientsPerDay': maxPatientsPerDay,
      'preferredLanguage': preferredLanguage,
      'emergencyAvailable': emergencyAvailable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  // Helper methods
  bool get isOnline => status == 'online';
  bool get isBusy => status == 'busy';
  bool get canAcceptPatients => isAvailable && isVerified && isActive;

  double get completionRate {
    if (totalConsultations == 0) return 0.0;
    return (completedConsultations / totalConsultations) * 100;
  }

  String get displayName => 'Dr. $name';
  String get specialityDisplay => '$speciality • ${experience}y exp';
  String get statusDisplay {
    switch (status) {
      case 'online':
        return 'Available';
      case 'busy':
        return 'In Consultation';
      case 'break':
        return 'On Break';
      case 'offline':
      default:
        return 'Offline';
    }
  }

  DoctorModel copyWith({
    String? id,
    String? doctorId,
    String? name,
    String? email,
    String? phone,
    String? speciality,
    String? qualification,
    int? experience,
    String? licenseNumber,
    double? consultationFee,
    int? consultationDuration,
    String? status,
    bool? isAvailable,
    bool? isActive,
    bool? isVerified,
    DateTime? verificationDate,
    AddressModel? address,
    Map<String, WorkingDay>? workingHours,
    RatingModel? rating,
    int? totalConsultations,
    int? completedConsultations,
    int? cancelledConsultations,
    String? profileImage,
    String? bio,
    List<String>? languages,
    int? maxPatientsPerDay,
    String? preferredLanguage,
    bool? emergencyAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      speciality: speciality ?? this.speciality,
      qualification: qualification ?? this.qualification,
      experience: experience ?? this.experience,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      consultationFee: consultationFee ?? this.consultationFee,
      consultationDuration: consultationDuration ?? this.consultationDuration,
      status: status ?? this.status,
      isAvailable: isAvailable ?? this.isAvailable,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      verificationDate: verificationDate ?? this.verificationDate,
      address: address ?? this.address,
      workingHours: workingHours ?? this.workingHours,
      rating: rating ?? this.rating,
      totalConsultations: totalConsultations ?? this.totalConsultations,
      completedConsultations:
          completedConsultations ?? this.completedConsultations,
      cancelledConsultations:
          cancelledConsultations ?? this.cancelledConsultations,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      languages: languages ?? this.languages,
      maxPatientsPerDay: maxPatientsPerDay ?? this.maxPatientsPerDay,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      emergencyAvailable: emergencyAvailable ?? this.emergencyAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}

/// Address model
class AddressModel {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? village;
  final String? district;

  AddressModel({
    this.street,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.village,
    this.district,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
      village: json['village'],
      district: json['district'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'village': village,
      'district': district,
    };
  }

  String get fullAddress {
    final parts = [
      street,
      village,
      city,
      district,
      state,
      pincode,
    ].where((part) => part != null && part.isNotEmpty).toList();
    return parts.join(', ');
  }
}

/// Working day model
class WorkingDay {
  final String? start;
  final String? end;
  final bool available;

  WorkingDay({this.start, this.end, this.available = true});

  factory WorkingDay.fromJson(Map<String, dynamic> json) {
    return WorkingDay(
      start: json['start'],
      end: json['end'],
      available: json['available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'start': start, 'end': end, 'available': available};
  }
}

/// Rating model
class RatingModel {
  final double average;
  final int totalRatings;
  final List<ReviewModel> reviews;

  RatingModel({
    this.average = 0.0,
    this.totalRatings = 0,
    this.reviews = const [],
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: (json['average'] ?? 0).toDouble(),
      totalRatings: json['totalRatings'] ?? 0,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
                .map((review) => ReviewModel.fromJson(review))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'totalRatings': totalRatings,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }
}

/// Review model
class ReviewModel {
  final String? patientId;
  final int rating;
  final String? comment;
  final DateTime date;

  ReviewModel({
    this.patientId,
    required this.rating,
    this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      patientId: json['patientId'],
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}
