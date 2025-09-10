// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalCondition _$MedicalConditionFromJson(Map<String, dynamic> json) =>
    MedicalCondition(
      name: json['name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      description: json['description'] as String,
      severity: json['severity'] as String,
    );

Map<String, dynamic> _$MedicalConditionToJson(MedicalCondition instance) =>
    <String, dynamic>{
      'name': instance.name,
      'confidence': instance.confidence,
      'description': instance.description,
      'severity': instance.severity,
    };
