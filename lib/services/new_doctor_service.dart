import '../config/api_config.dart';
import '../services/api_service.dart';
import '../models/doctor_model.dart';

/// Service for doctor-related API operations
class NewDoctorService {
  static final NewDoctorService _instance = NewDoctorService._internal();
  factory NewDoctorService() => _instance;
  NewDoctorService._internal();

  final ApiService _apiService = ApiService();

  /// Get all doctors with optional filters
  Future<DoctorsResponse> getAllDoctors({
    int page = 1,
    int limit = 10,
    String? speciality,
    String? city,
    String? state,
    bool? available,
    String? search,
    String sortBy = 'rating',
    String sortOrder = 'desc',
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        'sortBy': sortBy,
        'sortOrder': sortOrder,
        if (speciality != null) 'speciality': speciality,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (available != null) 'available': available.toString(),
        if (search != null) 'search': search,
      };

      final response = await _apiService.get(
        ApiConfig.doctorsList,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        return DoctorsResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception(response.error ?? 'Failed to fetch doctors');
      }
    } catch (e) {
      throw Exception('Error fetching doctors: ${e.toString()}');
    }
  }

  /// Get available doctors by speciality
  Future<List<DoctorModel>> getAvailableDoctors([String? speciality]) async {
    try {
      final endpoint = speciality != null
          ? ApiConfig.availableDoctorsBySpeciality(speciality)
          : ApiConfig.doctorsAvailable;

      final response = await _apiService.get(endpoint);

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final doctorsList = data['doctors'] as List;
        return doctorsList.map((json) => DoctorModel.fromJson(json)).toList();
      } else {
        throw Exception(response.error ?? 'Failed to fetch available doctors');
      }
    } catch (e) {
      throw Exception('Error fetching available doctors: ${e.toString()}');
    }
  }

  /// Get doctor by ID
  Future<DoctorModel> getDoctorById(String doctorId) async {
    try {
      final response = await _apiService.get(ApiConfig.doctorById(doctorId));

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return DoctorModel.fromJson(data['doctor']);
      } else {
        throw Exception(response.error ?? 'Doctor not found');
      }
    } catch (e) {
      throw Exception('Error fetching doctor: ${e.toString()}');
    }
  }

  /// Update doctor profile (for logged-in doctor)
  Future<DoctorModel> updateDoctorProfile({
    String? name,
    String? phone,
    double? consultationFee,
    int? consultationDuration,
    String? bio,
    List<String>? languages,
    Map<String, dynamic>? address,
    Map<String, dynamic>? workingHours,
    Map<String, dynamic>? notificationSettings,
    int? maxPatientsPerDay,
    bool? emergencyAvailable,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (consultationFee != null) body['consultationFee'] = consultationFee;
      if (consultationDuration != null)
        body['consultationDuration'] = consultationDuration;
      if (bio != null) body['bio'] = bio;
      if (languages != null) body['languages'] = languages;
      if (address != null) body['address'] = address;
      if (workingHours != null) body['workingHours'] = workingHours;
      if (notificationSettings != null)
        body['notificationSettings'] = notificationSettings;
      if (maxPatientsPerDay != null)
        body['maxPatientsPerDay'] = maxPatientsPerDay;
      if (emergencyAvailable != null)
        body['emergencyAvailable'] = emergencyAvailable;

      final response = await _apiService.put(
        ApiConfig.doctorsProfile,
        body: body,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return DoctorModel.fromJson(data['doctor']);
      } else {
        throw Exception(response.error ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Error updating profile: ${e.toString()}');
    }
  }

  /// Update doctor status
  Future<void> updateDoctorStatus(String status) async {
    try {
      final body = {'status': status};

      final response = await _apiService.put(
        ApiConfig.doctorsStatus,
        body: body,
      );

      if (!response.isSuccess) {
        throw Exception(response.error ?? 'Failed to update status');
      }
    } catch (e) {
      throw Exception('Error updating status: ${e.toString()}');
    }
  }

  /// Get doctor's consultations
  Future<ConsultationsResponse> getDoctorConsultations({
    String? status,
    String? date,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (date != null) 'date': date,
      };

      final response = await _apiService.get(
        ApiConfig.doctorsConsultations,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        return ConsultationsResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception(response.error ?? 'Failed to fetch consultations');
      }
    } catch (e) {
      throw Exception('Error fetching consultations: ${e.toString()}');
    }
  }

  /// Get today's schedule
  Future<DoctorScheduleResponse> getTodaySchedule() async {
    try {
      final response = await _apiService.get(ApiConfig.doctorsSchedule);

      if (response.isSuccess && response.data != null) {
        return DoctorScheduleResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception(response.error ?? 'Failed to fetch schedule');
      }
    } catch (e) {
      throw Exception('Error fetching schedule: ${e.toString()}');
    }
  }

  /// Get doctor dashboard statistics
  Future<DoctorStatsResponse> getDoctorStats() async {
    try {
      final response = await _apiService.get(ApiConfig.doctorsStats);

      if (response.isSuccess && response.data != null) {
        return DoctorStatsResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception(response.error ?? 'Failed to fetch statistics');
      }
    } catch (e) {
      throw Exception('Error fetching statistics: ${e.toString()}');
    }
  }
}

/// Response models for API calls
class DoctorsResponse {
  final List<DoctorModel> doctors;
  final PaginationInfo pagination;
  final Map<String, dynamic>? filters;

  DoctorsResponse({
    required this.doctors,
    required this.pagination,
    this.filters,
  });

  factory DoctorsResponse.fromJson(Map<String, dynamic> json) {
    return DoctorsResponse(
      doctors: (json['doctors'] as List)
          .map((doctor) => DoctorModel.fromJson(doctor))
          .toList(),
      pagination: PaginationInfo.fromJson(json['pagination']),
      filters: json['filters'],
    );
  }
}

class ConsultationsResponse {
  final List<dynamic> consultations; // TODO: Create ConsultationModel
  final PaginationInfo pagination;

  ConsultationsResponse({
    required this.consultations,
    required this.pagination,
  });

  factory ConsultationsResponse.fromJson(Map<String, dynamic> json) {
    return ConsultationsResponse(
      consultations: json['consultations'] as List,
      pagination: PaginationInfo.fromJson(json['pagination']),
    );
  }
}

class DoctorScheduleResponse {
  final List<dynamic> todayConsultations;
  final List<dynamic> queue;
  final Map<String, dynamic> stats;

  DoctorScheduleResponse({
    required this.todayConsultations,
    required this.queue,
    required this.stats,
  });

  factory DoctorScheduleResponse.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleResponse(
      todayConsultations: json['todayConsultations'] as List,
      queue: json['queue'] as List,
      stats: json['stats'] as Map<String, dynamic>,
    );
  }
}

class DoctorStatsResponse {
  final Map<String, dynamic> stats;

  DoctorStatsResponse({required this.stats});

  factory DoctorStatsResponse.fromJson(Map<String, dynamic> json) {
    return DoctorStatsResponse(stats: json['stats'] as Map<String, dynamic>);
  }
}

class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.hasNextPage = false,
    this.hasPrevPage = false,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems:
          json['totalDoctors'] ??
          json['totalConsultations'] ??
          json['total'] ??
          0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}
