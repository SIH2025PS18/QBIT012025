class DashboardStats {
  final int totalDoctors;
  final int totalPatients;
  final int totalAppointments;
  final int activeAppointments;
  final int totalDepartments;
  final List<ChartData> appointmentsByMonth;
  final List<ChartData> doctorsBySpecialty;

  // Additional fields for backward compatibility
  final int? todayAppointments;
  final int? pendingAppointments;
  final int? completedAppointments;
  final int? cancelledAppointments;
  final double? revenue;
  final double? monthlyGrowth;
  final List<ChartData>? appointmentChart;
  final List<ChartData>? revenueChart;

  DashboardStats({
    required this.totalDoctors,
    required this.totalPatients,
    required this.totalAppointments,
    required this.activeAppointments,
    required this.totalDepartments,
    required this.appointmentsByMonth,
    required this.doctorsBySpecialty,
    this.todayAppointments,
    this.pendingAppointments,
    this.completedAppointments,
    this.cancelledAppointments,
    this.revenue,
    this.monthlyGrowth,
    this.appointmentChart,
    this.revenueChart,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalDoctors: json['totalDoctors'] ?? 0,
      totalPatients: json['totalPatients'] ?? 0,
      totalAppointments: json['totalAppointments'] ?? 0,
      activeAppointments: json['activeAppointments'] ?? 0,
      totalDepartments: json['totalDepartments'] ?? 0,
      appointmentsByMonth: (json['appointmentsByMonth'] as List<dynamic>?)
              ?.map((e) => ChartData.fromJson(e))
              .toList() ??
          [],
      doctorsBySpecialty: (json['doctorsBySpecialty'] as List<dynamic>?)
              ?.map((e) => ChartData.fromJson(e))
              .toList() ??
          [],
      todayAppointments: json['todayAppointments'],
      pendingAppointments: json['pendingAppointments'],
      completedAppointments: json['completedAppointments'],
      cancelledAppointments: json['cancelledAppointments'],
      revenue: (json['revenue'] as num?)?.toDouble(),
      monthlyGrowth: (json['monthlyGrowth'] as num?)?.toDouble(),
      appointmentChart: (json['appointmentChart'] as List<dynamic>?)
          ?.map((e) => ChartData.fromJson(e))
          .toList(),
      revenueChart: (json['revenueChart'] as List<dynamic>?)
          ?.map((e) => ChartData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDoctors': totalDoctors,
      'totalPatients': totalPatients,
      'totalAppointments': totalAppointments,
      'activeAppointments': activeAppointments,
      'totalDepartments': totalDepartments,
      'appointmentsByMonth':
          appointmentsByMonth.map((e) => e.toJson()).toList(),
      'doctorsBySpecialty': doctorsBySpecialty.map((e) => e.toJson()).toList(),
      'todayAppointments': todayAppointments,
      'pendingAppointments': pendingAppointments,
      'completedAppointments': completedAppointments,
      'cancelledAppointments': cancelledAppointments,
      'revenue': revenue,
      'monthlyGrowth': monthlyGrowth,
      'appointmentChart': appointmentChart?.map((e) => e.toJson()).toList(),
      'revenueChart': revenueChart?.map((e) => e.toJson()).toList(),
    };
  }
}

class ChartData {
  final String label;
  final double value;
  final String? color;

  ChartData({
    required this.label,
    required this.value,
    this.color,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'color': color,
    };
  }
}
