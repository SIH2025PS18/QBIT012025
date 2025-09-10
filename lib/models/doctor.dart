import 'dart:ui';

class Doctor {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String specialization;
  final String qualification;
  final int experienceYears;
  final double consultationFee;
  final List<String> languages;
  final Map<String, dynamic> availability; // JSON data
  final double rating;
  final int totalConsultations;
  final bool isAvailable;
  final bool isOnline;
  final DateTime createdAt;
  final DateTime updatedAt;

  Doctor({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber = '',
    required this.specialization,
    this.qualification = '',
    this.experienceYears = 0,
    this.consultationFee = 0.0,
    this.languages = const ['Hindi', 'English'],
    this.availability = const {},
    this.rating = 0.0,
    this.totalConsultations = 0,
    this.isAvailable = true,
    this.isOnline = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map for Database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'specialization': specialization,
      'qualification': qualification,
      'experience_years': experienceYears,
      'consultation_fee': consultationFee,
      'languages': languages,
      'availability': availability,
      'rating': rating,
      'total_consultations': totalConsultations,
      'is_available': isAvailable,
      'is_online': isOnline,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create from Map (Database data)
  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] ?? '',
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      specialization: map['specialization'] ?? '',
      qualification: map['qualification'] ?? '',
      experienceYears: map['experience_years'] ?? 0,
      consultationFee: (map['consultation_fee'] ?? 0.0).toDouble(),
      languages: List<String>.from(map['languages'] ?? ['Hindi', 'English']),
      availability: Map<String, dynamic>.from(map['availability'] ?? {}),
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalConsultations: map['total_consultations'] ?? 0,
      isAvailable: map['is_available'] ?? true,
      isOnline: map['is_online'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  // Copy with method for updates
  Doctor copyWith({
    String? fullName,
    String? phoneNumber,
    String? specialization,
    String? qualification,
    int? experienceYears,
    double? consultationFee,
    List<String>? languages,
    Map<String, dynamic>? availability,
    double? rating,
    int? totalConsultations,
    bool? isAvailable,
    bool? isOnline,
  }) {
    return Doctor(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      specialization: specialization ?? this.specialization,
      qualification: qualification ?? this.qualification,
      experienceYears: experienceYears ?? this.experienceYears,
      consultationFee: consultationFee ?? this.consultationFee,
      languages: languages ?? this.languages,
      availability: availability ?? this.availability,
      rating: rating ?? this.rating,
      totalConsultations: totalConsultations ?? this.totalConsultations,
      isAvailable: isAvailable ?? this.isAvailable,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Computed properties
  String get experienceText {
    if (experienceYears <= 0) return 'New doctor';
    if (experienceYears == 1) return '1 year experience';
    return '$experienceYears years experience';
  }

  String get ratingText {
    if (totalConsultations == 0) return 'New doctor';
    return '${rating.toStringAsFixed(1)} ★ ($totalConsultations reviews)';
  }

  String get consultationFeeText {
    if (consultationFee <= 0) return 'Free consultation';
    return '₹${consultationFee.toStringAsFixed(0)}';
  }

  String get availabilityStatus {
    if (!isAvailable) return 'Unavailable';
    if (isOnline) return 'Online now';
    return 'Available';
  }

  Color get statusColor {
    if (!isAvailable) return const Color(0xFFE53E3E);
    if (isOnline) return const Color(0xFF38A169);
    return const Color(0xFFD69E2E);
  }
}
