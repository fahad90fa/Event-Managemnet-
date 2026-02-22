import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme/app_colors.dart';

class ConversationPage extends StatefulWidget {
  final String conversationId;
  final String businessName;
  final String? businessImage;

  const ConversationPage({
    super.key,
    required this.conversationId,
    required this.businessName,
    this.businessImage,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // Mock messages
    setState(() {
      _messages.addAll([
        {
          'id': '1',
          'text':
              'Hi! I\'m interested in booking your services for my wedding.',
          'isMine': true,
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'status': 'read',
        },
        {
          'id': '2',
          'text':
              'Hello! Thank you for your interest. We\'d love to be part of your special day. When is your wedding date?',
          'isMine': false,
          'timestamp':
              DateTime.now().subtract(const Duration(hours: 2, minutes: 58)),
          'status': 'read',
        },
        {
          'id': '3',
          'text': 'It\'s on March 15th, 2026. Do you have availability?',
          'isMine': true,
          'timestamp':
              DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
          'status': 'read',
        },
        {
          'id': '4',
          'text':
              'Yes, we\'re available! Let me share our packages with you. Would you prefer a traditional or modern style?',
          'isMine': false,
          'timestamp':
              DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
          'status': 'read',
        },
        {
          'id': '5',
          'text':
              'I\'m looking for a modern style with some traditional elements.',
          'isMine': true,
          'timestamp': DateTime.now().subtract(const Duration(minutes: 45)),
          'status': 'read',
        },
      ]);
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': _messageController.text.trim(),
        'isMine': true,
        'timestamp': DateTime.now(),
        'status': 'sent',
      });
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate typing indicator
    setState(() => _isTyping = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isTyping = false);
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryDeep,
              backgroundImage: widget.businessImage != null
                  ? NetworkImage(widget.businessImage!)
                  : null,
              child: widget.businessImage == null
                  ? Text(
                      widget.businessName[0].toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.businessName,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Online',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.successDeep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Calling business...'),
                  backgroundColor: AppColors.primaryDeep));
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            onPressed: () {
              _showOptions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }

                final message = _messages[index];
                return _buildMessageBubble(message)
                    .animate(delay: (index * 50).ms)
                    .fadeIn()
                    .slideX(
                      begin: message['isMine'] ? 0.2 : -0.2,
                      end: 0,
                    );
              },
            ),
          ),

          // Input Area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMine = message['isMine'] as bool;
    final timestamp = message['timestamp'] as DateTime;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryDeep,
              child: Text(
                widget.businessName[0].toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: isMine
                        ? AppColors.heroGradient
                        : const LinearGradient(
                            colors: [
                              AppColors.surfaceDark,
                              AppColors.surfaceDark,
                            ],
                          ),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMine ? 16 : 4),
                      bottomRight: Radius.circular(isMine ? 4 : 16),
                    ),
                    border: isMine
                        ? null
                        : Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                  ),
                  child: Text(
                    message['text'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTimestamp(timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                    ),
                    if (isMine) ...[
                      const SizedBox(width: 4),
                      Icon(
                        _getStatusIcon(message['status']),
                        size: 14,
                        color: _getStatusColor(message['status']),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isMine) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryDeep,
            child: Text(
              widget.businessName[0].toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(200),
                const SizedBox(width: 4),
                _buildTypingDot(400),
              ],
            ),
          ),
        ],
      ),
    ).animate(onPlay: (controller) => controller.repeat()).fadeIn();
  }

  Widget _buildTypingDot(int delay) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.white54,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeOut(delay: delay.ms, duration: 600.ms)
        .then()
        .fadeIn(duration: 600.ms);
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded,
                  color: Colors.white54),
              onPressed: () {
                _showAttachmentOptions();
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white38,
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                Icons.volume_off_rounded,
                'Mute Conversation',
                () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Conversation muted'),
                      backgroundColor: AppColors.primaryDeep));
                },
              ),
              _buildOptionTile(
                Icons.delete_outline_rounded,
                'Delete Conversation',
                () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Conversation deleted'),
                      backgroundColor: AppColors.error));
                },
                isDestructive: true,
              ),
              _buildOptionTile(
                Icons.block_rounded,
                'Block Business',
                () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Business blocked'),
                      backgroundColor: AppColors.error));
                },
                isDestructive: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    Icons.photo_library_rounded,
                    'Gallery',
                    AppColors.primaryDeep,
                    () {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Gallery feature coming soon!'),
                          backgroundColor: AppColors.primaryDeep));
                    },
                  ),
                  _buildAttachmentOption(
                    Icons.camera_alt_rounded,
                    'Camera',
                    AppColors.gold,
                    () {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Camera feature coming soon!'),
                          backgroundColor: AppColors.primaryDeep));
                    },
                  ),
                  _buildAttachmentOption(
                    Icons.insert_drive_file_rounded,
                    'Document',
                    AppColors.successDeep,
                    () {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Document feature coming soon!'),
                          backgroundColor: AppColors.primaryDeep));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : Colors.white,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppColors.error : Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildAttachmentOption(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE HH:mm').format(timestamp);
    } else {
      return DateFormat('MMM dd').format(timestamp);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'sent':
        return Icons.check_rounded;
      case 'delivered':
        return Icons.done_all_rounded;
      case 'read':
        return Icons.done_all_rounded;
      default:
        return Icons.schedule_rounded;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'read':
        return AppColors.primaryLight;
      case 'delivered':
        return Colors.white54;
      default:
        return Colors.white38;
    }
  }
}
