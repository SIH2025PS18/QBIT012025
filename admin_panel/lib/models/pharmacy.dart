class Pharmacy {
  final String id;
  final String name;
  final String ownerName;
  final String email;
  final String phone;
  final String licenseNumber;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;
  final List<String> services;
  final String operatingHours;
  final bool isVerified;
  final bool isActive;
  final DateTime registeredAt;
  final String? profileImage;
  final double rating;
  final int totalOrders;

  Pharmacy({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.licenseNumber,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    this.services = const [],
    required this.operatingHours,
    this.isVerified = false,
    this.isActive = true,
    required this.registeredAt,
    this.profileImage,
    this.rating = 0.0,
    this.totalOrders = 0,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      ownerName: json['ownerName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      services: List<String>.from(json['services'] ?? []),
      operatingHours: json['operatingHours'] ?? '9:00 AM - 9:00 PM',
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
      registeredAt: DateTime.parse(
          json['registeredAt'] ?? DateTime.now().toIso8601String()),
      profileImage: json['profileImage'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalOrders: json['totalOrders'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ownerName': ownerName,
      'email': email,
      'phone': phone,
      'licenseNumber': licenseNumber,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'services': services,
      'operatingHours': operatingHours,
      'isVerified': isVerified,
      'isActive': isActive,
      'registeredAt': registeredAt.toIso8601String(),
      'profileImage': profileImage,
      'rating': rating,
      'totalOrders': totalOrders,
    };
  }

  Pharmacy copyWith({
    String? name,
    String? ownerName,
    String? email,
    String? phone,
    String? licenseNumber,
    String? address,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    List<String>? services,
    String? operatingHours,
    bool? isVerified,
    bool? isActive,
    String? profileImage,
    double? rating,
    int? totalOrders,
  }) {
    return Pharmacy(
      id: id,
      name: name ?? this.name,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      services: services ?? this.services,
      operatingHours: operatingHours ?? this.operatingHours,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      registeredAt: registeredAt,
      profileImage: profileImage ?? this.profileImage,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
    );
  }

  @override
  String toString() {
    return 'Pharmacy(id: $id, name: $name, owner: $ownerName, verified: $isVerified)';
  }
}
