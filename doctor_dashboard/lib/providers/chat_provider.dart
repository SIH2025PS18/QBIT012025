import 'package:flutter/material.dart';
import '../models/models.dart';

class ChatProvider with ChangeNotifier {
  List<ChatMessage> _messages = [];
  bool _isChatVisible = false;

  List<ChatMessage> get messages => _messages;
  bool get isChatVisible => _isChatVisible;

  void toggleChat() {
    _isChatVisible = !_isChatVisible;
    notifyListeners();
  }

  void showChat() {
    _isChatVisible = true;
    notifyListeners();
  }

  void hideChat() {
    _isChatVisible = false;
    notifyListeners();
  }

  void sendMessage(
    String message,
    String senderId,
    String senderName,
    bool isDoctor,
  ) {
    final chatMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      senderName: senderName,
      message: message,
      timestamp: DateTime.now(),
      isDoctor: isDoctor,
    );

    _messages.add(chatMessage);
    notifyListeners();

    // Simulate patient response after a delay
    if (isDoctor && message.isNotEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        _simulatePatientResponse();
      });
    }
  }

  void _simulatePatientResponse() {
    final responses = [
      "Thank you, doctor.",
      "I understand.",
      "Yes, that makes sense.",
      "When should I take the medication?",
      "How often should I do this?",
      "Should I continue with my current diet?",
      "Any side effects I should watch for?",
      "Thank you for explaining that.",
    ];

    final randomResponse =
        responses[DateTime.now().millisecond % responses.length];

    final patientMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'patient_001',
      senderName: 'Patient',
      message: randomResponse,
      timestamp: DateTime.now(),
      isDoctor: false,
    );

    _messages.add(patientMessage);
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void loadMockMessages() {
    _messages = [
      ChatMessage(
        id: 'msg_001',
        senderId: 'patient_001',
        senderName: 'Patient',
        message: 'Hello! Are you ready for the call?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        isDoctor: false,
      ),
      ChatMessage(
        id: 'msg_002',
        senderId: 'doc_001',
        senderName: 'Dr. Brooklyn Simmons',
        message: 'Yes! See you then.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isDoctor: true,
      ),
      ChatMessage(
        id: 'msg_003',
        senderId: 'patient_001',
        senderName: 'Patient',
        message: 'Don\'t forget to take pills!',
        timestamp: DateTime.now().subtract(const Duration(seconds: 30)),
        isDoctor: false,
      ),
    ];
    notifyListeners();
  }
}
