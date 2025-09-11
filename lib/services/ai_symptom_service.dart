import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:telemed/models/medical_record.dart';
import '../models/symptom_analysis.dart';
import '../constants/app_constants.dart';

/// AI-powered symptom analysis service supporting multiple languages
/// Provides intelligent health analysis for Hindi, Punjabi, and English
class AISymptomService {
  static final AISymptomService _instance = AISymptomService._internal();
  factory AISymptomService() => _instance;
  AISymptomService._internal();

  static const String _baseUrl = 'http://localhost:5001/api';

  /// Analyze symptoms using multilingual AI
  Future<SymptomAnalysis> analyzeSymptoms({
    required String symptomsText,
    required String language, // 'en', 'hi', 'pa'
    required String patientId,
    Map<String, dynamic>? patientContext,
  }) async {
    try {
      // Call MongoDB backend for AI analysis
      final response = await http.post(
        Uri.parse('$_baseUrl/symptoms/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'symptoms': symptomsText,
          'language': language,
          'patient_id': patientId,
          'patient_context': patientContext ?? {},
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final analysisData = jsonDecode(response.body) as Map<String, dynamic>;

        // Save analysis to database
        await _saveAnalysisToDatabase(
          patientId: patientId,
          symptomsText: symptomsText,
          language: language,
          analysisResult: analysisData,
        );

        return SymptomAnalysis.fromJson(analysisData);
      } else {
        throw Exception('AI analysis service error: ${response.body}');
      }
    } catch (e) {
      print('❌ AI Analysis Error: $e');

      // Fallback to rule-based analysis
      return await _ruleBasedAnalysis(
        symptomsText: symptomsText,
        language: language,
        patientId: patientId,
      );
    }
  }

  /// Fallback rule-based symptom analysis for offline/AI failure scenarios
  Future<SymptomAnalysis> _ruleBasedAnalysis({
    required String symptomsText,
    required String language,
    required String patientId,
  }) async {
    print('⚠️ Using fallback rule-based analysis');

    // Basic keyword matching for common symptoms
    final symptoms = symptomsText.toLowerCase();
    final conditions = <MedicalCondition>[];
    String urgencyLevel = 'low';
    String recommendedSpecialist = 'General Medicine';

    // Common symptom patterns with multilingual support
    if (_containsSymptoms(symptoms, [
      'fever',
      'बुखार',
      'ਬੁਖਾਰ',
      'headache',
      'सिर दर्द',
      'ਸਿਰ ਦਰਦ',
    ])) {
      conditions.add(
        MedicalCondition(
          name: _getLocalizedCondition('Viral Fever', language),
          confidence: 0.7,
          description: _getLocalizedDescription(
            'Common viral infection',
            language,
          ),
          severity: 'medium',
        ),
      );
      urgencyLevel = 'medium';
    }

    if (_containsSymptoms(symptoms, [
      'chest pain',
      'सीने में दर्द',
      'ਛਾਤੀ ਦਾ ਦਰਦ',
      'breathing',
      'सांस',
      'ਸਾਹ',
    ])) {
      conditions.add(
        MedicalCondition(
          name: _getLocalizedCondition('Respiratory Issue', language),
          confidence: 0.8,
          description: _getLocalizedDescription(
            'Requires immediate attention',
            language,
          ),
          severity: 'high',
        ),
      );
      urgencyLevel = 'high';
      recommendedSpecialist = 'Cardiology';
    }

    if (_containsSymptoms(symptoms, [
      'stomach pain',
      'पेट दर्द',
      'ਪੇਟ ਦਰਦ',
      'nausea',
      'उल्टी',
      'ਉਲਟੀ',
    ])) {
      conditions.add(
        MedicalCondition(
          name: _getLocalizedCondition('Digestive Issue', language),
          confidence: 0.65,
          description: _getLocalizedDescription(
            'May require medical attention',
            language,
          ),
          severity: 'medium',
        ),
      );
      urgencyLevel = 'medium';
      recommendedSpecialist = 'Gastroenterology';
    }

    if (_containsSymptoms(symptoms, [
      'joint pain',
      'जोड़ों का दर्द',
      'ਜੋੜਿਆਂ ਦਾ ਦਰਦ',
      'swelling',
      'सूजन',
      'ਸੂਜਨ',
    ])) {
      conditions.add(
        MedicalCondition(
          name: _getLocalizedCondition('Joint/Muscle Issue', language),
          confidence: 0.6,
          description: _getLocalizedDescription(
            'Could be arthritis or injury',
            language,
          ),
          severity: 'medium',
        ),
      );
      recommendedSpecialist = 'Orthopedics';
    }

    if (_containsSymptoms(symptoms, [
      'skin rash',
      'चमड़ी की लालपन',
      'ਚਮੜੀ ਦੀ ਲਾਲਪਣ',
      'itching',
      'खुजली',
      'ਖੁਜਲੀ',
    ])) {
      conditions.add(
        MedicalCondition(
          name: _getLocalizedCondition('Skin Condition', language),
          confidence: 0.55,
          description: _getLocalizedDescription(
            'Possible allergic reaction',
            language,
          ),
          severity: 'low',
        ),
      );
      recommendedSpecialist = 'Dermatology';
    }

    // Emergency keywords
    if (_containsSymptoms(symptoms, [
      'unconscious',
      'बेहोश',
      'ਬੇਹੋਸ਼',
      'severe pain',
      'तेज दर्द',
      'ਤੇਜ਼ ਦਰਦ',
      'difficulty breathing',
      'सांस लेने में तकलीफ',
      'ਸਾਹ ਲੈਣ ਵਿੱਚ ਤਕਲੀਫ',
    ])) {
      urgencyLevel = 'critical';
      recommendedSpecialist = 'Emergency Medicine';
    }

    final analysis = SymptomAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: patientId,
      symptomsText: symptomsText,
      language: language,
      conditions: conditions.isNotEmpty
          ? conditions
          : [
              MedicalCondition(
                name: _getLocalizedCondition(
                  'General Consultation Needed',
                  language,
                ),
                confidence: 0.5,
                description: _getLocalizedDescription(
                  'Please consult a doctor for proper diagnosis',
                  language,
                ),
                severity: 'low',
              ),
            ],
      urgencyLevel: urgencyLevel,
      recommendedSpecialist: recommendedSpecialist,
      confidenceScore: conditions.isNotEmpty ? 0.5 : 0.3,
      analysisTimestamp: DateTime.now(),
      isRuleBasedFallback: true,
      // Required legacy fields
      disease: conditions.isNotEmpty
          ? conditions.first.name
          : _getLocalizedCondition('General Consultation Needed', language),
      description: conditions.isNotEmpty
          ? conditions.first.description
          : _getLocalizedDescription(
              'Please consult a doctor for proper diagnosis',
              language,
            ),
      precautions: _generatePrecautions(conditions, language),
      medications: _generateMedications(conditions, language),
      diets: _generateDiets(conditions, language),
    );

    // Save fallback analysis
    await _saveAnalysisToDatabase(
      patientId: patientId,
      symptomsText: symptomsText,
      language: language,
      analysisResult: analysis.toJson(),
    );

    return analysis;
  }

  /// Check if text contains any of the symptom keywords
  bool _containsSymptoms(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword.toLowerCase()));
  }

  /// Get localized condition name
  String _getLocalizedCondition(String condition, String language) {
    final translations = {
      'Viral Fever': {
        'hi': 'वायरल बुखार',
        'pa': 'ਵਾਇਰਲ ਬੁਖਾਰ',
        'en': 'Viral Fever',
      },
      'Respiratory Issue': {
        'hi': 'श्वसन संबंधी समस्या',
        'pa': 'ਸਾਹ ਸੰਬੰਧੀ ਸਮੱਸਿਆ',
        'en': 'Respiratory Issue',
      },
      'Digestive Issue': {
        'hi': 'पाचन संबंधी समस्या',
        'pa': 'ਪਾਚਨ ਸੰਬੰਧੀ ਸਮੱਸਿਆ',
        'en': 'Digestive Issue',
      },
      'Joint/Muscle Issue': {
        'hi': 'जोड़/मांसपेशी समस्या',
        'pa': 'ਜੋੜ/ਮਾਂਸਪੇਸ਼ੀ ਸਮੱਸਿਆ',
        'en': 'Joint/Muscle Issue',
      },
      'Skin Condition': {
        'hi': 'त्वचा की स्थिति',
        'pa': 'ਚਮੜੀ ਦੀ ਸਥਿਤੀ',
        'en': 'Skin Condition',
      },
      'General Consultation Needed': {
        'hi': 'सामान्य परामर्श आवश्यक',
        'pa': 'ਆਮ ਸਲਾਹ ਦੀ ਲੋੜ',
        'en': 'General Consultation Needed',
      },
    };

    return translations[condition]?[language] ?? condition;
  }

  /// Get localized description
  String _getLocalizedDescription(String description, String language) {
    final translations = {
      'Common viral infection': {
        'hi': 'सामान्य वायरल संक्रमण',
        'pa': 'ਆਮ ਵਾਇਰਲ ਇਨਫੈਕਸ਼ਨ',
        'en': 'Common viral infection',
      },
      'Requires immediate attention': {
        'hi': 'तुरंत ध्यान देने की आवश्यकता',
        'pa': 'ਤੁਰੰਤ ਧਿਆਨ ਦੀ ਲੋੜ',
        'en': 'Requires immediate attention',
      },
      'May require medical attention': {
        'hi': 'चिकित्सा ध्यान आवश्यक हो सकता है',
        'pa': 'ਡਾਕਟਰੀ ਧਿਆਨ ਦੀ ਲੋੜ ਹੋ ਸਕਦੀ ਹੈ',
        'en': 'May require medical attention',
      },
      'Could be arthritis or injury': {
        'hi': 'गठिया या चोट हो सकती है',
        'pa': 'ਗਠਿਆ ਜਾਂ ਚੋਟ ਹੋ ਸਕਦੀ ਹੈ',
        'en': 'Could be arthritis or injury',
      },
      'Possible allergic reaction': {
        'hi': 'संभावित एलर्जी प्रतिक्रिया',
        'pa': 'ਸੰਭਾਵਿਤ ਐਲਰਜੀ ਪ੍ਰਤੀਕਿਰਿਆ',
        'en': 'Possible allergic reaction',
      },
      'Please consult a doctor for proper diagnosis': {
        'hi': 'उचित निदान के लिए डॉक्टर से सलाह लें',
        'pa': 'ਸਹੀ ਨਿਦਾਨ ਲਈ ਡਾਕਟਰ ਨਾਲ ਸਲਾਹ ਕਰੋ',
        'en': 'Please consult a doctor for proper diagnosis',
      },
    };

    return translations[description]?[language] ?? description;
  }

  /// Save analysis results to database
  Future<void> _saveAnalysisToDatabase({
    required String patientId,
    required String symptomsText,
    required String language,
    required Map<String, dynamic> analysisResult,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/symptoms/analyses'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'patient_id': patientId,
          'symptoms_text': symptomsText,
          'language': language,
          'analysis_result': analysisResult,
          'confidence_score': analysisResult['confidenceScore'] ?? 0.5,
          'recommended_specialist':
              analysisResult['recommendedSpecialist'] ?? 'General Medicine',
          'urgency_level': analysisResult['urgencyLevel'] ?? 'low',
          'created_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        print('✅ Symptom analysis saved to database');
      }
    } catch (e) {
      print('⚠️ Failed to save analysis to database: $e');
      // Non-critical error, continue with analysis
    }
  }

  /// Get previous symptom analyses for a patient
  Future<List<SymptomAnalysis>> getPatientAnalysisHistory(
    String patientId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/symptoms/analyses?patientId=$patientId&limit=10'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map<SymptomAnalysis>((item) => SymptomAnalysis.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      print('❌ Error fetching analysis history: $e');
      return [];
    }
  }

  /// Get recommended doctors based on analysis
  Future<List<String>> getRecommendedDoctors({
    required String specialization,
    String? location,
  }) async {
    try {
      String url =
          '$_baseUrl/doctors/available?specialization=$specialization&limit=5';
      if (location != null) {
        url += '&location=$location';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> doctors = jsonDecode(response.body);
        return doctors
            .map<String>((doctor) => doctor['name'] as String)
            .toList();
      }
      return [];
    } catch (e) {
      print('❌ Error fetching recommended doctors: $e');
      return [];
    }
  }

  /// Check if AI service is available
  Future<bool> checkAIServiceStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('⚠️ AI service check failed: $e');
      return false;
    }
  }

  /// Get offline symptom analysis guidance
  Future<SymptomAnalysis> getOfflineGuidance({
    required String symptomsText,
    required String language,
    required String patientId,
  }) async {
    // Always return rule-based analysis for offline use
    return await _ruleBasedAnalysis(
      symptomsText: symptomsText,
      language: language,
      patientId: patientId,
    );
  }

  /// Generate precaution recommendations based on conditions
  List<String> _generatePrecautions(
    List<MedicalCondition> conditions,
    String language,
  ) {
    if (conditions.isEmpty) {
      return [
        if (language == 'hi')
          'चिकित्सक से परामर्श लें'
        else if (language == 'pa')
          'ਡਾਕਟਰ ਨਾਲ ਸਲਾਹ ਕਰੋ'
        else
          'Consult a doctor',
        if (language == 'hi')
          'आराम करें और पर्याप्त तरल पदार्थ का सेवन करें'
        else if (language == 'pa')
          'ਆਰਾਮ ਕਰੋ ਅਤੇ ਪਰ੍ਯਾਪਤ ਤਰਲ ਪਦਾਰਥ ਲਈ'
        else
          'Rest and drink plenty of fluids',
      ];
    }

    final condition = conditions.first;
    if (condition.name.contains('Fever') ||
        condition.name.contains('बुखार') ||
        condition.name.contains('ਬੁਖਾਰ')) {
      return [
        if (language == 'hi')
          'पर्याप्त पानी पिएं'
        else if (language == 'pa')
          'ਪਰ੍ਯਾਪਤ ਪਾਣੀ ਪੀਓ'
        else
          'Drink plenty of water',
        if (language == 'hi')
          'आराम करें'
        else if (language == 'pa')
          'ਆਰਾਮ ਕਰੋ'
        else
          'Rest',
        if (language == 'hi')
          'तापमान नियमित रूप से जांचें'
        else if (language == 'pa')
          'ਤਾਪਮਾਨ ਨਿਯਮਿਤ ਰੂਪ ਵਿੱਚ ਜਾਂਚੋ'
        else
          'Monitor temperature regularly',
      ];
    } else if (condition.name.contains('Respiratory') ||
        condition.name.contains('सांस') ||
        condition.name.contains('ਸਾਹ')) {
      return [
        if (language == 'hi')
          'ताज़ी हवा में सांस लें'
        else if (language == 'pa')
          'ਤਾਜ਼ਾ ਹਵਾ ਵਿੱਚ ਸਾਹ ਲਓ'
        else
          'Breathe fresh air',
        if (language == 'hi')
          'धूम्रपान न करें'
        else if (language == 'pa')
          'ਧੂਮਰਪਾਨ ਨਾ ਕਰੋ'
        else
          'Avoid smoking',
        if (language == 'hi')
          'चिकित्सक से तुरंत परामर्श लें'
        else if (language == 'pa')
          'ਡਾਕਟਰ ਨਾਲ ਤੁਰੰਤ ਸਲਾਹ ਕਰੋ'
        else
          'Consult a doctor immediately',
      ];
    } else if (condition.name.contains('Digestive') ||
        condition.name.contains('पेट') ||
        condition.name.contains('ਪੇਟ')) {
      return [
        if (language == 'hi')
          'हल्का भोजन करें'
        else if (language == 'pa')
          'ਹਲਕਾ ਖਾਣਾ ਖਾਓ'
        else
          'Eat light food',
        if (language == 'hi')
          'दवाई लेने से पहले चिकित्सक से परामर्श लें'
        else if (language == 'pa')
          'ਦਵਾਈ ਲੈਣ ਤੋਂ ਪਹਿਲਾਂ ਡਾਕਟਰ ਨਾਲ ਸਲਾਹ ਕਰੋ'
        else
          'Consult a doctor before taking medication',
      ];
    } else {
      return [
        if (language == 'hi')
          'चिकित्सक से परामर्श लें'
        else if (language == 'pa')
          'ਡਾਕਟਰ ਨਾਲ ਸਲਾਹ ਕਰੋ'
        else
          'Consult a doctor',
        if (language == 'hi')
          'आराम करें'
        else if (language == 'pa')
          'ਆਰਾਮ ਕਰੋ'
        else
          'Rest',
      ];
    }
  }

  /// Generate medication recommendations based on conditions
  List<String> _generateMedications(
    List<MedicalCondition> conditions,
    String language,
  ) {
    if (conditions.isEmpty) {
      return [];
    }

    final condition = conditions.first;
    if (condition.name.contains('Fever') ||
        condition.name.contains('बुखार') ||
        condition.name.contains('ਬੁਖਾਰ')) {
      return [
        if (language == 'hi')
          'पैरासिटामोल 500 मिग्रा'
        else if (language == 'pa')
          'ਪੈਰਾਸਿਟਾਮੋਲ 500 ਮਿਗ੍ਰਾ'
        else
          'Paracetamol 500mg',
        if (language == 'hi')
          'इब्रूफेन 400 मिग्रा'
        else if (language == 'pa')
          'ਇਬ੍ਰੂਫੇਨ 400 ਮਿਗ੍ਰਾ'
        else
          'Ibuprofen 400mg',
      ];
    } else if (condition.name.contains('Respiratory') ||
        condition.name.contains('सांस') ||
        condition.name.contains('ਸਾਹ')) {
      return [
        if (language == 'hi')
          'ब्रोन्कोडाइलेटर'
        else if (language == 'pa')
          'ਬ੍ਰੋਨਕੋਡਾਇਲੇਟਰ'
        else
          'Bronchodilator',
      ];
    } else if (condition.name.contains('Digestive') ||
        condition.name.contains('पेट') ||
        condition.name.contains('ਪੇਟ')) {
      return [
        if (language == 'hi')
          'एंटासिड'
        else if (language == 'pa')
          'ਐਂਟਾਸਿਡ'
        else
          'Antacid',
      ];
    } else {
      return [
        if (language == 'hi')
          'सिम्प्टमैटिक उपचार'
        else if (language == 'pa')
          'ਸਿੰਪਟਮੈਟਿਕ ਇਲਾਜ'
        else
          'Symptomatic treatment',
      ];
    }
  }

  /// Generate diet recommendations based on conditions
  List<String> _generateDiets(
    List<MedicalCondition> conditions,
    String language,
  ) {
    if (conditions.isEmpty) {
      return [
        if (language == 'hi')
          'संतुलित आहार'
        else if (language == 'pa')
          'ਸੰਤੁਲਿਤ ਆਹਾਰ'
        else
          'Balanced diet',
      ];
    }

    final condition = conditions.first;
    if (condition.name.contains('Fever') ||
        condition.name.contains('बुखार') ||
        condition.name.contains('ਬੁਖਾਰ')) {
      return [
        if (language == 'hi')
          'हल्का और पौष्टिक भोजन'
        else if (language == 'pa')
          'ਹਲਕਾ ਅਤੇ ਪੌਸ਼ਟਿਕ ਖਾਣਾ'
        else
          'Light and nutritious food',
        if (language == 'hi')
          'अधिक तरल पदार्थ'
        else if (language == 'pa')
          'ਵੱਧ ਤਰਲ ਪਦਾਰਥ'
        else
          'More fluids',
        if (language == 'hi')
          'चावल, दाल और सब्जियां'
        else if (language == 'pa')
          'ਚਾਵਲ, ਦਾਲ ਅਤੇ ਸਬਜ਼ੀਆਂ'
        else
          'Rice, lentils and vegetables',
      ];
    } else if (condition.name.contains('Digestive') ||
        condition.name.contains('पेट') ||
        condition.name.contains('ਪੇਟ')) {
      return [
        if (language == 'hi')
          'हल्का भोजन'
        else if (language == 'pa')
          'ਹਲਕਾ ਖਾਣਾ'
        else
          'Light diet',
        if (language == 'hi')
          'दूध और दही'
        else if (language == 'pa')
          'ਦੁੱਧ ਅਤੇ ਦਹੀ'
        else
          'Milk and yogurt',
        if (language == 'hi')
          'ताज़े फल और सब्जियां'
        else if (language == 'pa')
          'ਤਾਜ਼ੇ ਫਲ ਅਤੇ ਸਬਜ਼ੀਆਂ'
        else
          'Fresh fruits and vegetables',
      ];
    } else {
      return [
        if (language == 'hi')
          'संतुलित आहार'
        else if (language == 'pa')
          'ਸੰਤੁਲਿਤ ਆਹਾਰ'
        else
          'Balanced diet',
        if (language == 'hi')
          'पर्याप्त पानी'
        else if (language == 'pa')
          'ਪਰ੍ਯਾਪਤ ਪਾਣੀ'
        else
          'Plenty of water',
      ];
    }
  }
}
