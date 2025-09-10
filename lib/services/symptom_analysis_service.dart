import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/symptom_analysis.dart';
import '../models/medical_record.dart';

class SymptomAnalysisService {
  // API endpoint for symptom analysis
  static const String _baseUrl = 'http://localhost:5000'; // Flask API URL

  /// Analyzes symptoms and returns recommendations
  Future<SymptomAnalysis> analyzeSymptoms(String symptomsText) async {
    try {
      // Parse symptoms from text
      List<String> symptoms = _parseSymptoms(symptomsText);

      // Make API request
      final response = await http.post(
        Uri.parse('$_baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'symptoms': symptoms}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return SymptomAnalysis(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          patientId: 'default_patient',
          symptomsText: symptomsText,
          language: 'en',
          conditions: [
            MedicalCondition(
              name: data['disease'],
              confidence: 0.9,
              description: data['description'],
              severity: 'medium',
            ),
          ],
          urgencyLevel: 'medium',
          recommendedSpecialist: 'General Medicine',
          confidenceScore: 0.9,
          analysisTimestamp: DateTime.now(),
          disease: data['disease'],
          description: data['description'],
          precautions: List<String>.from(data['precautions']),
          medications: List<String>.from(data['medications']),
          diets: List<String>.from(data['diets']),
        );
      } else {
        throw Exception('Failed to analyze symptoms: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to simulated response if API fails
      return _getSimulatedPrediction(symptomsText);
    }
  }

  /// Parses symptoms from user text input
  List<String> _parseSymptoms(String text) {
    // This is a simple implementation - in a real app you might use NLP
    // to extract medical terms from the text

    // Convert to lowercase and split by common delimiters
    List<String> words = text.toLowerCase().split(RegExp(r'[,.\\s]+'));

    // Filter out common non-symptom words (this is a simplified approach)
    Set<String> nonSymptoms = {
      'and',
      'or',
      'but',
      'the',
      'a',
      'an',
      'have',
      'has',
      'had',
      'am',
      'is',
      'are',
      'was',
      'were',
      'be',
      'been',
      'being',
      'do',
      'does',
      'did',
      'will',
      'would',
      'could',
      'should',
      'may',
      'might',
      'must',
      'can',
      'i',
      'you',
      'he',
      'she',
      'it',
      'we',
      'they',
      'my',
      'your',
      'his',
      'her',
      'its',
      'our',
      'their',
      'myself',
      'yourself',
      'himself',
      'herself',
      'itself',
      'ourselves',
      'yourselves',
      'themselves',
      'this',
      'that',
      'these',
      'those',
      'for',
      'with',
      'from',
      'to',
      'in',
      'on',
      'at',
      'by',
      'about',
      'into',
      'through',
      'during',
      'before',
      'after',
      'above',
      'below',
      'up',
      'down',
      'out',
      'off',
      'over',
      'under',
      'again',
      'further',
      'then',
      'once',
      'here',
      'there',
      'when',
      'where',
      'why',
      'how',
      'all',
      'any',
      'both',
      'each',
      'few',
      'more',
      'most',
      'other',
      'some',
      'such',
      'no',
      'nor',
      'not',
      'only',
      'own',
      'same',
      'so',
      'than',
      'too',
      'very',
      'just',
      'now',
    };

    // Known symptoms from our dataset
    Set<String> knownSymptoms = {
      // Existing symptoms
      'itching',
      'skin_rash',
      'nodal_skin_eruptions',
      'continuous_sneezing',
      'shivering',
      'chills',
      'joint_pain',
      'stomach_pain',
      'acidity',
      'ulcers_on_tongue',
      'muscle_wasting',
      'vomiting',
      'burning_micturition',
      'spotting_urination',
      'fatigue',
      'weight_gain',
      'anxiety',
      'cold_hands_and_feets',
      'mood_swings',
      'weight_loss',
      'restlessness',
      'lethargy',
      'patches_in_throat',
      'irregular_sugar_level',
      'cough',
      'high_fever',
      'sunken_eyes',
      'breathlessness',
      'sweating',
      'dehydration',
      'indigestion',
      'headache',
      'yellowish_skin',
      'dark_urine',
      'nausea',
      'loss_of_appetite',
      'pain_behind_the_eyes',
      'back_pain',
      'constipation',
      'abdominal_pain',
      'diarrhoea',
      'mild_fever',
      'yellow_urine',
      'yellowing_of_eyes',
      'acute_liver_failure',
      'fluid_overload',
      'swelling_of_stomach',
      'swelled_lymph_nodes',
      'malaise',
      'blurred_and_distorted_vision',
      'phlegm',
      'throat_irritation',
      'redness_of_eyes',
      'sinus_pressure',
      'runny_nose',
      'congestion',
      'chest_pain',
      'weakness_in_limbs',
      'fast_heart_rate',
      'pain_during_bowel_movements',
      'pain_in_anal_region',
      'bloody_stool',
      'irritation_in_anus',
      'neck_pain',
      'dizziness',
      'cramps',
      'bruising',
      'obesity',
      'swollen_legs',
      'swollen_blood_vessels',
      'puffy_face_and_eyes',
      'enlarged_thyroid',
      'brittle_nails',
      'swollen_extremeties',
      'excessive_hunger',
      'extra_marital_contacts',
      'drying_and_tingling_lips',
      'slurred_speech',
      'knee_pain',
      'hip_joint_pain',
      'muscle_weakness',
      'stiff_neck',
      'swelling_joints',
      'movement_stiffness',
      'spinning_movements',
      'loss_of_balance',
      'unsteadiness',
      'weakness_of_one_body_side',
      'loss_of_smell',
      'bladder_discomfort',
      'foul_smell_of_urine',
      'continuous_feel_of_urine',
      'passage_of_gases',
      'internal_itching',
      'toxic_look_(typhos)',
      'depression',
      'irritability',
      'muscle_pain',
      'altered_sensorium',
      'red_spots_over_body',
      'belly_pain',
      'abnormal_menstruation',
      'dischromic_patches',
      'watering_from_eyes',
      'increased_appetite',
      'polyuria',
      'family_history',
      'mucoid_sputum',
      'rusty_sputum',
      'lack_of_concentration',
      'visual_disturbances',
      'receiving_blood_transfusion',
      'receiving_unsterile_injections',
      'coma',
      'stomach_bleeding',
      'distention_of_abdomen',
      'history_of_alcohol_consumption',
      'fluid_overload.1',
      'blood_in_sputum',
      'prominent_veins_on_calf',
      'palpitations',
      'painful_walking',
      'pus_filled_pimples',
      'blackheads',
      'scurring',
      'skin_peeling',
      'silver_like_dusting',
      'small_dents_in_nails',
      'inflammatory_nails',
      'blister',
      'red_sore_around_nose',
      'yellow_crust_ooze',

      // Additional common symptoms for better accuracy
      'fever',
      'sore_throat',
      'runny_nose',
      'sneezing',
      'watery_eyes',
      'body_aches',
      'chills',
      'fatigue',
      'weakness',
      'loss_of_energy',
      'shortness_of_breath',
      'wheezing',
      'chest_tightness',
      'rapid_breathing',
      'rapid_heartbeat',
      'dizziness',
      'lightheadedness',
      'fainting',
      'nausea',
      'vomiting',
      'diarrhea',
      'stomach_cramps',
      'bloating',
      'gas',
      'loss_of_appetite',
      'weight_loss',
      'weight_gain',
      'increased_thirst',
      'frequent_urination',
      'blurry_vision',
      'headaches',
      'confusion',
      'irritability',
      'mood_changes',
      'difficulty_sleeping',
      'sleep_disturbances',
      'night_sweats',
      'excessive_sweating',
      'dry_skin',
      'itchy_skin',
      'rash',
      'hives',
      'swelling',
      'joint_swelling',
      'muscle_aches',
      'stiffness',
      'numbness',
      'tingling',
      'pins_and_needles',
      'memory_problems',
      'difficulty_concentrating',
      'forgetfulness',
      'anxiety',
      'depression',
      'restlessness',
      'agitation',
      'hallucinations',
      'delusions',
      'paranoia',
      'seizures',
      'convulsions',
      'tremors',
      'shaking',
      'loss_of_coordination',
      'balance_problems',
      'slurred_speech',
      'difficulty_speaking',
      'difficulty_swallowing',
      'drooping_eyelid',
      'double_vision',
      'sensitivity_to_light',
      'ear_pain',
      'ear_discharge',
      'hearing_loss',
      'ringing_in_ears',
      'toothache',
      'bleeding_gums',
      'sore_gums',
      'bad_breath',
      'mouth_sores',
      'difficulty_chewing',
      'difficulty_opening_mouth',
      'lump_in_throat',
      'hoarse_voice',
      'loss_of_voice',
      'difficulty_swallowing',
      'heartburn',
      'acid_reflux',
      'belching',
      'bitter_taste',
      'loss_of_taste',
      'loss_of_smell',
      'nasal_congestion',
      'nosebleeds',
      'sinus_pain',
      'facial_pain',
      'coughing_up_blood',
      'coughing_up_mucus',
      'chronic_cough',
      'wheezing',
      'chest_pain',
      'palpitations',
      'irregular_heartbeat',
      'high_blood_pressure',
      'low_blood_pressure',
      'cold_extremities',
      'blue_tint_to_skin',
      'pale_skin',
      'yellow_skin',
      'bruising',
      'petechiae',
      'bleeding',
      'prolonged_bleeding',
      'heavy_menstrual_bleeding',
      'blood_in_urine',
      'blood_in_stool',
      'black_stool',
      'constipation',
      'frequent_bowel_movements',
      'urgent_bowel_movements',
      'incomplete_bowel_emptying',
      'abdominal_bloating',
      'abdominal_cramping',
      'abdominal_tenderness',
      'pelvic_pain',
      'lower_back_pain',
      'painful_urination',
      'increased_urination',
      'urgent_urination',
      'incomplete_bladder_emptying',
      'bedwetting',
      'incontinence',
      'painful_intercourse',
      'vaginal_discharge',
      'vaginal_itching',
      'vaginal_bleeding',
      'testicular_pain',
      'scrotal_swelling',
      'penile_discharge',
      'erectile_dysfunction',
      'breast_lumps',
      'breast_pain',
      'nipple_discharge',
      'joint_pain',
      'joint_stiffness',
      'joint_swelling',
      'muscle_weakness',
      'muscle_cramps',
      'muscle_spasms',
      'neck_pain',
      'shoulder_pain',
      'arm_pain',
      'leg_pain',
      'hip_pain',
      'knee_pain',
      'ankle_pain',
      'foot_pain',
      'hand_pain',
      'wrist_pain',
      'elbow_pain',
      'back_pain',
      'lower_back_pain',
      'upper_back_pain',
      'bone_pain',
      'bone_tenderness',
      'fractures',
      'deformity',
      'limited_movement',
      'instability',
      'locking_joint',
      'clicking_joint',
      'grinding_joint',
      'hair_loss',
      'excessive_hair_growth',
      'acne',
      'oily_skin',
      'dry_skin',
      'flaky_skin',
      'peeling_skin',
      'itchy_scalp',
      'dandruff',
      'brittle_nails',
      'discolored_nails',
      'pitted_nails',
      'thickened_nails',
      'nail_separation',
      'nail_infection',
      'cold_sores',
      'fever_blisters',
      'genital_sores',
      'genital_warts',
      'itchy_eyes',
      'watery_eyes',
      'red_eyes',
      'swollen_eyes',
      'eye_pain',
      'eye_discharge',
      'blurred_vision',
      'double_vision',
      'loss_of_vision',
      'floaters',
      'flashes_of_light',
      'tunnel_vision',
      'sensitivity_to_light',
      'dry_eyes',
      'itchy_eyes',
      'burning_eyes',
      'gritty_eyes',
      'heavy_eyes',
      'droopy_eyelid',
      'crossed_eyes',
      'misaligned_eyes',
      'bulging_eyes',
      'sunken_eyes',
      'yellow_eyes',
      'red_eyes',
      'pink_eye',
      'swollen_eyelids',
      'drooping_mouth',
      'facial_drooping',
      'facial_pain',
      'facial_swelling',
      'facial_twitching',
      'numb_face',
      'tingling_face',
      'headache',
      'migraine',
      'tension_headache',
      'cluster_headache',
      'sinus_headache',
      'throbbing_headache',
      'pounding_headache',
      'sharp_headache',
      'dull_headache',
      'chronic_headache',
      'rebound_headache',
      'exercise_headache',
      'cough_headache',
      'sex_headache',
      'thunderclap_headache',
    };

    // Find matching symptoms
    List<String> foundSymptoms = [];

    // Create a map for symptom variations to standard symptom names
    Map<String, String> symptomVariations = {
      'fever': 'fever',
      'temperature': 'fever',
      'hot': 'fever',
      'sore throat': 'sore_throat',
      'throat pain': 'sore_throat',
      'runny nose': 'runny_nose',
      'stuffy nose': 'congestion',
      'blocked nose': 'congestion',
      'coughing': 'cough',
      'head ache': 'headache',
      'head aches': 'headache',
      'migraine': 'headache',
      'stomach ache': 'stomach_pain',
      'belly ache': 'abdominal_pain',
      'tummy ache': 'abdominal_pain',
      'belly pain': 'abdominal_pain',
      'tummy pain': 'abdominal_pain',
      'throwing up': 'vomiting',
      'throw up': 'vomiting',
      'puke': 'vomiting',
      'can\'t breathe': 'breathlessness',
      'short of breath': 'breathlessness',
      'out of breath': 'breathlessness',
      'wheezing': 'breathlessness',
      'gas': 'passage_of_gases',
      'bloating': 'abdominal_pain',
      'dizzy': 'dizziness',
      'lightheaded': 'dizziness',
      'tired': 'fatigue',
      'exhausted': 'fatigue',
      'sleepy': 'fatigue',
      'joint ache': 'joint_pain',
      'arthritis': 'joint_pain',
      'muscle ache': 'muscle_pain',
      'body ache': 'muscle_pain',
      'body aches': 'muscle_pain',
      'aching muscles': 'muscle_pain',
      'skin irritation': 'itching',
      'itchy': 'itching',
      'rash': 'skin_rash',
      'hives': 'skin_rash',
      'diarrhea': 'diarrhoea',
      'loose motions': 'diarrhoea',
      'loose stools': 'diarrhoea',
      'constipated': 'constipation',
      'can\'t poop': 'constipation',
      'blurry vision': 'blurred_and_distorted_vision',
      'double vision': 'blurred_and_distorted_vision',
      'difficulty seeing': 'blurred_and_distorted_vision',
      'watery eyes': 'watering_from_eyes',
      'teary eyes': 'watering_from_eyes',
      'red eyes': 'redness_of_eyes',
      'pink eye': 'redness_of_eyes',
      'chest ache': 'chest_pain',
      'chest discomfort': 'chest_pain',
      'heart pain': 'chest_pain',
      'palpitations': 'fast_heart_rate',
      'rapid heartbeat': 'fast_heart_rate',
      'skipped beats': 'fast_heart_rate',
      'anxious': 'anxiety',
      'nervous': 'anxiety',
      'worried': 'anxiety',
      'depressed': 'depression',
      'sad': 'depression',
      'low mood': 'depression',
      'mood swings': 'mood_swings',
      'irritable': 'irritability',
      'easily annoyed': 'irritability',
      'frustrated': 'irritability',
      'nauseous': 'nausea',
      'queasy': 'nausea',
      'stomach upset': 'nausea',
      'loss of appetite': 'loss_of_appetite',
      'don\'t want to eat': 'loss_of_appetite',
      'no appetite': 'loss_of_appetite',
      'back ache': 'back_pain',
      'backache': 'back_pain',
      'lower back pain': 'back_pain',
      'knee ache': 'knee_pain',
      'knee hurt': 'knee_pain',
      'hip pain': 'hip_joint_pain',
      'hip ache': 'hip_joint_pain',
      'neck ache': 'neck_pain',
      'stiff neck': 'stiff_neck',
      'stiff joints': 'stiff_neck',
      'swollen joints': 'swelling_joints',
      'puffy joints': 'swelling_joints',
      'weakness': 'weakness_in_limbs',
      'weak limbs': 'weakness_in_limbs',
      'tingling': 'drying_and_tingling_lips',
      'pins and needles': 'drying_and_tingling_lips',
      'numbness': 'drying_and_tingling_lips',
      'difficulty speaking': 'slurred_speech',
      'slurred talk': 'slurred_speech',
      'trouble talking': 'slurred_speech',
    };

    // Check for multi-word symptoms first
    String textLower = text.toLowerCase();

    // Check for known multi-word symptom variations
    symptomVariations.forEach((variation, standardSymptom) {
      if (textLower.contains(variation) &&
          knownSymptoms.contains(standardSymptom)) {
        if (!foundSymptoms.contains(standardSymptom)) {
          foundSymptoms.add(standardSymptom);
        }
      }
    });

    // Then check individual words
    for (String word in words) {
      // Handle some special cases for symptom matching
      String symptom = word.replaceAll(' ', '_');

      // Check if the word directly matches a known symptom
      if (knownSymptoms.contains(symptom)) {
        if (!foundSymptoms.contains(symptom)) {
          foundSymptoms.add(symptom);
        }
      }

      // Check if the word has a variation that maps to a known symptom
      if (symptomVariations.containsKey(symptom) &&
          knownSymptoms.contains(symptomVariations[symptom]!)) {
        String standardSymptom = symptomVariations[symptom]!;
        if (!foundSymptoms.contains(standardSymptom)) {
          foundSymptoms.add(standardSymptom);
        }
      }
    }

    // If no symptoms found, try to extract at least one common symptom based on keywords
    if (foundSymptoms.isEmpty) {
      // Check for general keywords that might indicate common conditions
      if (text.toLowerCase().contains('cold') ||
          text.toLowerCase().contains('flu')) {
        foundSymptoms.add('cough');
        foundSymptoms.add('fever');
      } else if (text.toLowerCase().contains('stomach') ||
          text.toLowerCase().contains('tummy')) {
        foundSymptoms.add('stomach_pain');
      } else if (text.toLowerCase().contains('back')) {
        foundSymptoms.add('back_pain');
      } else if (text.toLowerCase().contains('head')) {
        foundSymptoms.add('headache');
      } else {
        // Default to a common symptom
        foundSymptoms.add('fatigue');
      }
    }

    return foundSymptoms;
  }

  /// Gets simulated prediction as fallback
  Future<SymptomAnalysis> _getSimulatedPrediction(String symptomsText) async {
    // This is a simulation - in a real implementation, you would call your ML model
    // For demonstration, we'll return a sample response based on common symptom combinations

    // Parse symptoms from text
    List<String> symptoms = _parseSymptoms(symptomsText);

    String disease = "Common Cold";
    String description =
        "Common Cold is a viral infection of the upper respiratory tract.";
    List<String> precautions = [
      "drink vitamin c rich drinks",
      "take vapour",
      "avoid cold food",
      "keep fever in check",
    ];
    List<String> medications = [
      "Antibiotics",
      "Antiviral drugs",
      "Antifungal drugs",
      "IV fluids",
      "Oxygen therapy",
    ];
    List<String> diets = [
      "Hydration",
      "Warm fluids",
      "Rest",
      "Honey and lemon tea",
    ];

    // Improved logic to determine disease based on symptoms
    // Count symptom matches for better accuracy

    // Allergy-related conditions
    if ((symptoms.contains('itching') ||
            symptoms.contains('skin_rash') ||
            symptoms.contains('rash')) &&
        (symptoms.contains('continuous_sneezing') ||
            symptoms.contains('sneezing')) &&
        (symptoms.contains('runny_nose') || symptoms.contains('watery_eyes'))) {
      disease = "Allergic Rhinitis";
      description =
          "Allergic rhinitis is an allergic response to specific allergens like pollen, dust mites, or pet dander.";
      precautions = [
        "identify and avoid allergens",
        "keep windows closed during high pollen days",
        "use air purifiers",
        "wash hands and face frequently",
      ];
      medications = [
        "Antihistamines",
        "Decongestants",
        "Nasal corticosteroids",
        "Mast cell stabilizers",
        "Leukotriene modifiers",
      ];
      diets = [
        "Anti-inflammatory diet",
        "Local honey",
        "Omega-3 rich foods",
        "Probiotics",
        "Vitamin C rich foods",
      ];
    }
    // Fungal infection
    else if (symptoms.contains('itching') && symptoms.contains('skin_rash')) {
      disease = "Fungal infection";
      description =
          "Fungal infection is a common skin condition caused by fungi.";
      precautions = [
        "bath twice",
        "use detol or neem in bathing water",
        "keep infected area dry",
        "use clean cloths",
      ];
      medications = [
        "Antifungal Cream",
        "Fluconazole",
        "Terbinafine",
        "Clotrimazole",
        "Ketoconazole",
      ];
      diets = [
        "Antifungal Diet",
        "Probiotics",
        "Garlic",
        "Coconut oil",
        "Turmeric",
      ];
    }
    // Gastroenteritis
    else if (symptoms.contains('vomiting') &&
        symptoms.contains('sunken_eyes') &&
        symptoms.contains('dehydration') &&
        symptoms.contains('diarrhoea')) {
      disease = "Gastroenteritis";
      description =
          "Gastroenteritis is an inflammation of the stomach and intestines, typically caused by a virus or bacteria.";
      precautions = [
        "stop eating solid food for while",
        "try taking small sips of water",
        "rest",
        "ease back into eating",
      ];
      medications = [
        "Antibiotics",
        "Antiemetic drugs",
        "Antidiarrheal drugs",
        "IV fluids",
        "Probiotics",
      ];
      diets = ["Bland Diet", "Bananas", "Rice", "Applesauce", "Toast"];
    }
    // Hypertension
    else if (symptoms.contains('headache') &&
        symptoms.contains('chest_pain') &&
        symptoms.contains('dizziness') &&
        symptoms.contains('loss_of_balance')) {
      disease = "Hypertension";
      description =
          "Hypertension, or high blood pressure, is a common cardiovascular condition.";
      precautions = [
        "meditation",
        "salt baths",
        "reduce stress",
        "get proper sleep",
      ];
      medications = [
        "Antihypertensive medications",
        "Diuretics",
        "Beta-blockers",
        "ACE inhibitors",
        "Calcium channel blockers",
      ];
      diets = [
        "DASH Diet",
        "Low-sodium foods",
        "Fruits and vegetables",
        "Whole grains",
        "Lean proteins",
      ];
    }
    // Bronchial Asthma
    else if (symptoms.contains('cough') &&
        symptoms.contains('high_fever') &&
        symptoms.contains('breathlessness')) {
      disease = "Bronchial Asthma";
      description =
          "Bronchial Asthma is a respiratory condition characterized by inflammation of the airways.";
      precautions = [
        "switch to loose cloothing",
        "take deep breaths",
        "get away from trigger",
        "seek help",
      ];
      medications = [
        "Bronchodilators",
        "Inhaled corticosteroids",
        "Leukotriene modifiers",
        "Mast cell stabilizers",
        "Anticholinergics",
      ];
      diets = [
        "Anti-Inflammatory Diet",
        "Omega-3-rich foods",
        "Fruits and vegetables",
        "Whole grains",
        "Lean proteins",
      ];
    }
    // Migraine
    else if (symptoms.contains('headache') &&
        symptoms.contains('blurred_and_distorted_vision') &&
        symptoms.contains('excessive_hunger')) {
      disease = "Migraine";
      description =
          "Migraine is a type of headache that often involves severe pain and sensitivity to light and sound.";
      precautions = [
        "meditation",
        "reduce stress",
        "use poloroid glasses in sun",
        "consult doctor",
      ];
      medications = [
        "Analgesics",
        "Triptans",
        "Ergotamine derivatives",
        "Preventive medications",
        "Biofeedback",
      ];
      diets = [
        "Migraine Diet",
        "Low-Tyramine Diet",
        "Caffeine withdrawal",
        "Hydration",
        "Magnesium-rich foods",
      ];
    }
    // Influenza (Flu)
    else if ((symptoms.contains('fever') ||
            symptoms.contains('high_fever') ||
            symptoms.contains('mild_fever')) &&
        (symptoms.contains('cough') || symptoms.contains('sore_throat')) &&
        (symptoms.contains('body_aches') ||
            symptoms.contains('muscle_pain') ||
            symptoms.contains('joint_pain')) &&
        symptoms.contains('fatigue')) {
      disease = "Influenza (Flu)";
      description =
          "Influenza is a viral infection that attacks your respiratory system — your nose, throat and lungs.";
      precautions = [
        "get annual flu vaccination",
        "avoid close contact with sick people",
        "cover your mouth when coughing or sneezing",
        "wash hands frequently",
      ];
      medications = [
        "Antiviral drugs",
        "Pain relievers",
        "Cough suppressants",
        "Decongestants",
        "Throat lozenges",
      ];
      diets = [
        "Hydration",
        "Chicken soup",
        "Vitamin C rich foods",
        "Zinc supplements",
        "Probiotics",
      ];
    }
    // COVID-19
    else if ((symptoms.contains('fever') ||
            symptoms.contains('high_fever') ||
            symptoms.contains('mild_fever')) &&
        (symptoms.contains('cough') || symptoms.contains('sore_throat')) &&
        (symptoms.contains('breathlessness') ||
            symptoms.contains('shortness_of_breath')) &&
        (symptoms.contains('loss_of_taste') ||
            symptoms.contains('loss_of_smell'))) {
      disease = "COVID-19";
      description =
          "Coronavirus disease 2019 (COVID-19) is a contagious disease caused by severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2).";
      precautions = [
        "get vaccinated",
        "wear masks in public",
        "maintain social distancing",
        "wash hands frequently",
      ];
      medications = [
        "Antiviral drugs",
        "Monoclonal antibodies",
        "Corticosteroids",
        "Oxygen therapy",
        "Pain relievers",
      ];
      diets = [
        "Hydration",
        "Nutritious foods",
        "Vitamin D supplements",
        "Zinc supplements",
        "Probiotics",
      ];
    }
    // Pneumonia
    else if ((symptoms.contains('cough') || symptoms.contains('phlegm')) &&
        (symptoms.contains('fever') || symptoms.contains('high_fever')) &&
        (symptoms.contains('breathlessness') ||
            symptoms.contains('shortness_of_breath')) &&
        (symptoms.contains('chest_pain'))) {
      disease = "Pneumonia";
      description =
          "Pneumonia is an infection that inflames the air sacs in one or both lungs, which may fill with fluid.";
      precautions = [
        "get vaccinated against pneumonia",
        "avoid smoking",
        "maintain good hygiene",
        "strengthen your immune system",
      ];
      medications = [
        "Antibiotics",
        "Antiviral drugs",
        "Antifungal drugs",
        "Cough suppressants",
        "Fever reducers",
      ];
      diets = [
        "Hydration",
        "Nutritious foods",
        "Vitamin C rich foods",
        "Protein-rich foods",
        "Easy-to-digest foods",
      ];
    }
    // Diabetes
    else if ((symptoms.contains('increased_thirst') ||
            symptoms.contains('excessive_hunger')) &&
        (symptoms.contains('frequent_urination') ||
            symptoms.contains('polyuria')) &&
        (symptoms.contains('blurred_and_distorted_vision') ||
            symptoms.contains('blurry_vision')) &&
        symptoms.contains('fatigue')) {
      disease = "Diabetes";
      description =
          "Diabetes is a disease that occurs when your blood glucose, also called blood sugar, is too high.";
      precautions = [
        "monitor blood sugar levels",
        "maintain a healthy diet",
        "exercise regularly",
        "maintain healthy weight",
      ];
      medications = [
        "Insulin",
        "Metformin",
        "Sulfonylureas",
        "Meglitinides",
        "Thiazolidinediones",
      ];
      diets = [
        "Low-carb diet",
        "High-fiber foods",
        "Lean proteins",
        "Healthy fats",
        "Non-starchy vegetables",
      ];
    }
    // Dengue
    else if ((symptoms.contains('fever') || symptoms.contains('high_fever')) &&
        symptoms.contains('headache') &&
        (symptoms.contains('joint_pain') || symptoms.contains('muscle_pain')) &&
        (symptoms.contains('rash') || symptoms.contains('skin_rash')) &&
        symptoms.contains('nausea')) {
      disease = "Dengue";
      description =
          "Dengue fever is a mosquito-borne viral infection that causes flu-like symptoms and can develop into a potentially lethal complication called severe dengue.";
      precautions = [
        "avoid mosquito bites",
        "eliminate mosquito breeding sites",
        "use mosquito repellents",
        "wear long-sleeved clothing",
      ];
      medications = [
        "Pain relievers",
        "Fever reducers",
        "IV fluids for severe cases",
        "Platelet transfusion if needed",
        "Symptomatic treatment",
      ];
      diets = [
        "Hydration",
        "Papaya leaf juice",
        "Coconut water",
        "Fresh fruit juices",
        "Soft and light foods",
      ];
    }
    // Typhoid
    else if ((symptoms.contains('fever') || symptoms.contains('high_fever')) &&
        symptoms.contains('headache') &&
        (symptoms.contains('abdominal_pain') ||
            symptoms.contains('stomach_pain')) &&
        symptoms.contains('constipation')) {
      disease = "Typhoid";
      description =
          "Typhoid fever is a bacterial infection that can spread throughout the body, affecting many organs. Without prompt treatment, it can cause serious complications and can be fatal.";
      precautions = [
        "get vaccinated",
        "drink bottled or boiled water",
        "eat well-cooked food",
        "maintain good hygiene",
      ];
      medications = [
        "Antibiotics",
        "Fever reducers",
        "IV fluids if dehydrated",
        "Symptomatic treatment",
        "Probiotics after antibiotic treatment",
      ];
      diets = [
        "High-calorie diet",
        "Soft and easily digestible foods",
        "Fluids to prevent dehydration",
        "Avoid high-fiber foods",
        "Avoid spicy foods",
      ];
    }

    // If no specific disease was identified, provide a more tailored response based on predominant symptoms
    if (disease == "Common Cold") {
      // Try to provide a more specific diagnosis based on predominant symptoms
      if (symptoms.contains('fever') ||
          symptoms.contains('high_fever') ||
          symptoms.contains('mild_fever')) {
        if (symptoms.contains('cough') && symptoms.contains('breathlessness')) {
          disease = "Upper Respiratory Infection";
          description =
              "An upper respiratory infection affecting your nose, throat, and airways.";
          precautions = [
            "rest and stay hydrated",
            "use a humidifier",
            "gargle with warm salt water",
            "avoid irritants like smoke",
          ];
          medications = [
            "Pain relievers",
            "Cough suppressants",
            "Decongestants",
            "Throat lozenges",
            "Nasal sprays",
          ];
          diets = [
            "Warm fluids",
            "Chicken soup",
            "Vitamin C rich foods",
            "Honey and lemon tea",
            "Soft foods",
          ];
        } else if (symptoms.contains('sore_throat')) {
          disease = "Viral Pharyngitis";
          description =
              "A viral infection causing inflammation of the throat and surrounding areas.";
          precautions = [
            "gargle with warm salt water",
            "stay hydrated",
            "rest your voice",
            "avoid irritants",
          ];
          medications = [
            "Pain relievers",
            "Throat lozenges",
            "Warm beverages",
            "Humidifier use",
            "Throat sprays",
          ];
          diets = [
            "Warm soothing liquids",
            "Soft foods",
            "Honey",
            "Warm broth",
            "Vitamin C rich foods",
          ];
        } else {
          disease = "Viral Fever";
          description =
              "A fever caused by a viral infection, often accompanied by general body discomfort.";
          precautions = [
            "rest and stay hydrated",
            "keep fever in check",
            "avoid contact with others",
            "maintain good hygiene",
          ];
          medications = [
            "Antipyretics",
            "Pain relievers",
            "Vitamin supplements",
            "Electrolyte solutions",
            "Rest",
          ];
          diets = [
            "Hydration",
            "Light meals",
            "Fresh fruits",
            "Clear soups",
            "Electrolyte drinks",
          ];
        }
      } else if (symptoms.contains('headache') &&
          symptoms.contains('dizziness')) {
        disease = "Tension Headache";
        description =
            "A common type of headache that causes mild to moderate pain and pressure around the forehead, temples, or back of the head and neck.";
        precautions = [
          "manage stress",
          "maintain regular sleep schedule",
          "stay hydrated",
          "take breaks from screens",
        ];
        medications = [
          "Pain relievers",
          "Muscle relaxants",
          "Stress management techniques",
          "Heat or cold therapy",
          "Massage therapy",
        ];
        diets = [
          "Regular meals",
          "Caffeine in moderation",
          "Magnesium-rich foods",
          "Stay hydrated",
          "Avoid skipped meals",
        ];
      } else if (symptoms.contains('stomach_pain') ||
          symptoms.contains('abdominal_pain')) {
        disease = "Gastritis";
        description =
            "Inflammation of the stomach lining which can cause stomach pain and discomfort.";
        precautions = [
          "avoid spicy foods",
          "eat smaller meals",
          "avoid alcohol and smoking",
          "manage stress",
        ];
        medications = [
          "Antacids",
          "Proton pump inhibitors",
          "H2 blockers",
          "Antibiotics if H. pylori is present",
          "Stomach lining protectants",
        ];
        diets = [
          "Bland diet",
          "Small frequent meals",
          "Avoid acidic foods",
          "Probiotics",
          "Ginger tea",
        ];
      } else if (symptoms.contains('joint_pain') &&
          symptoms.contains('muscle_pain')) {
        disease = "Muscle Strain";
        description =
            "Overstretching or tearing of muscles or tendons, often causing pain and stiffness.";
        precautions = [
          "rest the affected area",
          "apply ice for acute injury",
          "avoid repetitive movements",
          "warm up before exercise",
        ];
        medications = [
          "Pain relievers",
          "Anti-inflammatory drugs",
          "Muscle relaxants",
          "Topical analgesics",
          "Heat or cold therapy",
        ];
        diets = [
          "Anti-inflammatory foods",
          "Protein for muscle repair",
          "Vitamin D",
          "Magnesium-rich foods",
          "Omega-3 fatty acids",
        ];
      }
    }

    return SymptomAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: 'default_patient',
      symptomsText: symptomsText,
      language: 'en',
      conditions: [
        MedicalCondition(
          name: disease,
          confidence: symptoms.length > 1 ? 0.85 : 0.7,
          description: description,
          severity: 'medium',
        ),
      ],
      urgencyLevel: 'medium',
      recommendedSpecialist: 'General Medicine',
      confidenceScore: symptoms.length > 1 ? 0.85 : 0.7,
      analysisTimestamp: DateTime.now(),
      isRuleBasedFallback: true,
      disease: disease,
      description: description,
      precautions: precautions,
      medications: medications,
      diets: diets,
    );
  }

  /// Public method for testing symptom parsing
  List<String> parseSymptomsForTesting(String text) {
    return _parseSymptoms(text);
  }

  /// Public method for testing simulated prediction
  Future<SymptomAnalysis> getSimulatedPrediction(String symptomsText) async {
    // This is a simulation - in a real implementation, you would call your ML model
    // For demonstration, we'll return a sample response based on common symptom combinations

    // Parse symptoms from text
    List<String> symptoms = parseSymptomsForTesting(symptomsText);

    String disease = "Common Cold";
    String description =
        "Common Cold is a viral infection of the upper respiratory tract.";
    List<String> precautions = [
      "drink vitamin c rich drinks",
      "take vapour",
      "avoid cold food",
      "keep fever in check",
    ];
    List<String> medications = [
      "Antibiotics",
      "Antiviral drugs",
      "Antifungal drugs",
      "IV fluids",
      "Oxygen therapy",
    ];
    List<String> diets = [
      "Hydration",
      "Warm fluids",
      "Rest",
      "Honey and lemon tea",
    ];

    // Improved logic to determine disease based on symptoms
    // Count symptom matches for better accuracy

    // Allergy-related conditions
    if ((symptoms.contains('itching') ||
            symptoms.contains('skin_rash') ||
            symptoms.contains('rash')) &&
        (symptoms.contains('continuous_sneezing') ||
            symptoms.contains('sneezing')) &&
        (symptoms.contains('runny_nose') || symptoms.contains('watery_eyes'))) {
      disease = "Allergic Rhinitis";
      description =
          "Allergic rhinitis is an allergic response to specific allergens like pollen, dust mites, or pet dander.";
      precautions = [
        "identify and avoid allergens",
        "keep windows closed during high pollen days",
        "use air purifiers",
        "wash hands and face frequently",
      ];
      medications = [
        "Antihistamines",
        "Decongestants",
        "Nasal corticosteroids",
        "Mast cell stabilizers",
        "Leukotriene modifiers",
      ];
      diets = [
        "Anti-inflammatory diet",
        "Local honey",
        "Omega-3 rich foods",
        "Probiotics",
        "Vitamin C rich foods",
      ];
    }
    // Fungal infection
    else if (symptoms.contains('itching') && symptoms.contains('skin_rash')) {
      disease = "Fungal infection";
      description =
          "Fungal infection is a common skin condition caused by fungi.";
      precautions = [
        "bath twice",
        "use detol or neem in bathing water",
        "keep infected area dry",
        "use clean cloths",
      ];
      medications = [
        "Antifungal Cream",
        "Fluconazole",
        "Terbinafine",
        "Clotrimazole",
        "Ketoconazole",
      ];
      diets = [
        "Antifungal Diet",
        "Probiotics",
        "Garlic",
        "Coconut oil",
        "Turmeric",
      ];
    }
    // Gastroenteritis
    else if (symptoms.contains('vomiting') &&
        symptoms.contains('sunken_eyes') &&
        symptoms.contains('dehydration') &&
        symptoms.contains('diarrhoea')) {
      disease = "Gastroenteritis";
      description =
          "Gastroenteritis is an inflammation of the stomach and intestines, typically caused by a virus or bacteria.";
      precautions = [
        "stop eating solid food for while",
        "try taking small sips of water",
        "rest",
        "ease back into eating",
      ];
      medications = [
        "Antibiotics",
        "Antiemetic drugs",
        "Antidiarrheal drugs",
        "IV fluids",
        "Probiotics",
      ];
      diets = ["Bland Diet", "Bananas", "Rice", "Applesauce", "Toast"];
    }
    // Hypertension
    else if (symptoms.contains('headache') &&
        symptoms.contains('chest_pain') &&
        symptoms.contains('dizziness') &&
        symptoms.contains('loss_of_balance')) {
      disease = "Hypertension";
      description =
          "Hypertension, or high blood pressure, is a common cardiovascular condition.";
      precautions = [
        "meditation",
        "salt baths",
        "reduce stress",
        "get proper sleep",
      ];
      medications = [
        "Antihypertensive medications",
        "Diuretics",
        "Beta-blockers",
        "ACE inhibitors",
        "Calcium channel blockers",
      ];
      diets = [
        "DASH Diet",
        "Low-sodium foods",
        "Fruits and vegetables",
        "Whole grains",
        "Lean proteins",
      ];
    }
    // Bronchial Asthma
    else if (symptoms.contains('cough') &&
        symptoms.contains('high_fever') &&
        symptoms.contains('breathlessness')) {
      disease = "Bronchial Asthma";
      description =
          "Bronchial Asthma is a respiratory condition characterized by inflammation of the airways.";
      precautions = [
        "switch to loose cloothing",
        "take deep breaths",
        "get away from trigger",
        "seek help",
      ];
      medications = [
        "Bronchodilators",
        "Inhaled corticosteroids",
        "Leukotriene modifiers",
        "Mast cell stabilizers",
        "Anticholinergics",
      ];
      diets = [
        "Anti-Inflammatory Diet",
        "Omega-3-rich foods",
        "Fruits and vegetables",
        "Whole grains",
        "Lean proteins",
      ];
    }
    // Migraine
    else if (symptoms.contains('headache') &&
        symptoms.contains('blurred_and_distorted_vision') &&
        symptoms.contains('excessive_hunger')) {
      disease = "Migraine";
      description =
          "Migraine is a type of headache that often involves severe pain and sensitivity to light and sound.";
      precautions = [
        "meditation",
        "reduce stress",
        "use poloroid glasses in sun",
        "consult doctor",
      ];
      medications = [
        "Analgesics",
        "Triptans",
        "Ergotamine derivatives",
        "Preventive medications",
        "Biofeedback",
      ];
      diets = [
        "Migraine Diet",
        "Low-Tyramine Diet",
        "Caffeine withdrawal",
        "Hydration",
        "Magnesium-rich foods",
      ];
    }
    // Influenza (Flu)
    else if ((symptoms.contains('fever') ||
            symptoms.contains('high_fever') ||
            symptoms.contains('mild_fever')) &&
        (symptoms.contains('cough') || symptoms.contains('sore_throat')) &&
        (symptoms.contains('body_aches') ||
            symptoms.contains('muscle_pain') ||
            symptoms.contains('joint_pain')) &&
        symptoms.contains('fatigue')) {
      disease = "Influenza (Flu)";
      description =
          "Influenza is a viral infection that attacks your respiratory system — your nose, throat and lungs.";
      precautions = [
        "get annual flu vaccination",
        "avoid close contact with sick people",
        "cover your mouth when coughing or sneezing",
        "wash hands frequently",
      ];
      medications = [
        "Antiviral drugs",
        "Pain relievers",
        "Cough suppressants",
        "Decongestants",
        "Throat lozenges",
      ];
      diets = [
        "Hydration",
        "Chicken soup",
        "Vitamin C rich foods",
        "Zinc supplements",
        "Probiotics",
      ];
    }
    // COVID-19
    else if ((symptoms.contains('fever') ||
            symptoms.contains('high_fever') ||
            symptoms.contains('mild_fever')) &&
        (symptoms.contains('cough') || symptoms.contains('sore_throat')) &&
        (symptoms.contains('breathlessness') ||
            symptoms.contains('shortness_of_breath')) &&
        (symptoms.contains('loss_of_taste') ||
            symptoms.contains('loss_of_smell'))) {
      disease = "COVID-19";
      description =
          "Coronavirus disease 2019 (COVID-19) is a contagious disease caused by severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2).";
      precautions = [
        "get vaccinated",
        "wear masks in public",
        "maintain social distancing",
        "wash hands frequently",
      ];
      medications = [
        "Antiviral drugs",
        "Monoclonal antibodies",
        "Corticosteroids",
        "Oxygen therapy",
        "Pain relievers",
      ];
      diets = [
        "Hydration",
        "Nutritious foods",
        "Vitamin D supplements",
        "Zinc supplements",
        "Probiotics",
      ];
    }
    // Pneumonia
    else if ((symptoms.contains('cough') || symptoms.contains('phlegm')) &&
        (symptoms.contains('fever') || symptoms.contains('high_fever')) &&
        (symptoms.contains('breathlessness') ||
            symptoms.contains('shortness_of_breath')) &&
        (symptoms.contains('chest_pain'))) {
      disease = "Pneumonia";
      description =
          "Pneumonia is an infection that inflames the air sacs in one or both lungs, which may fill with fluid.";
      precautions = [
        "get vaccinated against pneumonia",
        "avoid smoking",
        "maintain good hygiene",
        "strengthen your immune system",
      ];
      medications = [
        "Antibiotics",
        "Antiviral drugs",
        "Antifungal drugs",
        "Cough suppressants",
        "Fever reducers",
      ];
      diets = [
        "Hydration",
        "Nutritious foods",
        "Vitamin C rich foods",
        "Protein-rich foods",
        "Easy-to-digest foods",
      ];
    }
    // Diabetes
    else if ((symptoms.contains('increased_thirst') ||
            symptoms.contains('excessive_hunger')) &&
        (symptoms.contains('frequent_urination') ||
            symptoms.contains('polyuria')) &&
        (symptoms.contains('blurred_and_distorted_vision') ||
            symptoms.contains('blurry_vision')) &&
        symptoms.contains('fatigue')) {
      disease = "Diabetes";
      description =
          "Diabetes is a disease that occurs when your blood glucose, also called blood sugar, is too high.";
      precautions = [
        "monitor blood sugar levels",
        "maintain a healthy diet",
        "exercise regularly",
        "maintain healthy weight",
      ];
      medications = [
        "Insulin",
        "Metformin",
        "Sulfonylureas",
        "Meglitinides",
        "Thiazolidinediones",
      ];
      diets = [
        "Low-carb diet",
        "High-fiber foods",
        "Lean proteins",
        "Healthy fats",
        "Non-starchy vegetables",
      ];
    }
    // Dengue
    else if ((symptoms.contains('fever') || symptoms.contains('high_fever')) &&
        symptoms.contains('headache') &&
        (symptoms.contains('joint_pain') || symptoms.contains('muscle_pain')) &&
        (symptoms.contains('rash') || symptoms.contains('skin_rash')) &&
        symptoms.contains('nausea')) {
      disease = "Dengue";
      description =
          "Dengue fever is a mosquito-borne viral infection that causes flu-like symptoms and can develop into a potentially lethal complication called severe dengue.";
      precautions = [
        "avoid mosquito bites",
        "eliminate mosquito breeding sites",
        "use mosquito repellents",
        "wear long-sleeved clothing",
      ];
      medications = [
        "Pain relievers",
        "Fever reducers",
        "IV fluids for severe cases",
        "Platelet transfusion if needed",
        "Symptomatic treatment",
      ];
      diets = [
        "Hydration",
        "Papaya leaf juice",
        "Coconut water",
        "Fresh fruit juices",
        "Soft and light foods",
      ];
    }
    // Typhoid
    else if ((symptoms.contains('fever') || symptoms.contains('high_fever')) &&
        symptoms.contains('headache') &&
        (symptoms.contains('abdominal_pain') ||
            symptoms.contains('stomach_pain')) &&
        symptoms.contains('constipation')) {
      disease = "Typhoid";
      description =
          "Typhoid fever is a bacterial infection that can spread throughout the body, affecting many organs. Without prompt treatment, it can cause serious complications and can be fatal.";
      precautions = [
        "get vaccinated",
        "drink bottled or boiled water",
        "eat well-cooked food",
        "maintain good hygiene",
      ];
      medications = [
        "Antibiotics",
        "Fever reducers",
        "IV fluids if dehydrated",
        "Symptomatic treatment",
        "Probiotics after antibiotic treatment",
      ];
      diets = [
        "High-calorie diet",
        "Soft and easily digestible foods",
        "Fluids to prevent dehydration",
        "Avoid high-fiber foods",
        "Avoid spicy foods",
      ];
    }

    // If no specific disease was identified, provide a more tailored response based on predominant symptoms
    if (disease == "Common Cold") {
      // Try to provide a more specific diagnosis based on predominant symptoms
      if (symptoms.contains('fever') ||
          symptoms.contains('high_fever') ||
          symptoms.contains('mild_fever')) {
        if (symptoms.contains('cough') && symptoms.contains('breathlessness')) {
          disease = "Upper Respiratory Infection";
          description =
              "An upper respiratory infection affecting your nose, throat, and airways.";
          precautions = [
            "rest and stay hydrated",
            "use a humidifier",
            "gargle with warm salt water",
            "avoid irritants like smoke",
          ];
          medications = [
            "Pain relievers",
            "Cough suppressants",
            "Decongestants",
            "Throat lozenges",
            "Nasal sprays",
          ];
          diets = [
            "Warm fluids",
            "Chicken soup",
            "Vitamin C rich foods",
            "Honey and lemon tea",
            "Soft foods",
          ];
        } else if (symptoms.contains('sore_throat')) {
          disease = "Viral Pharyngitis";
          description =
              "A viral infection causing inflammation of the throat and surrounding areas.";
          precautions = [
            "gargle with warm salt water",
            "stay hydrated",
            "rest your voice",
            "avoid irritants",
          ];
          medications = [
            "Pain relievers",
            "Throat lozenges",
            "Warm beverages",
            "Humidifier use",
            "Throat sprays",
          ];
          diets = [
            "Warm soothing liquids",
            "Soft foods",
            "Honey",
            "Warm broth",
            "Vitamin C rich foods",
          ];
        } else {
          disease = "Viral Fever";
          description =
              "A fever caused by a viral infection, often accompanied by general body discomfort.";
          precautions = [
            "rest and stay hydrated",
            "keep fever in check",
            "avoid contact with others",
            "maintain good hygiene",
          ];
          medications = [
            "Antipyretics",
            "Pain relievers",
            "Vitamin supplements",
            "Electrolyte solutions",
            "Rest",
          ];
          diets = [
            "Hydration",
            "Light meals",
            "Fresh fruits",
            "Clear soups",
            "Electrolyte drinks",
          ];
        }
      } else if (symptoms.contains('headache') &&
          symptoms.contains('dizziness')) {
        disease = "Tension Headache";
        description =
            "A common type of headache that causes mild to moderate pain and pressure around the forehead, temples, or back of the head and neck.";
        precautions = [
          "manage stress",
          "maintain regular sleep schedule",
          "stay hydrated",
          "take breaks from screens",
        ];
        medications = [
          "Pain relievers",
          "Muscle relaxants",
          "Stress management techniques",
          "Heat or cold therapy",
          "Massage therapy",
        ];
        diets = [
          "Regular meals",
          "Caffeine in moderation",
          "Magnesium-rich foods",
          "Stay hydrated",
          "Avoid skipped meals",
        ];
      } else if (symptoms.contains('stomach_pain') ||
          symptoms.contains('abdominal_pain')) {
        disease = "Gastritis";
        description =
            "Inflammation of the stomach lining which can cause stomach pain and discomfort.";
        precautions = [
          "avoid spicy foods",
          "eat smaller meals",
          "avoid alcohol and smoking",
          "manage stress",
        ];
        medications = [
          "Antacids",
          "Proton pump inhibitors",
          "H2 blockers",
          "Antibiotics if H. pylori is present",
          "Stomach lining protectants",
        ];
        diets = [
          "Bland diet",
          "Small frequent meals",
          "Avoid acidic foods",
          "Probiotics",
          "Ginger tea",
        ];
      } else if (symptoms.contains('joint_pain') &&
          symptoms.contains('muscle_pain')) {
        disease = "Muscle Strain";
        description =
            "Overstretching or tearing of muscles or tendons, often causing pain and stiffness.";
        precautions = [
          "rest the affected area",
          "apply ice for acute injury",
          "avoid repetitive movements",
          "warm up before exercise",
        ];
        medications = [
          "Pain relievers",
          "Anti-inflammatory drugs",
          "Muscle relaxants",
          "Topical analgesics",
          "Heat or cold therapy",
        ];
        diets = [
          "Anti-inflammatory foods",
          "Protein for muscle repair",
          "Vitamin D",
          "Magnesium-rich foods",
          "Omega-3 fatty acids",
        ];
      }
    }

    return SymptomAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: 'default_patient',
      symptomsText: symptomsText,
      language: 'en',
      conditions: [
        MedicalCondition(
          name: disease,
          confidence: symptoms.length > 1 ? 0.85 : 0.7,
          description: description,
          severity: 'medium',
        ),
      ],
      urgencyLevel: 'medium',
      recommendedSpecialist: 'General Medicine',
      confidenceScore: symptoms.length > 1 ? 0.85 : 0.7,
      analysisTimestamp: DateTime.now(),
      isRuleBasedFallback: true,
      disease: disease,
      description: description,
      precautions: precautions,
      medications: medications,
      diets: diets,
    );
  }
}
