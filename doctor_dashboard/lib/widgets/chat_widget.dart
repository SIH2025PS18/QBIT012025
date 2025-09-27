import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/doctor_provider.dart';
import '../providers/doctor_theme_provider.dart';
import '../models/models.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final doctor = context.read<DoctorProvider>().currentDoctor;
      if (doctor != null) {
        context.read<ChatProvider>().sendMessage(
              message,
              doctor.id,
              doctor.name,
              true, // isDoctor
            );
        _messageController.clear();
        _scrollToBottom();
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.cardBackgroundColor,
            border: Border(
                left: BorderSide(color: themeProvider.borderColor, width: 1)),
          ),
          child: Column(
            children: [
              // Chat Header (matching the image design)
              _buildChatHeader(themeProvider),

              // Messages List
              Expanded(child: _buildMessagesList(themeProvider)),

              // Message Input
              _buildMessageInput(themeProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatHeader(DoctorThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.secondaryBackgroundColor,
        border: Border(
            bottom: BorderSide(color: themeProvider.borderColor, width: 1)),
      ),
      child: Column(
        children: [
          // Doctor Info (like in the image)
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: themeProvider.accentColor,
                child: Text(
                  'DS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Brooklyn Simmons',
                      style: TextStyle(
                        color: themeProvider.primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Endocrinologist',
                      style: TextStyle(
                        color: themeProvider.secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Notification icon
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: themeProvider.accentColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tabs (Recent Messages / Attachments)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: themeProvider.accentColor, width: 2),
                    ),
                  ),
                  child: Text(
                    'Recent Messages',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeProvider.accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    'Attachments',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(DoctorThemeProvider themeProvider) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: chatProvider.messages.length,
            itemBuilder: (context, index) {
              final message = chatProvider.messages[index];
              return _buildMessageBubble(message, themeProvider);
            },
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(
      ChatMessage message, DoctorThemeProvider themeProvider) {
    final isDoctor = message.isDoctor;
    final timeString =
        '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isDoctor ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isDoctor) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: themeProvider.isDarkMode
                  ? const Color(0xFF3A3D47)
                  : Colors.grey[300],
              child: Icon(
                Icons.person,
                size: 14,
                color: themeProvider.secondaryTextColor,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDoctor
                    ? themeProvider.accentColor
                    : themeProvider.isDarkMode
                        ? const Color(0xFF3A3D47)
                        : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isDoctor
                          ? Colors.white
                          : themeProvider.primaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeString,
                    style: TextStyle(
                      color: isDoctor
                          ? Colors.white.withValues(alpha: 0.7)
                          : themeProvider.secondaryTextColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isDoctor) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: themeProvider.accentColor,
              child: const Icon(Icons.person, size: 14, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(DoctorThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.secondaryBackgroundColor,
        border:
            Border(top: BorderSide(color: themeProvider.borderColor, width: 1)),
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            onPressed: () {
              // Handle attachment
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Attachment feature coming soon'),
                  backgroundColor: themeProvider.accentColor,
                ),
              );
            },
            icon: Icon(
              Icons.attach_file,
              color: themeProvider.secondaryTextColor,
              size: 20,
            ),
          ),

          // Text input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ? const Color(0xFF3A3D47)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: themeProvider.isDarkMode
                    ? null
                    : Border.all(color: themeProvider.borderColor),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: themeProvider.primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Write your message...',
                  hintStyle: TextStyle(color: themeProvider.secondaryTextColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
                maxLines: null,
              ),
            ),
          ),

          // Send button
          IconButton(
            onPressed: _sendMessage,
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: themeProvider.accentColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
