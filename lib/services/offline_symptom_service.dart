import 'dart:math';
import '../models/symptom_data.dart';

class OfflineSymptomService {
  static final OfflineSymptomService _instance =
      OfflineSymptomService._internal();
  factory OfflineSymptomService() => _instance;
  OfflineSymptomService._internal();

  List<SymptomData> _symptomData = [];

  // Disease-symptom mapping with weights for more accurate predictions
  Map<String, Map<String, double>> _diseaseSymptomWeights = {};

  // Initialize the service with symptom data
  Future<void> initialize() async {
    _symptomData = await SymptomData.loadFromAssets();
    _buildDiseaseSymptomWeights();
  }

  // Build weighted mapping of diseases to symptoms for better predictions
  void _buildDiseaseSymptomWeights() {
    _diseaseSymptomWeights.clear();

    for (var data in _symptomData) {
      _diseaseSymptomWeights[data.disease] = {};

      // Assign weights based on symptom position (first symptoms are more important)
      for (int i = 0; i < data.symptoms.length; i++) {
        double weight =
            1.0 - (i * 0.1); // First symptom gets weight 1.0, second 0.9, etc.
        if (weight < 0.1) weight = 0.1; // Minimum weight
        _diseaseSymptomWeights[data.disease]![data.symptoms[i]] = weight;
      }
    }
  }

  // Parse symptoms from user input text
  List<String> parseSymptoms(String text) {
    // Convert to lowercase and split by common delimiters
    List<String> words = text.toLowerCase().split(RegExp(r'[,\.\s]+'));

    // Filter out common non-symptom words
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
      'feel',
      'feeling',
      'feels',
      'having',
      'got',
      'get',
      'getting',
      'seems',
      'seem',
      'seemed',
      'like',
      'really',
      'very',
      'quite',
      'extremely',
      'incredibly',
      'absolutely',
      'completely',
      'totally',
      'entirely',
      'fully',
      'wholly',
      'altogether',
      'comprehensively',
    };

    // Collect all known symptoms from our dataset
    Set<String> knownSymptoms = {};
    for (var data in _symptomData) {
      knownSymptoms.addAll(data.symptoms);
    }

    // Create symptom variations mapping for better matching
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

    List<String> foundSymptoms = [];
    String textLower = text.toLowerCase();

    // Check for multi-word symptom variations first
    symptomVariations.forEach((variation, standardSymptom) {
      if (textLower.contains(variation) &&
          knownSymptoms.contains(standardSymptom)) {
        if (!foundSymptoms.contains(standardSymptom)) {
          foundSymptoms.add(standardSymptom);
        }
      }
    });

    // Check individual words
    for (String word in words) {
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

  // Analyze symptoms and predict diseases using weighted matching
  List<DiseasePrediction> analyzeSymptoms(List<String> symptoms) {
    if (symptoms.isEmpty) {
      return [];
    }

    // Map to store disease scores
    Map<String, double> diseaseScores = {};

    // Calculate scores for each disease based on symptom matching
    _diseaseSymptomWeights.forEach((disease, symptomWeights) {
      double score = 0.0;
      int matchedSymptoms = 0;

      // Check each symptom against the disease's symptom weights
      for (String symptom in symptoms) {
        if (symptomWeights.containsKey(symptom)) {
          score += symptomWeights[symptom]!;
          matchedSymptoms++;
        }
      }

      // Only consider diseases that match at least one symptom
      if (matchedSymptoms > 0) {
        // Normalize score by number of symptoms the disease has
        double normalizedScore = score / symptomWeights.length;

        // Boost score based on percentage of symptoms matched
        double matchPercentage = matchedSymptoms / symptoms.length;
        double boostedScore = normalizedScore * (0.5 + 0.5 * matchPercentage);

        diseaseScores[disease] = boostedScore;
      }
    });

    // Convert to list of predictions and sort by score
    List<DiseasePrediction> predictions = [];

    diseaseScores.forEach((disease, score) {
      // Find the disease data
      SymptomData? diseaseData = _symptomData.firstWhere(
        (data) => data.disease == disease,
        orElse: () => _symptomData.first,
      );

      predictions.add(
        DiseasePrediction(
          disease: disease,
          description: diseaseData.description,
          symptoms: diseaseData.symptoms,
          precautions: diseaseData.precautions,
          medications: diseaseData.medications,
          diets: diseaseData.diets,
          workouts: diseaseData.workouts,
          confidence: score,
        ),
      );
    });

    // Sort by confidence (highest first)
    predictions.sort((a, b) => b.confidence.compareTo(a.confidence));

    // Return top 3 predictions
    return predictions.length > 3 ? predictions.sublist(0, 3) : predictions;
  }

  // Get a random health tip
  String getRandomHealthTip() {
    List<String> tips = [
      "Stay hydrated by drinking at least 8 glasses of water per day.",
      "Get 7-9 hours of quality sleep each night for optimal health.",
      "Include a variety of colorful fruits and vegetables in your diet.",
      "Regular exercise can boost your mood and energy levels.",
      "Practice stress management techniques like deep breathing or meditation.",
      "Limit processed foods and added sugars for better health.",
      "Maintain good hygiene by washing your hands frequently.",
      "Take breaks from screens to rest your eyes during long work sessions.",
      "Stay up to date with recommended vaccinations and health screenings.",
      "Build and maintain strong social connections for mental well-being.",
    ];

    return tips[Random().nextInt(tips.length)];
  }

  // Get all symptom data
  List<SymptomData> getAllSymptomData() {
    return _symptomData;
  }
}
