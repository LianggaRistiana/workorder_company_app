import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';

// NOTE:
// - This is UI-only chatbot screen
// - NO persistence (no database, no API)
// - Messages are stored in local state (List)
// - Replace dummy response with API / AI service later

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Temporary in-memory messages (NOT persistent)
  final List<ChatMessage> _messages = [];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });

    _controller.clear();

    // Simulate bot reply (replace with API call later)
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add(ChatMessage(
          text: "This is a dummy response. Connect to backend later.",
          isUser: false,
        ));
      });
      _scrollToBottom();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Pertanyaan anda...",
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _sendMessage,
              icon: Icon(AppIcon.send),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    final color = message.isUser
        ? Theme.of(context).colorScheme.primary
        : Colors.transparent;
    final textColor = message.isUser
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).textTheme.bodyLarge!.color;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              if (!message.isUser) ...[
                Icon(Icons.support_agent),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  message.text,
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
