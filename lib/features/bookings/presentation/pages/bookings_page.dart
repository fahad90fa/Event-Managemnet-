import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';
import '../widgets/booking_card.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BookingStatus? _filterStatus;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          _buildAppBar(),

          // Status Filter Chips
          SliverToBoxAdapter(
            child: _buildStatusFilters(),
          ),

          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.primaryDeep,
                indicatorWeight: 3,
                labelColor: AppColors.primaryLight,
                unselectedLabelColor: Colors.white54,
                labelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: [
                  Tab(text: 'All (${_getBookingCount('all')})'),
                  Tab(text: 'Upcoming (${_getBookingCount('upcoming')})'),
                  Tab(text: 'Past (${_getBookingCount('past')})'),
                  Tab(text: 'Cancelled (${_getBookingCount('cancelled')})'),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingsList('all'),
                _buildBookingsList('upcoming'),
                _buildBookingsList('past'),
                _buildBookingsList('cancelled'),
              ],
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
      expandedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'My Bookings',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn().slideY(begin: 0.3, end: 0),
                    const Spacer(),
                    IconButton(
                      icon:
                          const Icon(Icons.search_rounded, color: Colors.white),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Search feature coming soon!'),
                                backgroundColor: AppColors.primaryDeep));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage all your service bookings',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilters() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildStatusChip(null, 'All'),
          const SizedBox(width: 10),
          _buildStatusChip(BookingStatus.pending, 'Pending'),
          const SizedBox(width: 10),
          _buildStatusChip(BookingStatus.confirmed, 'Confirmed'),
          const SizedBox(width: 10),
          _buildStatusChip(BookingStatus.inProgress, 'In Progress'),
          const SizedBox(width: 10),
          _buildStatusChip(BookingStatus.completed, 'Completed'),
          const SizedBox(width: 10),
          _buildStatusChip(BookingStatus.cancelled, 'Cancelled'),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildStatusChip(BookingStatus? status, String label) {
    final isSelected = _filterStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterStatus = status;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryDeep.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryDeep
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.primaryLight : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList(String type) {
    final bookings = _getFilteredBookings(type);

    if (bookings.isEmpty) {
      return _buildEmptyState(type);
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: index < bookings.length - 1 ? 16 : 80),
          child: BookingCard(
            booking: bookings[index],
            onTap: () => context.push('/booking/${bookings[index]['id']}'),
          ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.2, end: 0),
        );
      },
    );
  }

  Widget _buildEmptyState(String type) {
    final messages = {
      'all': 'No bookings yet',
      'upcoming': 'No upcoming bookings',
      'past': 'No past bookings',
      'cancelled': 'No cancelled bookings',
    };

    final descriptions = {
      'all': 'Start exploring services and make your first booking',
      'upcoming': 'Your upcoming bookings will appear here',
      'past': 'Your completed bookings will appear here',
      'cancelled': 'Your cancelled bookings will appear here',
    };

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
              Icons.calendar_today_outlined,
              color: Colors.white24,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            messages[type] ?? 'No bookings',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            descriptions[type] ?? '',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white24,
            ),
            textAlign: TextAlign.center,
          ),
          if (type == 'all') ...[
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.go('/explore'),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    child: Text(
                      'Explore Services',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ).animate().fadeIn().scale(),
    );
  }

  List<Map<String, dynamic>> _getFilteredBookings(String type) {
    final allBookings = _getMockBookings();

    if (_filterStatus != null) {
      return allBookings.where((b) => b['status'] == _filterStatus).toList();
    }

    switch (type) {
      case 'upcoming':
        return allBookings
            .where((b) =>
                b['status'] == BookingStatus.pending ||
                b['status'] == BookingStatus.confirmed ||
                b['status'] == BookingStatus.inProgress)
            .toList();
      case 'past':
        return allBookings
            .where((b) => b['status'] == BookingStatus.completed)
            .toList();
      case 'cancelled':
        return allBookings
            .where((b) => b['status'] == BookingStatus.cancelled)
            .toList();
      default:
        return allBookings;
    }
  }

  int _getBookingCount(String type) {
    return _getFilteredBookings(type).length;
  }

  List<Map<String, dynamic>> _getMockBookings() {
    return [
      {
        'id': 'booking_1',
        'businessName': 'Glam Studio',
        'businessCategory': BusinessCategory.womensSalon,
        'serviceName': 'Bridal Makeup Package',
        'date': DateTime.now().add(const Duration(days: 5)),
        'time': '10:00 AM',
        'status': BookingStatus.confirmed,
        'price': 15000,
        'imageUrl': 'https://picsum.photos/400/300?random=1',
        'bookingType': BookingType.salon,
      },
      {
        'id': 'booking_2',
        'businessName': 'Royal Banquet',
        'businessCategory': BusinessCategory.hotelBanquet,
        'serviceName': 'Wedding Hall Booking',
        'date': DateTime.now().add(const Duration(days: 15)),
        'time': '6:00 PM',
        'status': BookingStatus.pending,
        'price': 250000,
        'imageUrl': 'https://picsum.photos/400/300?random=2',
        'bookingType': BookingType.venue,
      },
      {
        'id': 'booking_3',
        'businessName': 'Capture Moments',
        'businessCategory': BusinessCategory.photographyVideo,
        'serviceName': 'Wedding Photography',
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'time': '2:00 PM',
        'status': BookingStatus.completed,
        'price': 75000,
        'imageUrl': 'https://picsum.photos/400/300?random=3',
        'bookingType': BookingType.photographer,
      },
      {
        'id': 'booking_4',
        'businessName': 'Taste of Lahore',
        'businessCategory': BusinessCategory.restaurant,
        'serviceName': 'Dholki Dinner',
        'date': DateTime.now().add(const Duration(days: 3)),
        'time': '7:00 PM',
        'status': BookingStatus.confirmed,
        'price': 45000,
        'imageUrl': 'https://picsum.photos/400/300?random=4',
        'bookingType': BookingType.restaurant,
      },
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.backgroundDark,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
  }
}
