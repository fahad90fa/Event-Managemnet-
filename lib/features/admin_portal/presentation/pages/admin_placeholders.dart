import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/admin_models.dart';
import '../bloc/admin_bloc.dart';
import '../../../../core/config/theme/app_colors.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementLayout(
      title: 'User Registry',
      subtitle: 'Management of all registered client and vendor accounts.',
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return AdminDataCard(
                title: user.name,
                subtitle: user.phone,
                trailing: AdminStatusChip(status: user.status.name),
                leading: CircleAvatar(
                  backgroundColor: Colors.white10,
                  child: Text(user.name[0],
                      style: const TextStyle(color: Colors.white)),
                ),
                details: [
                  AdminDetailItem(label: 'Role', value: user.role),
                  AdminDetailItem(
                      label: 'Last Active',
                      value: _formatDate(user.lastActive)),
                ],
                onTap: () => _showUserActions(context, user),
              );
            },
          );
        },
      ),
    );
  }

  void _showUserActions(BuildContext context, AdminUser user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(2)),
          ),
          ListTile(
            leading: const Icon(Icons.block_rounded, color: Colors.redAccent),
            title:
                const Text('Block User', style: TextStyle(color: Colors.white)),
            onTap: () {
              context
                  .read<AdminBloc>()
                  .add(UpdateUserStatusEvent(user.id, UserStatus.blocked));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_rounded,
                color: Colors.greenAccent),
            title: const Text('Activate User',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              context
                  .read<AdminBloc>()
                  .add(UpdateUserStatusEvent(user.id, UserStatus.active));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class AdminVendorsPage extends StatelessWidget {
  const AdminVendorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementLayout(
      title: 'Vendor Registry',
      subtitle: 'Verified businesses and verification queue.',
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: state.vendors.length,
            itemBuilder: (context, index) {
              final vendor = state.vendors[index];
              return AdminDataCard(
                title: vendor.businessName,
                subtitle: vendor.category,
                trailing: AdminStatusChip(status: vendor.status.name),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.storefront_rounded,
                      color: AppColors.primaryLight),
                ),
                details: [
                  AdminDetailItem(
                      label: 'Rating', value: vendor.rating.toString()),
                  AdminDetailItem(
                      label: 'Revenue', value: 'Rs. ${vendor.revenue.toInt()}'),
                  AdminDetailItem(
                      label: 'Bookings',
                      value: vendor.totalBookings.toString()),
                ],
                onTap: () => _showVendorActions(context, vendor),
              );
            },
          );
        },
      ),
    );
  }

  void _showVendorActions(BuildContext context, AdminVendor vendor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          ListTile(
            leading:
                const Icon(Icons.verified_rounded, color: Colors.blueAccent),
            title: const Text('Verify Vendor',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              context.read<AdminBloc>().add(
                  UpdateVendorStatusEvent(vendor.id, VendorStatus.verified));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.warning_rounded, color: Colors.orangeAccent),
            title: const Text('Suspend Vendor',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              context.read<AdminBloc>().add(
                  UpdateVendorStatusEvent(vendor.id, VendorStatus.suspended));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class AdminBookingsPage extends StatelessWidget {
  const AdminBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementLayout(
      title: 'Operation Control',
      subtitle: 'Live feed of all event bookings and status monitoring.',
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: state.bookings.length,
            itemBuilder: (context, index) {
              final booking = state.bookings[index];
              return AdminDataCard(
                title: 'Booking #${booking.id}',
                subtitle: '${booking.userName} → ${booking.vendorName}',
                trailing: AdminStatusChip(status: booking.status.name),
                leading: const Icon(Icons.receipt_long_rounded,
                    color: Colors.white24),
                details: [
                  AdminDetailItem(
                      label: 'Amount', value: 'Rs. ${booking.amount.toInt()}'),
                  AdminDetailItem(
                      label: 'Event Date', value: _formatDate(booking.date)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// Shared Admin Components
class AdminManagementLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget>? actions;
  final Widget child;

  const AdminManagementLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 8),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    subtitle,
                    style:
                        GoogleFonts.inter(color: Colors.white30, fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              if (actions != null) ...actions!,
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Divider(color: Colors.white12),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class AdminDataCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final Widget trailing;
  final List<AdminDetailItem> details;
  final VoidCallback? onTap;

  const AdminDataCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.trailing,
    required this.details,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  leading,
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        Text(subtitle,
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 13)),
                      ],
                    ),
                  ),
                  trailing,
                ],
              ),
              if (details.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white12, height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: details,
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}

class AdminDetailItem extends StatelessWidget {
  final String label;
  final String value;
  const AdminDetailItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white24,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class AdminStatusChip extends StatelessWidget {
  final String status;
  const AdminStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    if (status.contains('active') ||
        status.contains('verified') ||
        status.contains('confirmed')) {
      color = Colors.greenAccent;
    }
    if (status.contains('blocked') ||
        status.contains('suspended') ||
        status.contains('cancelled')) {
      color = Colors.redAccent;
    }
    if (status.contains('pending')) {
      color = Colors.orangeAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

class AdminFinancePage extends StatelessWidget {
  const AdminFinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementLayout(
      title: 'Financial Flow',
      subtitle: 'Audit logs of all transactions and payouts.',
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: state.financeHistory.length,
            itemBuilder: (context, index) {
              final entry = state.financeHistory[index];
              return AdminDataCard(
                title: entry.type,
                subtitle: entry.entityName,
                trailing: Text(
                  'Rs. ${entry.amount.toInt()}',
                  style: GoogleFonts.manrope(
                    color: entry.type == 'Refund'
                        ? Colors.redAccent
                        : Colors.greenAccent,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                leading: Icon(
                  entry.type == 'Payout'
                      ? Icons.account_balance_rounded
                      : Icons.payments_rounded,
                  color: Colors.white24,
                ),
                details: [
                  AdminDetailItem(label: 'Ref ID', value: entry.id),
                  AdminDetailItem(
                      label: 'Date', value: _formatDate(entry.date)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class AdminDisputesPage extends StatelessWidget {
  const AdminDisputesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementLayout(
      title: 'Conflict Resolution',
      subtitle:
          'Manage and resolve booking disputes between users and vendors.',
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: state.disputes.length,
            itemBuilder: (context, index) {
              final dispute = state.disputes[index];
              return AdminDataCard(
                title: 'Dispute #${dispute.id}',
                subtitle: 'Booking: ${dispute.bookingId}',
                trailing: AdminStatusChip(status: dispute.status.name),
                leading:
                    const Icon(Icons.gavel_rounded, color: Colors.amberAccent),
                details: [
                  AdminDetailItem(label: 'Reason', value: dispute.reason),
                  AdminDetailItem(
                      label: 'Opened On', value: _formatDate(dispute.openedAt)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class AdminCMSPage extends StatelessWidget {
  const AdminCMSPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const AdminPlaceholderPage(title: 'Content Management');
}

class AdminMarketingPage extends StatelessWidget {
  const AdminMarketingPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const AdminPlaceholderPage(title: 'Marketing & Campaigns');
}

class AdminConfigPage extends StatelessWidget {
  const AdminConfigPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const AdminPlaceholderPage(title: 'System Configuration');
}

class AdminPlaceholderPage extends StatelessWidget {
  final String title;
  const AdminPlaceholderPage({super.key, required this.title});
  @override
  Widget build(BuildContext context) =>
      Center(child: Text(title, style: const TextStyle(color: Colors.white24)));
}
