import 'package:flutter/material.dart';

class Department {
  final String id;
  final String name;
  final String description;
  final String headOfDepartment;
  final String headDoctorId;
  final int totalDoctors;
  final int totalPatients;
  final List<String> services;
  final String location;
  final String contactNumber;
  final String email;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;
  final List<String> specializations;
  final Map<String, String> operatingHours;

  Department({
    required this.id,
    required this.name,
    required this.description,
    required this.headOfDepartment,
    required this.headDoctorId,
    this.totalDoctors = 0,
    this.totalPatients = 0,
    this.services = const [],
    required this.location,
    required this.contactNumber,
    required this.email,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.specializations = const [],
    this.operatingHours = const {},
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      headOfDepartment: json['headOfDepartment'] ?? '',
      headDoctorId: json['headDoctorId'] ?? '',
      totalDoctors: json['totalDoctors'] ?? 0,
      totalPatients: json['totalPatients'] ?? 0,
      services:
          json['services'] != null ? List<String>.from(json['services']) : [],
      location: json['location'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      imageUrl: json['imageUrl'],
      specializations: json['specializations'] != null
          ? List<String>.from(json['specializations'])
          : [],
      operatingHours: json['operatingHours'] != null
          ? Map<String, String>.from(json['operatingHours'])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'headOfDepartment': headOfDepartment,
      'headDoctorId': headDoctorId,
      'totalDoctors': totalDoctors,
      'totalPatients': totalPatients,
      'services': services,
      'location': location,
      'contactNumber': contactNumber,
      'email': email,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'imageUrl': imageUrl,
      'specializations': specializations,
      'operatingHours': operatingHours,
    };
  }

  Department copyWith({
    String? id,
    String? name,
    String? description,
    String? headOfDepartment,
    String? headDoctorId,
    int? totalDoctors,
    int? totalPatients,
    List<String>? services,
    String? location,
    String? contactNumber,
    String? email,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
    List<String>? specializations,
    Map<String, String>? operatingHours,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      headOfDepartment: headOfDepartment ?? this.headOfDepartment,
      headDoctorId: headDoctorId ?? this.headDoctorId,
      totalDoctors: totalDoctors ?? this.totalDoctors,
      totalPatients: totalPatients ?? this.totalPatients,
      services: services ?? this.services,
      location: location ?? this.location,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      specializations: specializations ?? this.specializations,
      operatingHours: operatingHours ?? this.operatingHours,
    );
  }

  IconData get departmentIcon {
    switch (name.toLowerCase()) {
      case 'cardiology':
        return Icons.favorite;
      case 'neurology':
        return Icons.psychology;
      case 'orthopedics':
        return Icons.accessibility;
      case 'pediatrics':
        return Icons.child_care;
      case 'dermatology':
        return Icons.face;
      case 'oncology':
        return Icons.medical_services;
      case 'radiology':
        return Icons.science;
      case 'emergency':
        return Icons.emergency;
      case 'surgery':
        return Icons.local_hospital;
      case 'gynecology':
        return Icons.pregnant_woman;
      case 'psychiatry':
        return Icons.psychology_alt;
      case 'ophthalmology':
        return Icons.visibility;
      case 'dentistry':
        return Icons.emoji_emotions;
      case 'general medicine':
        return Icons.local_hospital;
      default:
        return Icons.medical_services;
    }
  }

  Color get departmentColor {
    switch (name.toLowerCase()) {
      case 'cardiology':
        return Colors.red;
      case 'neurology':
        return Colors.purple;
      case 'orthopedics':
        return Colors.blue;
      case 'pediatrics':
        return Colors.orange;
      case 'dermatology':
        return Colors.pink;
      case 'oncology':
        return Colors.indigo;
      case 'radiology':
        return Colors.teal;
      case 'emergency':
        return Colors.red;
      case 'surgery':
        return Colors.green;
      case 'gynecology':
        return Colors.purple;
      case 'psychiatry':
        return Colors.cyan;
      case 'ophthalmology':
        return Colors.amber;
      case 'dentistry':
        return Colors.lime;
      case 'general medicine':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String get statusText {
    return isActive ? 'Active' : 'Inactive';
  }

  Color get statusColor {
    return isActive ? Colors.green : Colors.red;
  }
}
