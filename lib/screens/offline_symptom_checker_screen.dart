import 'package:flutter/material.dart';
import '../services/offline_symptom_service.dart';
import '../models/symptom_data.dart';

class OfflineSymptomCheckerScreen extends StatefulWidget {
  const OfflineSymptomCheckerScreen({Key? key}) : super(key: key);

  @override
  _OfflineSymptomCheckerScreenState createState() =>
      _OfflineSymptomCheckerScreenState();
}

class _OfflineSymptomCheckerScreenState
    extends State<OfflineSymptomCheckerScreen> {
  final OfflineSymptomService _symptomService = OfflineSymptomService();
  final TextEditingController _symptomController = TextEditingController();
  List<String> _parsedSymptoms = [];
  List<DiseasePrediction> _predictions = [];
  bool _isLoading = true;
  bool _isAnalyzing = false;
  String _healthTip = "";

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _symptomService.initialize();
    setState(() {
      _isLoading = false;
      _healthTip = _symptomService.getRandomHealthTip();
    });
  }

  void _handleSymptomSubmit() async {
    String symptomsText = _symptomController.text.trim();
    if (symptomsText.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Parse symptoms
      List<String> symptoms = _symptomService.parseSymptoms(symptomsText);

      setState(() {
        _parsedSymptoms = symptoms;
      });

      // Analyze symptoms
      List<DiseasePrediction> predictions = _symptomService.analyzeSymptoms(
        symptoms,
      );

      setState(() {
        _predictions = predictions;
        _isAnalyzing = false;
        _healthTip = _symptomService.getRandomHealthTip();
      });
    } catch (e) {
      print('Error analyzing symptoms: $e');
      setState(() {
        _isAnalyzing = false;
      });

      // Show error dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error analyzing symptoms. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Symptom Checker'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Health tip section
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Health Tip:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(_healthTip),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Symptom input section
                  const Text(
                    'Describe your symptoms:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _symptomController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'e.g., I have a headache, fever, and cough...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isAnalyzing ? null : _handleSymptomSubmit,
                    child: _isAnalyzing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Analyze Symptoms'),
                  ),

                  const SizedBox(height: 20),

                  // Parsed symptoms
                  if (_parsedSymptoms.isNotEmpty) ...[
                    const Text(
                      'Identified Symptoms:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _parsedSymptoms
                          .map(
                            (symptom) => Chip(
                              label: Text(symptom.replaceAll('_', ' ')),
                              backgroundColor: Colors.green[100],
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Predictions
                  if (_predictions.isNotEmpty) ...[
                    const Text(
                      'Possible Conditions:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _predictions.length,
                      itemBuilder: (context, index) {
                        DiseasePrediction prediction = _predictions[index];
                        return _buildPredictionCard(prediction, index);
                      },
                    ),
                  ] else if (!_isAnalyzing &&
                      _symptomController.text.isNotEmpty) ...[
                    const Center(
                      child: Text(
                        'No conditions matched your symptoms. Try describing your symptoms differently.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildPredictionCard(DiseasePrediction prediction, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: index == 0 ? Colors.red[100] : Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: index == 0 ? Colors.red : Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                prediction.disease,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${(prediction.confidence * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: index == 0 ? Colors.red : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                const Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(prediction.description),
                const SizedBox(height: 12),

                // Symptoms
                const Text(
                  'Common Symptoms:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: prediction.symptoms
                      .map(
                        (symptom) => Chip(
                          label: Text(symptom.replaceAll('_', ' ')),
                          backgroundColor: Colors.grey[200],
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),

                // Precautions
                if (prediction.precautions.isNotEmpty) ...[
                  const Text(
                    'Precautions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ...prediction.precautions
                      .map(
                        (precaution) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("• "),
                              Expanded(child: Text(precaution)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 12),
                ],

                // Medications
                if (prediction.medications.isNotEmpty) ...[
                  const Text(
                    'Common Medications:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ...prediction.medications
                      .map(
                        (medication) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("• "),
                              Expanded(child: Text(medication)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 12),
                ],

                // Diet
                if (prediction.diets.isNotEmpty) ...[
                  const Text(
                    'Recommended Diet:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ...prediction.diets
                      .map(
                        (diet) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("• "),
                              Expanded(child: Text(diet)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 12),
                ],

                // Workouts
                if (prediction.workouts.isNotEmpty) ...[
                  const Text(
                    'Recommended Lifestyle Changes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ...prediction.workouts
                      .map(
                        (workout) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("• "),
                              Expanded(child: Text(workout)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
