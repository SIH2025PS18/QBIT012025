import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../database/offline_database.dart';
import '../services/auth_service.dart';
import '../services/phone_auth_service.dart';
import '../core/service_locator.dart';

class OfflineSymptomCheckerService {
  static final OfflineSymptomCheckerService _instance =
      OfflineSymptomCheckerService._internal();
  factory OfflineSymptomCheckerService() => _instance;
  OfflineSymptomCheckerService._internal();

  late final OfflineDatabase _db;

  // Initialize the service with dependencies
  Future<void> initialize() async {
    // Get database from service locator with fallback
    try {
      _db = await serviceLocator.getAsync<OfflineDatabase>();
    } catch (e) {
      // Fallback to direct instantiation if service locator fails
      _db = OfflineDatabase();
    }
  }

  // Offline symptom database with multilingual support
  static const Map<String, Map<String, dynamic>> _symptomDatabase = {
    // General symptoms
    'fever': {
      'severity_indicators': [
        'temperature',
        'duration',
        'accompanying_symptoms',
      ],
      'recommendations': {
        'mild': {
          'en': [
            'Rest and hydration',
            'Monitor temperature',
            'Take paracetamol if needed',
          ],
          'hi': [
            'आराम और जल सेवन',
            'तापमान की निगरानी करें',
            'जरूरत पड़ने पर पैरासिटामोल लें',
          ],
          'bn': [
            'বিশ্রাম এবং পানি পান',
            'তাপমাত্রা পর্যবেক্ষণ করুন',
            'প্রয়োজনে প্যারাসিটামল নিন',
          ],
        },
        'moderate': {
          'en': [
            'Seek medical attention within 24 hours',
            'Continue fever management',
            'Monitor for warning signs',
          ],
          'hi': [
            '24 घंटे के भीतर चिकित्सा सहायता लें',
            'बुखार प्रबंधन जारी रखें',
            'चेतावनी संकेतों की निगरानी करें',
          ],
          'bn': [
            '২৪ ঘন্টার মধ্যে চিকিৎসা সহায়তা নিন',
            'জ্বর নিয়ন্ত্রণ অব্যাহত রাখুন',
            'সতর্কতা লক্ষণগুলি পর্যবেক্ষণ করুন',
          ],
        },
        'severe': {
          'en': [
            'URGENT: Seek immediate medical attention',
            'Go to nearest hospital',
            'Call emergency services',
          ],
          'hi': [
            'तत्काल: तुरंत चिकित्सा सहायता लें',
            'निकटतम अस्पताल जाएं',
            'आपातकालीन सेवाओं को कॉल करें',
          ],
          'bn': [
            'জরুরী: অবিলম্বে চিকিৎসা সহায়তা নিন',
            'নিকটতম হাসপাতালে যান',
            'জরুরি সেবায় কল করুন',
          ],
        },
      },
      'warning_signs': {
        'en': [
          'Temperature above 103°F (39.4°C)',
          'Difficulty breathing',
          'Severe headache',
          'Persistent vomiting',
        ],
        'hi': [
          '103°F (39.4°C) से अधिक तापमान',
          'सांस लेने में कठिनाई',
          'गंभीर सिरदर्द',
          'लगातार उल्टी',
        ],
        'bn': [
          '১০৩°F (৩৯.৪°C) এর বেশি তাপমাত্রা',
          'শ্বাসকষ্ট',
          'তীব্র মাথাব্যথা',
          'ক্রমাগত বমি',
        ],
      },
    },

    'headache': {
      'severity_indicators': [
        'intensity',
        'location',
        'duration',
        'associated_symptoms',
      ],
      'recommendations': {
        'mild': {
          'en': [
            'Rest in dark room',
            'Stay hydrated',
            'Apply cold compress',
            'Avoid loud noises',
          ],
          'hi': [
            'अंधेरे कमरे में आराम करें',
            'हाइड्रेटेड रहें',
            'ठंडी सिकाई करें',
            'तेज आवाज से बचें',
          ],
          'bn': [
            'অন্ধকার ঘরে বিশ্রাম নিন',
            'পানি পান করুন',
            'ঠান্ডা সেক দিন',
            'জোরে শব্দ এড়িয়ে চলুন',
          ],
        },
        'moderate': {
          'en': [
            'Consider pain relief medication',
            'Monitor frequency',
            'Consult doctor if persistent',
          ],
          'hi': [
            'दर्द निवारक दवा पर विचार करें',
            'आवृत्ति की निगरानी करें',
            'यदि बना रहे तो डॉक्टर से सलाह लें',
          ],
          'bn': [
            'ব্যথানাশক ওষুধ বিবেচনা করুন',
            'ঘটনার ফ্রিকোয়েন্সি পর্যবেক্ষণ করুন',
            'অব্যাহত থাকলে ডাক্তারের সাথে পরামর্শ করুন',
          ],
        },
        'severe': {
          'en': [
            'URGENT: Sudden severe headache needs immediate attention',
            'May indicate serious condition',
          ],
          'hi': [
            'तत्काल: अचानक गंभीर सिरदर्द तुरंत ध्यान देने की आवश्यकता',
            'गंभीर स्थिति का संकेत हो सकता है',
          ],
          'bn': [
            'জরুরী: হঠাৎ তীব্র মাথাব্যথার জন্য তাৎক্ষণিক মনোযোগ প্রয়োজন',
            'গুরুতর অবস্থার ইঙ্গিত হতে পারে',
          ],
        },
      },
    },

    'cough': {
      'severity_indicators': [
        'type',
        'duration',
        'blood',
        'breathing_difficulty',
      ],
      'recommendations': {
        'mild': {
          'en': [
            'Stay hydrated',
            'Use honey for soothing',
            'Avoid irritants',
            'Rest voice',
          ],
          'hi': [
            'हाइड्रेटेड रहें',
            'शांति के लिए शहद का उपयोग करें',
            'जलन से बचें',
            'आवाज को आराम दें',
          ],
          'bn': [
            'পানি পান করুন',
            'শান্তির জন্য মধু ব্যবহার করুন',
            'জ্বালাকর পদার্থ এড়িয়ে চলুন',
            'কণ্ঠস্বর বিশ্রাম দিন',
          ],
        },
        'moderate': {
          'en': [
            'Monitor for improvement',
            'Consider seeing doctor if persistent > 1 week',
            'Avoid smoking',
          ],
          'hi': [
            'सुधार की निगरानी करें',
            '1 सप्ताह से अधिक बने रहने पर डॉक्टर देखने पर विचार करें',
            'धूम्रपान से बचें',
          ],
          'bn': [
            'উন্নতির জন্য পর্যবেক্ষণ করুন',
            '১ সপ্তাহের বেশি স্থায়ী হলে ডাক্তার দেখার কথা বিবেচনা করুন',
            'ধূমপান এড়িয়ে চলুন',
          ],
        },
        'severe': {
          'en': [
            'URGENT: Blood in cough or breathing difficulty needs immediate attention',
            'Go to hospital',
          ],
          'hi': [
            'तत्काल: खांसी में खून या सांस लेने में कठिनाई तुरंत ध्यान देने की जरूरत',
            'अस्पताल जाएं',
          ],
          'bn': [
            'জরুরী: কাশিতে রক্ত বা শ্বাসকষ্টের জন্য তাৎক্ষণিক মনোযোগ প্রয়োজন',
            'হাসপাতালে যান',
          ],
        },
      },
    },

    'stomach_pain': {
      'severity_indicators': [
        'location',
        'intensity',
        'duration',
        'associated_symptoms',
      ],
      'recommendations': {
        'mild': {
          'en': [
            'Light diet',
            'Stay hydrated',
            'Apply heat pad',
            'Avoid spicy foods',
          ],
          'hi': [
            'हल्का भोजन',
            'हाइड्रेटेड रहें',
            'गर्म पैड लगाएं',
            'मसालेदार भोजन से बचें',
          ],
          'bn': [
            'হালকা খাবার',
            'পানি পান করুন',
            'গরম প্যাড লাগান',
            'মসলাদার খাবার এড়িয়ে চলুন',
          ],
        },
        'moderate': {
          'en': [
            'Monitor symptoms',
            'Consider medical consultation',
            'Avoid solid foods temporarily',
          ],
          'hi': [
            'लक्षणों की निगरानी करें',
            'चिकित्सा परामर्श पर विचार करें',
            'ठोस भोजन से अस्थायीभावे बचें',
          ],
          'bn': [
            'লক্ষণগুলি পর্যবেক্ষণ করুন',
            'চিকিৎসা পরামর্শ বিবেচনা করুন',
            'অস্থায়ীভাবে কঠিন খাবার এড়িয়ে চলুন',
          ],
        },
        'severe': {
          'en': [
            'URGENT: Severe abdominal pain needs immediate medical attention',
            'May indicate serious condition',
          ],
          'hi': [
            'तत्काल: गंभीर पेट दर्द तुरंत चिकित्सा ध्यान देने की जरूरत',
            'गंभीर स्थिति का संकेत हो सकता है',
          ],
          'bn': [
            'জরুরী: তীব্র পেটব্যথার জন্য তাৎক্ষণিক চিকিৎসা প্রয়োজন',
            'গুরুতর অবস্থার ইঙ্গিত হতে পারে',
          ],
        },
      },
    },

    'breathing_difficulty': {
      'severity_indicators': [
        'intensity',
        'duration',
        'position_dependent',
        'chest_pain',
      ],
      'recommendations': {
        'mild': {
          'en': [
            'Sit upright',
            'Practice slow breathing',
            'Use fan for air circulation',
            'Stay calm',
          ],
          'hi': [
            'सीधे बैठें',
            'धीमी सांस लेने का अभ्यास करें',
            'हवा के संचलन के लिए पंखे का उपयोग करें',
            'शांत रहें',
          ],
          'bn': [
            'সোজা হয়ে বসুন',
            'ধীর শ্বাসের অনুশীলন করুন',
            'বাতাস চলাচলের জন্য পাখা ব্যবহার করুন',
            'শান্ত থাকুন',
          ],
        },
        'moderate': {
          'en': [
            'Seek medical attention soon',
            'Monitor oxygen levels if available',
            'Avoid physical exertion',
          ],
          'hi': [
            'जल्द चिकित्सा सहायता लें',
            'यदि उपलब्ध हो तो ऑक्सीजन स्तर की निगरानी करें',
            'शारीरिक परिश्रम से बचें',
          ],
          'bn': [
            'শীঘ্রই চিকিৎসা সহায়তা নিন',
            'উপলব্ধ থাকলে অক্সিজেনের মাত্রা পর্যবেক্ষণ করুন',
            'শারীরিক পরিশ্রম এড়িয়ে চলুন',
          ],
        },
        'severe': {
          'en': [
            'EMERGENCY: Call ambulance immediately',
            'Severe breathing difficulty is a medical emergency',
          ],
          'hi': [
            'आपातकाल: तुरंत एम्बुलेंस कॉल करें',
            'गंभीर सांस लेने में कठिनाई एक चिकित्सा आपातकाल है',
          ],
          'bn': [
            'জরুরী অবস্থা: অবিলম্বে অ্যাম্বুলেন্স কল করুন',
            'তীব্র শ্বাসকষ্ট একটি চিকিৎসা জরুরি অবস্থা',
          ],
        },
      },
    },
  };

  // Emergency keywords that should trigger urgent care recommendations
  static const List<String> _emergencyKeywords = [
    'chest pain',
    'heart attack',
    'stroke',
    'unconscious',
    'bleeding',
    'accident',
    'suicide',
    'overdose',
    'poisoning',
    'severe burn',
    'choking',
    'seizure',
  ];

  Future<Map<String, dynamic>> checkSymptomsOffline({
    required String patientId,
    required List<String> symptoms,
    required Map<String, dynamic> symptomDetails,
    String language = 'en',
  }) async {
    try {
      // Check for emergency keywords first
      final isEmergency = _checkForEmergencyKeywords(symptoms);
      if (isEmergency) {
        return _getEmergencyResponse(language);
      }

      // Analyze symptoms
      final analysis = _analyzeSymptoms(symptoms, symptomDetails, language);

      // Save to offline database
      final symptomCheckId = await _db.saveOfflineSymptomCheck(
        patientId: patientId,
        symptoms: jsonEncode(symptoms),
        severity: analysis['severity'],
        recommendations: jsonEncode(analysis['recommendations']),
        language: language,
        requiresUrgentCare: analysis['requiresUrgentCare'] ?? false,
      );

      return {
        'id': symptomCheckId,
        'severity': analysis['severity'],
        'recommendations': analysis['recommendations'],
        'warning_signs': analysis['warning_signs'],
        'requiresUrgentCare': analysis['requiresUrgentCare'] ?? false,
        'next_steps': analysis['next_steps'],
        'when_to_seek_help': analysis['when_to_seek_help'],
        'offline_check': true,
        'language': language,
      };
    } catch (e) {
      debugPrint('Error in offline symptom check: $e');
      return _getDefaultResponse(language);
    }
  }

  bool _checkForEmergencyKeywords(List<String> symptoms) {
    for (final symptom in symptoms) {
      for (final keyword in _emergencyKeywords) {
        if (symptom.toLowerCase().contains(keyword.toLowerCase())) {
          return true;
        }
      }
    }
    return false;
  }

  Map<String, dynamic> _getEmergencyResponse(String language) {
    final messages = {
      'en': {
        'severity': 'emergency',
        'message': 'EMERGENCY: This requires immediate medical attention',
        'action':
            'Call emergency services (108) or go to the nearest hospital immediately',
        'recommendations': [
          'Call 108 immediately',
          'Go to nearest emergency room',
          'Do not delay seeking medical help',
        ],
      },
      'hi': {
        'severity': 'emergency',
        'message': 'आपातकाल: इसके लिए तुरंत चिकित्सा सहायता की आवश्यकता है',
        'action':
            'आपातकालीन सेवाओं (108) को कॉल करें या तुरंत निकटतम अस्पताल जाएं',
        'recommendations': [
          'तुरंत 108 पर कॉल करें',
          'निकटतम आपातकालीन कक्ष में जाएं',
          'चिकित्सा सहायता लेने में देरी न करें',
        ],
      },
      'bn': {
        'severity': 'emergency',
        'message': 'জরুরী অবস্থা: এর জন্য তাৎক্ষণিক চিকিৎসা প্রয়োজন',
        'action': 'জরুরি সেবা (108) কল করুন বা অবিলম্বে নিকটতম হাসপাতালে যান',
        'recommendations': [
          'অবিলম্বে 108 এ কল করুন',
          'নিকটতম জরুরি কক্ষে যান',
          'চিকিৎসা সহায়তা নিতে দেরি করবেন না',
        ],
      },
    };

    return {
      ...messages[language] ?? messages['en']!,
      'requiresUrgentCare': true,
      'next_steps': ['Emergency care'],
    };
  }

  Map<String, dynamic> _analyzeSymptoms(
    List<String> symptoms,
    Map<String, dynamic> details,
    String language,
  ) {
    var overallSeverity = 'mild';
    final List<String> recommendations = [];
    final List<String> warningSignsFound = [];
    bool requiresUrgentCare = false;

    for (final symptom in symptoms) {
      final symptomLower = symptom.toLowerCase();

      // Find matching symptom in database
      String? matchedSymptom;
      for (final key in _symptomDatabase.keys) {
        if (symptomLower.contains(key) || key.contains(symptomLower)) {
          matchedSymptom = key;
          break;
        }
      }

      if (matchedSymptom != null) {
        final symptomData = _symptomDatabase[matchedSymptom]!;

        // Analyze severity based on details
        final severity = _determineSeverity(matchedSymptom, details);

        // Update overall severity
        if (severity == 'severe') {
          overallSeverity = 'severe';
          requiresUrgentCare = true;
        } else if (severity == 'moderate' && overallSeverity != 'severe') {
          overallSeverity = 'moderate';
        }

        // Add recommendations
        final symptomRecommendations =
            symptomData['recommendations'][severity][language] as List<String>?;
        if (symptomRecommendations != null) {
          recommendations.addAll(symptomRecommendations);
        }

        // Check for warning signs
        if (severity == 'severe') {
          final warningSignsData =
              symptomData['warning_signs'][language] as List<String>?;
          if (warningSignsData != null) {
            warningSignsFound.addAll(warningSignsData);
          }
        }
      } else {
        // Generic advice for unknown symptoms
        final genericAdvice = _getGenericAdvice(language);
        recommendations.addAll(genericAdvice);
      }
    }

    return {
      'severity': overallSeverity,
      'recommendations': recommendations.toSet().toList(), // Remove duplicates
      'warning_signs': warningSignsFound,
      'requiresUrgentCare': requiresUrgentCare,
      'next_steps': _getNextSteps(overallSeverity, language),
      'when_to_seek_help': _getWhenToSeekHelp(overallSeverity, language),
    };
  }

  String _determineSeverity(String symptom, Map<String, dynamic> details) {
    switch (symptom) {
      case 'fever':
        final temp = details['temperature'] as double?;
        if (temp != null && temp > 39.4) return 'severe'; // 103°F
        if (temp != null && temp > 38.5) return 'moderate'; // 101.3°F
        return 'mild';

      case 'headache':
        final intensity = details['intensity'] as int? ?? 1;
        if (intensity >= 8) return 'severe';
        if (intensity >= 5) return 'moderate';
        return 'mild';

      case 'cough':
        if (details['blood'] == true) return 'severe';
        if (details['breathing_difficulty'] == true) return 'severe';
        final duration = details['duration_days'] as int? ?? 0;
        if (duration > 14) return 'moderate';
        return 'mild';

      case 'stomach_pain':
        final intensity = details['intensity'] as int? ?? 1;
        if (intensity >= 8) return 'severe';
        if (intensity >= 5) return 'moderate';
        return 'mild';

      case 'breathing_difficulty':
        final intensity = details['intensity'] as int? ?? 1;
        if (intensity >= 7) return 'severe';
        if (intensity >= 4) return 'moderate';
        return 'mild';

      default:
        return 'mild';
    }
  }

  List<String> _getGenericAdvice(String language) {
    final advice = {
      'en': [
        'Monitor symptoms closely',
        'Rest and stay hydrated',
        'Consult a healthcare provider if symptoms worsen',
      ],
      'hi': [
        'लक्षणों की बारीकी से निगरानी करें',
        'आराम करें और हाइड्रेटेड रहें',
        'यदि लक्षण बिगड़ते हैं तो स्वास्थ्य सेवा प्रदाता से सलाह लें',
      ],
      'bn': [
        'লক্ষণগুলি নিবিড়ভাবে পর্যবেক্ষণ করুন',
        'বিশ্রাম নিন এবং পানি পান করুন',
        'লক্ষণগুলি খারাপ হলে স্বাস্থ্যসেবা প্রদানকারীর সাথে পরামর্শ করুন',
      ],
    };

    return advice[language] ?? advice['en']!;
  }

  List<String> _getNextSteps(String severity, String language) {
    final steps = {
      'mild': {
        'en': [
          'Monitor symptoms',
          'Self-care measures',
          'Follow up if no improvement',
        ],
        'hi': [
          'लक्षणों की निगरानी करें',
          'स्व-देखभाल के उपाय',
          'सुधार नहीं होने पर फॉलो अप करें',
        ],
        'bn': [
          'লক্ষণ পর্যবেক্ষণ করুন',
          'স্ব-যত্নের ব্যবস্থা',
          'উন্নতি না হলে ফলো আপ করুন',
        ],
      },
      'moderate': {
        'en': [
          'Schedule medical appointment',
          'Continue monitoring',
          'Prepare for consultation',
        ],
        'hi': [
          'चिकित्सा अपॉइंटमेंट शेड्यूल करें',
          'निगरानी जारी रखें',
          'परामर्शेर लिए तैयार हों',
        ],
        'bn': [
          'চিকিৎসা অ্যাপয়েন্টমেন্ট নির্ধারণ করুন',
          'পর্যবেক্ষণ অব্যাহত রাখুন',
          'পরামর্শের জন্য প্রস্তুত হন',
        ],
      },
      'severe': {
        'en': [
          'Seek immediate medical attention',
          'Go to emergency room',
          'Call for emergency help',
        ],
        'hi': [
          'तुरंत चिकित्सा सहायता लें',
          'आपातकालीन कक्ष में जाएं',
          'आपातकालीन सहायता के लिए कॉल करें',
        ],
        'bn': [
          'অবিলম্বে চিকিৎসা সহায়তা নিন',
          'জরুরি কক্ষে যান',
          'জরুরি সাহায্যের জন্য কল করুন',
        ],
      },
    };

    return steps[severity]?[language] ?? steps['mild']!['en']!;
  }

  List<String> _getWhenToSeekHelp(String severity, String language) {
    final helpCriteria = {
      'en': [
        'Symptoms worsen or don\'t improve',
        'New concerning symptoms appear',
        'You feel worried about your condition',
        'Symptoms interfere with daily activities',
      ],
      'hi': [
        'लक्षण बिगड़ते हैं या सुधार नहीं होते',
        'नए चिंताजनक लक्षण दिखाई देते हैं',
        'आप अपनी स्थिति के बारे में चिंतित महसूस करते हैं',
        'लक्षण दैनिक गतिविधियों में हस्तक्षेप करते हैं',
      ],
      'bn': [
        'লক্ষণগুলি খারাপ হয় বা উন্নতি হয় না',
        'নতুন উদ্বেগজনক লক্ষণ দেখা দেয়',
        'আপনি আপনার অবস্থা নিয়ে উদ্বিগ্ন বোধ করেন',
        'লক্ষণগুলি দৈনন্দিন কার্যক্রমে হস্তক্ষেপ করে',
      ],
    };

    return helpCriteria[language] ?? helpCriteria['en']!;
  }

  Map<String, dynamic> _getDefaultResponse(String language) {
    final defaultResponses = {
      'en': {
        'severity': 'mild',
        'recommendations': [
          'Monitor your symptoms',
          'Rest and stay hydrated',
          'Consult a healthcare provider if symptoms persist',
        ],
        'message':
            'Please monitor your symptoms and seek medical advice if they worsen.',
      },
      'hi': {
        'severity': 'mild',
        'recommendations': [
          'अपने लक्षणों की निगरानी करें',
          'आराम करें और हाइड्रेटेड रहें',
          'यदि लक्षण बने रहते हैं तो स्वास्थ्य सेवा प्रदानकारी से सलाह लें',
        ],
        'message':
            'कृपया अपने लक्षणों की निगरानी करें एवं यदि वे बिगड़ते हैं तो चिकित्सा सलाह लें।',
      },
      'bn': {
        'severity': 'mild',
        'recommendations': [
          'আপনার লক্ষণগুলি পর্যবেক্ষণ করুন',
          'বিশ্রাম নিন এবং পানি পান করুন',
          'লক্ষণগুলি অব্যাহত থাকলে স্বাস্থ্যসেবা প্রদানকারীর সাথে পরামর্শ করুন',
        ],
        'message':
            'অনুগ্রহ করে আপনার লক্ষণগুলি পর্যবেক্ষণ করুন এবং সেগুলি খারাপ হলে চিকিৎসা পরামর্শ নিন।',
      },
    };

    return {
      ...defaultResponses[language] ?? defaultResponses['en']!,
      'requiresUrgentCare': false,
      'offline_check': true,
      'next_steps': _getNextSteps('mild', language),
    };
  }

  // Get symptom history for a patient
  Future<List<dynamic>> getSymptomHistory(String patientId) async {
    return await _db.getPatientSymptomHistory(patientId);
  }

  // Get available languages
  List<String> getAvailableLanguages() {
    return ['en', 'hi', 'bn']; // English, Hindi, Bengali
  }

  // Get language display names
  Map<String, String> getLanguageNames() {
    return {'en': 'English', 'hi': 'हिन्दी (Hindi)', 'bn': 'বাংলা (Bengali)'};
  }

  // Check if a symptom needs immediate attention
  bool isUrgentSymptom(String symptom) {
    return _checkForEmergencyKeywords([symptom]);
  }

  // Get offline symptom check statistics
  Future<Map<String, dynamic>> getOfflineStats() async {
    // Get actual patient ID instead of using empty string
    String patientId = '';
    try {
      // Try to get user data from PhoneAuthService first
      final userData = await PhoneAuthService.getStoredUserData();
      if (userData != null) {
        patientId = userData['id'] ?? '';
      } else {
        // Fallback to AuthService instance method
        final authService = AuthService();
        final currentUser = await authService.getCurrentUser();
        patientId = currentUser?.id ?? '';
      }
    } catch (e) {
      print('Error getting user data: $e');
      patientId = '';
    }

    final allChecks = patientId.isNotEmpty
        ? await _db.getPatientSymptomHistory(patientId)
        : await _db.getPatientSymptomHistory('');

    final stats = <String, dynamic>{
      'total_checks': allChecks.length,
      'urgent_cases': allChecks
          .where((check) => check.requiresUrgentCare)
          .length,
      'languages_used': <String, int>{},
      'common_symptoms': <String, int>{},
    };

    for (final check in allChecks) {
      // Count language usage
      final lang = check.language;
      stats['languages_used'][lang] = (stats['languages_used'][lang] ?? 0) + 1;

      // Count symptoms (simplified)
      final symptoms = jsonDecode(check.symptoms) as List<dynamic>;
      for (final symptom in symptoms) {
        final symptomStr = symptom.toString().toLowerCase();
        stats['common_symptoms'][symptomStr] =
            (stats['common_symptoms'][symptomStr] ?? 0) + 1;
      }
    }

    return stats;
  }
}
