import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/chat/faq_chat_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/chat/faq_chat_state.dart';
import 'package:workorder_company_app/features/faq/presentation/widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  final CompanyEntity company;

  const ChatPage({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FaqChatCubit>()..init(company),
      child: ChatView(
        company: company,
      ),
    );
  }
}

class ChatView extends StatefulWidget {
  final CompanyEntity company;

  const ChatView({
    super.key,
    required this.company,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<FaqChatCubit>().askQuestion(widget.company, text);

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;

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
        title: const Text("Bantuan"),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<FaqChatCubit, FaqChatState>(
              listener: (context, state) {
                _scrollToBottom();
              },
              builder: (context, state) {
                final chats = state.roomChat?.chatItems ?? [];

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return ChatBubble(
                      item: chat,
                      retry: () {
                        context
                            .read<FaqChatCubit>()
                            .retryQuestion(widget.company, chat);
                      },
                    );
                  },
                );
              },
            ),
          ),
          _buildInputArea(
              context, !context.watch<FaqChatCubit>().state.anyLoading),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, bool canAsk) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: canAsk,
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
              onPressed: () => canAsk ? _sendMessage() : null,
              icon: Icon(
                AppIcon.send,
                color: canAsk
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withAlpha(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
