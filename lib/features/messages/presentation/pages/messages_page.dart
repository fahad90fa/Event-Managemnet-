import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final conversations = _getFilteredConversations();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          _buildAppBar(),

          // Search Bar
          SliverToBoxAdapter(
            child: _buildSearchBar(),
          ),

          // Conversations List
          if (conversations.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: index < conversations.length - 1 ? 0 : 100,
                    ),
                    child: _ConversationTile(
                      conversation: conversations[index],
                      onTap: () =>
                          context.push('/chat/${conversations[index]['id']}'),
                    )
                        .animate()
                        .fadeIn(delay: (index * 50).ms)
                        .slideX(begin: 0.2, end: 0),
                  );
                },
                childCount: conversations.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      expandedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              children: [
                Text(
                  'Messages',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ).animate().fadeIn().slideY(begin: 0.3, end: 0),
                const Spacer(),
                IconButton(
                  icon:
                      const Icon(Icons.more_vert_rounded, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Settings feature coming soon!'),
                        backgroundColor: AppColors.primaryDeep));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'Search conversations...',
            hintStyle: GoogleFonts.inter(
              color: Colors.white38,
              fontSize: 14,
            ),
            border: InputBorder.none,
            icon: const Icon(
              Icons.search_rounded,
              color: Colors.white38,
              size: 20,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: Colors.white38,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
          ),
        ),
      ).animate().fadeIn(delay: 200.ms),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white24,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No messages yet',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with a business',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white24,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ).animate().fadeIn().scale(),
    );
  }

  List<Map<String, dynamic>> _getFilteredConversations() {
    final all = _getMockConversations();

    if (_searchQuery.isEmpty) {
      return all;
    }

    return all
        .where((c) =>
            c['businessName']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            c['lastMessage']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<Map<String, dynamic>> _getMockConversations() {
    return [
      {
        'id': 'conv_1',
        'businessName': 'Glam Studio',
        'businessCategory': BusinessCategory.womensSalon,
        'businessImage': 'https://picsum.photos/100/100?random=1',
        'lastMessage': 'Your booking is confirmed for tomorrow at 10 AM',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'unreadCount': 2,
        'isOnline': true,
      },
      {
        'id': 'conv_2',
        'businessName': 'Royal Banquet',
        'businessCategory': BusinessCategory.hotelBanquet,
        'businessImage': 'https://picsum.photos/100/100?random=2',
        'lastMessage': 'We have availability for your preferred date',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'unreadCount': 0,
        'isOnline': false,
      },
      {
        'id': 'conv_3',
        'businessName': 'Capture Moments',
        'businessCategory': BusinessCategory.photographyVideo,
        'businessImage': 'https://picsum.photos/100/100?random=3',
        'lastMessage': 'Thank you for choosing us!',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'unreadCount': 0,
        'isOnline': true,
      },
      {
        'id': 'conv_4',
        'businessName': 'Taste of Lahore',
        'businessCategory': BusinessCategory.restaurant,
        'businessImage': 'https://picsum.photos/100/100?random=4',
        'lastMessage': 'Menu options have been sent',
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'unreadCount': 1,
        'isOnline': false,
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _ConversationTile extends StatelessWidget {
  final Map<String, dynamic> conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final category = conversation['businessCategory'] as BusinessCategory;
    final timestamp = conversation['timestamp'] as DateTime;
    final unreadCount = conversation['unreadCount'] as int;
    final isOnline = conversation['isOnline'] as bool;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: unreadCount > 0
                            ? AppColors.primaryDeep
                            : Colors.white.withValues(alpha: 0.1),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        conversation['businessImage'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.surfaceDark,
                            child: const Icon(
                              Icons.business_rounded,
                              color: Colors.white24,
                              size: 24,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.successDeep,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.backgroundDark,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation['businessName'],
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTimestamp(timestamp),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: unreadCount > 0
                                ? AppColors.primaryLight
                                : Colors.white38,
                            fontWeight: unreadCount > 0
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            category.label,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: _getCategoryColor(category),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            conversation['lastMessage'],
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: unreadCount > 0
                                  ? Colors.white70
                                  : Colors.white38,
                              fontWeight: unreadCount > 0
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Unread Badge
              if (unreadCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    gradient: AppColors.heroGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('MMM dd').format(timestamp);
    }
  }

  Color _getCategoryColor(BusinessCategory category) {
    switch (category) {
      case BusinessCategory.photographyVideo:
        return const Color(0xFF8B5CF6);
      case BusinessCategory.womensSalon:
        return const Color(0xFFEC4899);
      case BusinessCategory.hotelBanquet:
        return const Color(0xFFF59E0B);
      case BusinessCategory.restaurant:
        return const Color(0xFFF59E0B);
      default:
        return AppColors.primaryDeep;
    }
  }
}
