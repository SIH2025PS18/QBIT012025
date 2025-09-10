import 'package:flutter/material.dart';
import '../services/symptom_analysis_service.dart';
import '../models/symptom_analysis.dart';

class SymptomChatScreen extends StatefulWidget {
  const SymptomChatScreen({Key? key}) : super(key: key); // Fixed constructor

  @override
  _SymptomChatScreenState createState() => _SymptomChatScreenState();
}

class _SymptomChatScreenState extends State<SymptomChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final SymptomAnalysisService _analysisService = SymptomAnalysisService();
  bool _isAnalyzing = false;

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();

    ChatMessage message = ChatMessage(
      text: text,
      sender: "user",
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, message);
      _isAnalyzing = true;
    });

    // Process the symptoms and get recommendations
    _processSymptoms(text);
  }

  Future<void> _processSymptoms(String symptomsText) async {
    try {
      final result = await _analysisService.analyzeSymptoms(symptomsText);

      ChatMessage response = ChatMessage(
        text: "",
        sender: "bot",
        timestamp: DateTime.now(),
        analysis: result,
      );

      setState(() {
        _messages.insert(0, response);
        _isAnalyzing = false;
      });
    } catch (e) {
      print('Error processing symptoms: $e'); // Add error logging
      ChatMessage errorResponse = ChatMessage(
        text: "Sorry, I couldn't analyze your symptoms. Please try again.",
        sender: "bot",
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.insert(0, errorResponse);
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Checker'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          _isAnalyzing
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text("Analyzing your symptoms..."),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: "Describe your symptoms...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final String sender;
  final DateTime timestamp;
  final SymptomAnalysis? analysis;

  const ChatMessage({
    Key? key, // Fixed constructor
    required this.text,
    required this.sender,
    required this.timestamp,
    this.analysis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isUser = sender == "user";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text("B")),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue[100] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: analysis != null
                      ? SymptomAnalysisWidget(analysis: analysis!)
                      : Text(text),
                ),
                const SizedBox(height: 4),
                Text(
                  "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (isUser)
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(child: Text("U")),
            ),
        ],
      ),
    );
  }
}

class SymptomAnalysisWidget extends StatelessWidget {
  final SymptomAnalysis analysis;

  const SymptomAnalysisWidget({
    Key? key, // Fixed constructor
    required this.analysis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Disease prediction
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Predicted Condition:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                analysis.disease,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Description
        if (analysis.description.isNotEmpty)
          _buildSection("Description", analysis.description),

        // Precautions
        if (analysis.precautions.isNotEmpty)
          _buildListSection("Precautions", analysis.precautions),

        // Medications
        if (analysis.medications.isNotEmpty)
          _buildListSection("Medications", analysis.medications),

        // Diet
        if (analysis.diets.isNotEmpty)
          _buildListSection("Recommended Diet", analysis.diets),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ...items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• "),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
