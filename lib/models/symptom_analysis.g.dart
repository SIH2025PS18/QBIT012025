// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorRecommendation _$DoctorRecommendationFromJson(
  Map<String, dynamic> json,
) => DoctorRecommendation(
  specialization: json['specialization'] as String,
  reason: json['reason'] as String,
  urgency: json['urgency'] as String,
  preferredDoctors: (json['preferredDoctors'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  additionalNotes: json['additionalNotes'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$DoctorRecommendationToJson(
  DoctorRecommendation instance,
) => <String, dynamic>{
  'specialization': instance.specialization,
  'reason': instance.reason,
  'urgency': instance.urgency,
  'preferredDoctors': instance.preferredDoctors,
  'additionalNotes': instance.additionalNotes,
};

NextStepsRecommendation _$NextStepsRecommendationFromJson(
  Map<String, dynamic> json,
) => NextStepsRecommendation(
  immediateActions: (json['immediateActions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  homeRemedies: (json['homeRemedies'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  warningSignsToWatch: (json['warningSignsToWatch'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  followUpTimeframe: json['followUpTimeframe'] as String?,
  requiresEmergencyCare: json['requiresEmergencyCare'] as bool? ?? false,
);

Map<String, dynamic> _$NextStepsRecommendationToJson(
  NextStepsRecommendation instance,
) => <String, dynamic>{
  'immediateActions': instance.immediateActions,
  'homeRemedies': instance.homeRemedies,
  'warningSignsToWatch': instance.warningSignsToWatch,
  'followUpTimeframe': instance.followUpTimeframe,
  'requiresEmergencyCare': instance.requiresEmergencyCare,
};

SymptomAnalysis _$SymptomAnalysisFromJson(Map<String, dynamic> json) =>
    SymptomAnalysis(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      symptomsText: json['symptomsText'] as String,
      language: json['language'] as String,
      conditions: (json['conditions'] as List<dynamic>)
          .map((e) => MedicalCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
      urgencyLevel: json['urgencyLevel'] as String,
      recommendedSpecialist: json['recommendedSpecialist'] as String,
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      analysisTimestamp: DateTime.parse(json['analysisTimestamp'] as String),
      doctorRecommendation: json['doctorRecommendation'] == null
          ? null
          : DoctorRecommendation.fromJson(
              json['doctorRecommendation'] as Map<String, dynamic>,
            ),
      nextSteps: json['nextSteps'] == null
          ? null
          : NextStepsRecommendation.fromJson(
              json['nextSteps'] as Map<String, dynamic>,
            ),
      isRuleBasedFallback: json['isRuleBasedFallback'] as bool? ?? false,
      additionalMetadata: json['additionalMetadata'] as Map<String, dynamic>?,
      disease: json['disease'] as String,
      description: json['description'] as String,
      precautions: (json['precautions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      medications: (json['medications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      diets: (json['diets'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SymptomAnalysisToJson(SymptomAnalysis instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'symptomsText': instance.symptomsText,
      'language': instance.language,
      'conditions': instance.conditions,
      'urgencyLevel': instance.urgencyLevel,
      'recommendedSpecialist': instance.recommendedSpecialist,
      'confidenceScore': instance.confidenceScore,
      'analysisTimestamp': instance.analysisTimestamp.toIso8601String(),
      'doctorRecommendation': instance.doctorRecommendation,
      'nextSteps': instance.nextSteps,
      'isRuleBasedFallback': instance.isRuleBasedFallback,
      'additionalMetadata': instance.additionalMetadata,
      'disease': instance.disease,
      'description': instance.description,
      'precautions': instance.precautions,
      'medications': instance.medications,
      'diets': instance.diets,
    };
