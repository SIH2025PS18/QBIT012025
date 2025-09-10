import 'package:flutter_test/flutter_test.dart';
import 'package:telemed/services/symptom_analysis_service.dart';

void main() {
  group('Symptom Analysis Service Tests', () {
    late SymptomAnalysisService service;

    setUp(() {
      service = SymptomAnalysisService();
    });

    test('Parse symptoms correctly identifies common symptoms', () {
      // Test basic symptom parsing
      var symptoms = service.parseSymptomsForTesting('I have a headache and fever');
      expect(symptoms, contains('headache'));
      expect(symptoms, contains('fever'));
    });

    test('Parse symptoms handles variations', () {
      // Test symptom variations
      var symptoms = service.parseSymptomsForTesting('I have a sore throat and runny nose');
      expect(symptoms, contains('sore_throat'));
      expect(symptoms, contains('runny_nose'));
    });

    test('Parse symptoms handles multi-word symptoms', () {
      // Test multi-word symptoms
      var symptoms = service.parseSymptomsForTesting('I have short of breath and chest pain');
      expect(symptoms, contains('breathlessness'));
      expect(symptoms, contains('chest_pain'));
    });

    test('Get simulated prediction for flu-like symptoms', () async {
      // Test flu prediction
      var analysis = await service.getSimulatedPrediction('fever cough body aches fatigue');
      expect(analysis.disease, isNot('Common Cold'));
      expect(analysis.disease, 'Influenza (Flu)');
    });

    test('Get simulated prediction for COVID-19 symptoms', () async {
      // Test COVID-19 prediction
      var analysis = await service.getSimulatedPrediction('fever cough breathlessness loss of taste');
      expect(analysis.disease, 'COVID-19');
    });

    test('Get simulated prediction for diabetes symptoms', () async {
      // Test diabetes prediction
      var analysis = await service.getSimulatedPrediction('increased thirst frequent urination blurred vision fatigue');
      expect(analysis.disease, 'Diabetes');
    });

    test('Get simulated prediction falls back to common cold for unknown combinations', () async {
      // Test fallback behavior
      var analysis = await service.getSimulatedPrediction('random symptom combination');
      // Should not be common cold anymore due to our improved fallback logic
      expect(analysis.disease, isNot('Common Cold'));
    });
  });
}