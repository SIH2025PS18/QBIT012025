import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SymptomData {
  final String disease;
  final String description;
  final List<String> symptoms;
  final List<String> precautions;
  final List<String> medications;
  final List<String> diets;
  final List<String> workouts;

  SymptomData({
    required this.disease,
    required this.description,
    required this.symptoms,
    required this.precautions,
    required this.medications,
    required this.diets,
    required this.workouts,
  });

  factory SymptomData.fromJson(Map<String, dynamic> json) {
    return SymptomData(
      disease: json['disease'] as String,
      description: json['description'] as String,
      symptoms: List<String>.from(json['symptoms'] as List),
      precautions: List<String>.from(json['precautions'] as List),
      medications: List<String>.from(json['medications'] as List),
      diets: List<String>.from(json['diets'] as List),
      workouts: List<String>.from(json['workouts'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease': disease,
      'description': description,
      'symptoms': symptoms,
      'precautions': precautions,
      'medications': medications,
      'diets': diets,
      'workouts': workouts,
    };
  }

  static Future<List<SymptomData>> loadFromAssets() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/complete_symptoms_data.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString) as List;
      return jsonList
          .map((item) => SymptomData.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading symptom data: $e');
      return [];
    }
  }
}

class DiseasePrediction {
  final String disease;
  final String description;
  final List<String> symptoms;
  final List<String> precautions;
  final List<String> medications;
  final List<String> diets;
  final List<String> workouts;
  final double confidence;

  DiseasePrediction({
    required this.disease,
    required this.description,
    required this.symptoms,
    required this.precautions,
    required this.medications,
    required this.diets,
    required this.workouts,
    required this.confidence,
  });
}

class OfflineSymptomChecker {
  static List<SymptomData> _symptomData = [];
  static bool _isLoaded = false;

  static Future<void> loadSymptomData() async {
    if (_isLoaded) return;

    try {
      // Load symptom data from assets
      final String symptomsData = await rootBundle.loadString(
        'assets/symptoms_data.json',
      );
      final List<dynamic> symptomsJson = json.decode(symptomsData);

      _symptomData = symptomsJson
          .map((item) => SymptomData.fromJson(item as Map<String, dynamic>))
          .toList();

      _isLoaded = true;
    } catch (e) {
      print('Error loading symptom data: $e');
      // Load fallback data
      _loadFallbackData();
      _isLoaded = true;
    }
  }

  static void _loadFallbackData() {
    // Fallback data for offline use
    _symptomData = [
      SymptomData(
        disease: "Common Cold",
        description:
            "Common Cold is a viral infection of the upper respiratory tract.",
        symptoms: ["cough", "fever", "runny nose", "sneezing", "sore throat"],
        precautions: [
          "drink vitamin c rich drinks",
          "take vapour",
          "avoid cold food",
          "keep fever in check",
        ],
        medications: [
          "Antibiotics",
          "Antiviral drugs",
          "Antifungal drugs",
          "IV fluids",
          "Oxygen therapy",
        ],
        diets: ["Hydration", "Warm fluids", "Rest", "Honey and lemon tea"],
        workouts: [
          "Stay hydrated",
          "Get plenty of rest",
          "Use a humidifier",
          "Gargle with warm salt water",
          "Avoid smoking and secondhand smoke",
        ],
      ),
      SymptomData(
        disease: "Fungal infection",
        description:
            "Fungal infection is a common skin condition caused by fungi.",
        symptoms: [
          "itching",
          "skin rash",
          "nodal skin eruptions",
          "dischromic patches",
        ],
        precautions: [
          "bath twice",
          "use detol or neem in bathing water",
          "keep infected area dry",
          "use clean cloths",
        ],
        medications: [
          "Antifungal Cream",
          "Fluconazole",
          "Terbinafine",
          "Clotrimazole",
          "Ketoconazole",
        ],
        diets: [
          "Antifungal Diet",
          "Probiotics",
          "Garlic",
          "Coconut oil",
          "Turmeric",
        ],
        workouts: [
          "Keep affected area clean and dry",
          "Wear loose-fitting clothes",
          "Avoid sharing personal items",
          "Use antifungal powder",
          "Maintain good hygiene",
        ],
      ),
      // Add more fallback data as needed
    ];
  }

  static List<SymptomData> searchBySymptoms(List<String> inputSymptoms) {
    if (!_isLoaded) {
      throw Exception('Symptom data not loaded. Call loadSymptomData() first.');
    }

    // Simple matching algorithm - count matching symptoms
    final List<Map<String, dynamic>> matches = [];

    for (final data in _symptomData) {
      int matchCount = 0;
      for (final inputSymptom in inputSymptoms) {
        for (final symptom in data.symptoms) {
          if (_normalizeSymptom(
                inputSymptom,
              ).contains(_normalizeSymptom(symptom)) ||
              _normalizeSymptom(
                symptom,
              ).contains(_normalizeSymptom(inputSymptom))) {
            matchCount++;
            break;
          }
        }
      }

      if (matchCount > 0) {
        matches.add({
          'data': data,
          'matchCount': matchCount,
          'confidence': matchCount / data.symptoms.length,
        });
      }
    }

    // Sort by match count (descending)
    matches.sort((a, b) => b['matchCount'].compareTo(a['matchCount']));

    // Return top 3 matches
    return matches
        .take(3)
        .map((match) => match['data'] as SymptomData)
        .toList();
  }

  static String _normalizeSymptom(String symptom) {
    return symptom.toLowerCase().replaceAll(RegExp(r'[_\s]+'), ' ').trim();
  }

  static List<String> getAllSymptoms() {
    if (!_isLoaded) {
      throw Exception('Symptom data not loaded. Call loadSymptomData() first.');
    }

    final Set<String> allSymptoms = {};
    for (final data in _symptomData) {
      allSymptoms.addAll(data.symptoms);
    }

    return allSymptoms.toList();
  }

  static List<String> getAllDiseases() {
    if (!_isLoaded) {
      throw Exception('Symptom data not loaded. Call loadSymptomData() first.');
    }

    return _symptomData.map((data) => data.disease).toList();
  }
}
