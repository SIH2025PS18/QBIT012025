import 'package:flutter/material.dart';
import 'dart:async';

import '../services/socket_service.dart' as socket_service;

// Enum for message types
enum ChatMessageType { text, prescription, system }

class ChatWidget extends StatefulWidget {
  final String consultationId;
  final String currentUserId;
  final bool isDoctor;

  const ChatWidget({
    Key? key,
    required this.consultationId,
    required this.currentUserId,
    required this.isDoctor,
  }) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late socket_service.SocketService _socketService;
  StreamSubscription<socket_service.ChatMessage>? _chatSubscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _socketService = socket_service.SocketService();
    _setupChatListener();
    _loadChatHistory();
  }

  void _setupChatListener() {
    _chatSubscription = _socketService.chatMessages.listen(
      (socketMessage) {
        if (socketMessage.consultationId == widget.consultationId) {
          setState(() {
            _messages.add(
              ChatMessage(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                senderId: socketMessage.senderId,
                senderName: socketMessage.senderName,
                message: socketMessage.message,
                timestamp: DateTime.fromMillisecondsSinceEpoch(
                  socketMessage.timestamp,
                ),
                isFromCurrentUser:
                    socketMessage.senderId == widget.currentUserId,
                type: ChatMessageType.text,
              ),
            );
          });
          _scrollToBottom();
        }
      },
      onError: (error) {
        debugPrint('Chat subscription error: $error');
        _showErrorSnackBar('Failed to receive messages');
      },
    );
  }

  void _loadChatHistory() {
    setState(() {
      _isLoading = true;
    });

    // Load chat history from your backend/database
    // For demo purposes, adding some sample messages
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.addAll([
            ChatMessage(
              id: '1',
              senderId: widget.isDoctor ? 'patient-1' : 'doctor-1',
              senderName: widget.isDoctor ? 'Patient' : 'Doctor',
              message: 'Hello, how are you feeling today?',
              timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
              isFromCurrentUser: false,
              type: ChatMessageType.text,
            ),
            ChatMessage(
              id: '2',
              senderId: widget.currentUserId,
              senderName: 'You',
              message: 'I\'m feeling much better, thank you for asking.',
              timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
              isFromCurrentUser: true,
              type: ChatMessageType.text,
            ),
            // Sample prescription message
            if (widget.isDoctor)
              ChatMessage(
                id: '3',
                senderId: 'doctor-1',
                senderName: 'Dr. Singh',
                message: '',
                timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
                isFromCurrentUser: false,
                type: ChatMessageType.prescription,
                prescription: PrescriptionData(
                  doctorId: 'doctor-1',
                  patientId: widget.currentUserId,
                  medications: [
                    'Paracetamol 500mg - 1 tablet 3 times a day for 5 days',
                    'Amoxicillin 250mg - 1 capsule twice a day for 7 days',
                  ],
                  notes:
                      'Take with food. Complete the full course of antibiotics.',
                ),
              ),
          ]);
          _isLoading = false;
        });
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Chat header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat, color: Colors.blue),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Chat',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Close chat (this would be handled by parent widget)
                  },
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation!',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      switch (message.type) {
                        case ChatMessageType.prescription:
                          return _buildPrescriptionMessage(message);
                        case ChatMessageType.system:
                          return _buildSystemMessage(message);
                        case ChatMessageType.text:
                        default:
                          return _buildTextMessageBubble(message);
                      }
                    },
                  ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isFromCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isFromCurrentUser) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey[300],
              child: Text(
                message.senderName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: message.isFromCurrentUser
                    ? Colors.blue
                    : Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(
                    message.isFromCurrentUser ? 12 : 4,
                  ),
                  bottomRight: Radius.circular(
                    message.isFromCurrentUser ? 4 : 12,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isFromCurrentUser)
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  Text(
                    message.message,
                    style: TextStyle(
                      fontSize: 12,
                      color: message.isFromCurrentUser
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 9,
                      color: message.isFromCurrentUser
                          ? Colors.white70
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (message.isFromCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.blue[100],
              child: Text(
                message.senderName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrescriptionMessage(ChatMessage message) {
    final prescription = message.prescription!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prescription header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.description, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Prescription from Dr. Singh',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(fontSize: 10, color: Colors.blue),
                ),
              ],
            ),
          ),

          // Medications list
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Medications:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...prescription.medications
                    .map(
                      (med) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.medication,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                med,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),

                if (prescription.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prescription.notes,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    // Save prescription
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Prescription saved to health locker'),
                      ),
                    );
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Share prescription
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Prescription shared')),
                    );
                  },
                  child: const Text(
                    'Share',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Print prescription
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Prescription sent to printer'),
                      ),
                    );
                  },
                  child: const Text(
                    'Print',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.message,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: widget.currentUserId,
      senderName: 'You',
      message: text,
      timestamp: DateTime.now(),
      isFromCurrentUser: true,
      type: ChatMessageType.text,
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
    });

    _scrollToBottom();

    // Send message to backend/other participants
    _sendMessageToBackend(message);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessageToBackend(ChatMessage message) async {
    try {
      _socketService.sendChatMessage(
        consultationId: widget.consultationId,
        senderId: message.senderId,
        senderName: message.senderName,
        message: message.message,
      );
    } catch (e) {
      debugPrint('Error sending message: $e');
      _showErrorSnackBar('Failed to send message');

      // Mark message as failed (you could add a status field to ChatMessage)
      // For now, we'll just show an error
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Now';
    }
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isFromCurrentUser;
  final ChatMessageType type;
  final PrescriptionData? prescription;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.isFromCurrentUser,
    required this.type,
    this.prescription,
  });
}

class PrescriptionData {
  final String doctorId;
  final String patientId;
  final List<String> medications;
  final String notes;

  PrescriptionData({
    required this.doctorId,
    required this.patientId,
    required this.medications,
    required this.notes,
  });
}
