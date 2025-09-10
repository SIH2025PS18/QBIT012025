import 'package:json_annotation/json_annotation.dart';
import 'medical_record.dart'; // Assuming MedicalCondition is defined here

part 'symptom_analysis.g.dart';

@JsonSerializable()
class DoctorRecommendation {
  final String specialization;
  final String reason;
  final String urgency;
  final List<String>? preferredDoctors;
  final Map<String, dynamic>? additionalNotes;

  DoctorRecommendation({
    required this.specialization,
    required this.reason,
    required this.urgency,
    this.preferredDoctors,
    this.additionalNotes,
  });

  factory DoctorRecommendation.fromJson(Map<String, dynamic> json) =>
      _$DoctorRecommendationFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorRecommendationToJson(this);
}

@JsonSerializable()
class NextStepsRecommendation {
  final List<String> immediateActions;
  final List<String>? homeRemedies;
  final List<String>? warningSignsToWatch;
  final String? followUpTimeframe;
  final bool requiresEmergencyCare;

  NextStepsRecommendation({
    required this.immediateActions,
    this.homeRemedies,
    this.warningSignsToWatch,
    this.followUpTimeframe,
    this.requiresEmergencyCare = false,
  });

  factory NextStepsRecommendation.fromJson(Map<String, dynamic> json) =>
      _$NextStepsRecommendationFromJson(json);

  Map<String, dynamic> toJson() => _$NextStepsRecommendationToJson(this);
}

@JsonSerializable()
class SymptomAnalysis {
  final String id;
  final String patientId;
  final String symptomsText;
  final String language;
  final List<MedicalCondition> conditions;
  final String urgencyLevel;
  final String recommendedSpecialist;
  final double confidenceScore;
  final DateTime analysisTimestamp;
  final DoctorRecommendation? doctorRecommendation;
  final NextStepsRecommendation? nextSteps;
  final bool isRuleBasedFallback;
  final Map<String, dynamic>? additionalMetadata;

  // Legacy fields for backward compatibility
  final String disease;
  final String description;
  final List<String> precautions;
  final List<String> medications;
  final List<String> diets;

  SymptomAnalysis({
    required this.id,
    required this.patientId,
    required this.symptomsText,
    required this.language,
    required this.conditions,
    required this.urgencyLevel,
    required this.recommendedSpecialist,
    required this.confidenceScore,
    required this.analysisTimestamp,
    this.doctorRecommendation,
    this.nextSteps,
    this.isRuleBasedFallback = false,
    this.additionalMetadata,
    // Legacy fields
    required this.disease,
    required this.description,
    required this.precautions,
    required this.medications,
    required this.diets,
  });

  factory SymptomAnalysis.fromJson(Map<String, dynamic> json) =>
      _$SymptomAnalysisFromJson(json);

  Map<String, dynamic> toJson() => _$SymptomAnalysisToJson(this);
}
