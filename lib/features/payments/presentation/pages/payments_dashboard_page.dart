import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/localization/language_bloc.dart';
import '../../../../core/config/localization/translator.dart';
import '../bloc/payment_bloc.dart';
import '../../domain/entities/payment_entities.dart';

class PaymentsDashboardPage extends StatelessWidget {
  const PaymentsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, lang) {
        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: Stack(
            children: [
              // Dynamic Background Consistent with other pages
              const _BackgroundMesh(),

              BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, state) {
                  if (state is PaymentInitial) {
                    context
                        .read<PaymentBloc>()
                        .add(LoadPaymentData('wedding-1'));
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is PaymentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is PaymentError) {
                    return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }
                  if (state is PaymentDataLoaded) {
                    return _buildPremiumDashboard(
                        context, state, lang.language);
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddPaymentDialog(context, lang.language),
            backgroundColor: AppColors.primaryDeep,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: Text("pay_now".tr(lang.language).toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w900, letterSpacing: 1)),
          ).animate().scale(delay: 800.ms, curve: Curves.easeOutBack),
        );
      },
    );
  }

  Widget _buildPremiumDashboard(
      BuildContext context, PaymentDataLoaded state, AppLanguage language) {
    final currencyFormat =
        NumberFormat.simpleCurrency(name: 'PKR', decimalDigits: 0);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(context, language),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildModernSummary(state, currencyFormat, language),
              const SizedBox(height: 32),
              _buildMilestoneHeader(language),
              const SizedBox(height: 16),
              if (state.milestones.isEmpty)
                const Center(
                    child: Text('No milestones yet',
                        style: TextStyle(color: Colors.white38)))
              else
                ...state.milestones.take(3).map((m) => _PremiumMilestoneTile(
                    milestone: m, format: currencyFormat, language: language)),
              const SizedBox(height: 32),
              _buildRecentActivityHeader(language),
              const SizedBox(height: 16),
              ...state.transactions.map((tx) =>
                  _PremiumTransactionTile(tx: tx, format: currencyFormat)),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, AppLanguage language) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text("wallet_title".tr(language),
            style: GoogleFonts.playfairDisplay(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            )),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 50, bottom: 16),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.receipt_long_rounded, color: Colors.white70),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildModernSummary(
      PaymentDataLoaded state, NumberFormat format, AppLanguage language) {
    final totalPaid = state.summary['total_paid'] ?? 0.0;
    final totalPending = state.summary['total_pending'] ?? 0.0;
    final totalBudget = state.summary['total_budget'] ?? 0.0;
    final progress = totalBudget > 0 ? totalPaid / totalBudget : 0.0;

    return Column(
      children: [
        // Main Wallet Card
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: AppColors.royalGradient,
            boxShadow: [
              BoxShadow(
                  color: AppColors.primaryDeep.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10))
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Icon(Icons.account_balance_wallet_rounded,
                    size: 150, color: Colors.white.withValues(alpha: 0.1)),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("budget_progress".tr(language).toUpperCase(),
                            style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2)),
                        const SizedBox(height: 12),
                        Text(format.format(totalPaid),
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900)),
                        Text("of ${format.format(totalBudget)}",
                            style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${(progress * 100).toInt()}% Paid",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: _GlassSimpleCard(
                label: "total_paid".tr(language),
                value: format.format(totalPaid),
                color: Colors.greenAccent,
                icon: Icons.check_circle_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _GlassSimpleCard(
                label: "pending".tr(language),
                value: format.format(totalPending),
                color: Colors.orangeAccent,
                icon: Icons.pending_rounded,
              ),
            ),
          ],
        ).animate(delay: 300.ms).slideY(begin: 0.2, end: 0).fadeIn(),
      ],
    );
  }

  Widget _buildMilestoneHeader(AppLanguage language) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("vendor_milestones".tr(language),
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        TextButton(
          onPressed: () {},
          child: Text("VIEW ALL",
              style: GoogleFonts.inter(
                  color: AppColors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }

  Widget _buildRecentActivityHeader(AppLanguage language) {
    return Text("recent_transactions".tr(language),
        style: GoogleFonts.inter(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800));
  }

  void _showAddPaymentDialog(BuildContext context, AppLanguage language) {
    // Premium dialog implementation later
  }
}

class _PremiumMilestoneTile extends StatelessWidget {
  final VendorPaymentMilestone milestone;
  final NumberFormat format;
  final AppLanguage language;

  const _PremiumMilestoneTile(
      {required this.milestone, required this.format, required this.language});

  @override
  Widget build(BuildContext context) {
    final isPaid = milestone.status == MilestoneStatus.paid;
    final isOverdue = milestone.status == MilestoneStatus.overdue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isPaid
                        ? Colors.green.withValues(alpha: 0.1)
                        : (isOverdue
                            ? Colors.red.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPaid
                        ? Icons.verified_rounded
                        : (isOverdue
                            ? Icons.error_rounded
                            : Icons.hourglass_top_rounded),
                    color: isPaid
                        ? Colors.greenAccent
                        : (isOverdue ? Colors.redAccent : Colors.orangeAccent),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(milestone.vendorName,
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14)),
                      Text(milestone.title,
                          style: GoogleFonts.inter(
                              color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(format.format(milestone.amount),
                        style: GoogleFonts.inter(
                            color: Colors.white, fontWeight: FontWeight.w900)),
                    if (!isPaid)
                      TextButton(
                        onPressed: () => context
                            .read<PaymentBloc>()
                            .add(PayMilestone(milestone.id)),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              AppColors.secondary.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Text("pay_now".tr(language),
                            style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w900)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumTransactionTile extends StatelessWidget {
  final PaymentTransaction tx;
  final NumberFormat format;

  const _PremiumTransactionTile({required this.tx, required this.format});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle),
          child: const Icon(Icons.history_edu_rounded,
              color: Colors.white38, size: 20),
        ),
        title: Text(tx.transactionType.name.split('.').last.toUpperCase(),
            style: GoogleFonts.inter(
                color: Colors.white70,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 1)),
        subtitle: Text(DateFormat('MMM dd, yyyy').format(tx.initiatedAt),
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
        trailing: Text(format.format(tx.amount),
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _GlassSimpleCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _GlassSimpleCard(
      {required this.label,
      required this.value,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(label,
              style: GoogleFonts.inter(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
          Text(value,
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _BackgroundMesh extends StatelessWidget {
  const _BackgroundMesh();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration:
                const BoxDecoration(gradient: AppColors.midnightGradient)),
        Positioned(
          bottom: -100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.2),
                  Colors.transparent
                ],
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: 50, duration: 8.seconds),
        ),
        Opacity(
          opacity: 0.03,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://www.transparenttextures.com/patterns/stardust.png"),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
