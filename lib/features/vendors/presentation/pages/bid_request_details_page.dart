import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../data/models/bid_models.dart';
import '../../domain/repositories/bidding_repository.dart';
import 'package:google_fonts/google_fonts.dart';

class BidRequestDetailsPage extends StatefulWidget {
  final BidRequest request;

  const BidRequestDetailsPage({super.key, required this.request});

  @override
  State<BidRequestDetailsPage> createState() => _BidRequestDetailsPageState();
}

class _BidRequestDetailsPageState extends State<BidRequestDetailsPage> {
  List<VendorBid>? _bids;
  bool _isLoading = true;
  final Set<String> _selectedBidIds = {};

  @override
  void initState() {
    super.initState();
    _loadBids();
  }

  Future<void> _loadBids() async {
    final repo = context.read<BiddingRepository>();
    final bids = await repo.getBidsForRequest(widget.request.id);
    if (mounted) {
      setState(() {
        _bids = bids;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Request Details',
            style: GoogleFonts.playfairDisplay(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRequestHeader(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Received Bids (${_bids?.length ?? 0})',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary),
                  ),
                  TextButton.icon(
                    onPressed: _selectedBidIds.length < 2
                        ? null
                        : () {
                            final selectedBids = _bids!
                                .where((b) => _selectedBidIds.contains(b.id))
                                .toList();
                            context.push('/bid-comparison',
                                extra: selectedBids);
                          },
                    icon: const Icon(Icons.compare_arrows),
                    label: Text('Compare (${_selectedBidIds.length})'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _isLoading
                ? const Center(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator()))
                : _buildBidsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestHeader() {
    final r = widget.request;
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                  label: Text(r.categoryId,
                      style: const TextStyle(color: Colors.white)),
                  backgroundColor: AppColors.secondary),
              const Spacer(),
              Text(
                'Status: ${r.status.name.toUpperCase()}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.success),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(r.title,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            r.requirements['description'] ?? 'No description',
            style:
                GoogleFonts.inter(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoItem(Icons.attach_money, 'Budget',
                  'PKR ${(r.budgetRangeMin ?? 0) / 1000}k - ${(r.budgetRangeMax ?? 0) / 1000}k'),
              const SizedBox(width: 24),
              _buildInfoItem(
                  Icons.calendar_today,
                  'Date',
                  r.preferredDate != null
                      ? DateFormat('MMM d').format(r.preferredDate!)
                      : 'Flexible'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildBidsList() {
    if (_bids == null || _bids!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('No bids received yet. Check back later!'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: _bids!.length,
      itemBuilder: (context, index) {
        return _buildBidCard(_bids![index]);
      },
    );
  }

  Widget _buildBidCard(VendorBid bid) {
    final isSelected = _selectedBidIds.contains(bid.id);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedBidIds.remove(bid.id);
          } else {
            if (_selectedBidIds.length >= 3) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Select max 3 bids to compare')));
              return;
            }
            _selectedBidIds.add(bid.id);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : Colors.grey.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? AppColors.primary : Colors.grey,
                ),
                const SizedBox(width: 12),
                const CircleAvatar(child: Icon(Icons.store)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bid.vendorName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(DateFormat('MMM d, h:mm a').format(bid.submittedAt),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                Text('PKR ${bid.bidAmount / 1000}k',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            Text(bid.message ?? 'No message provided.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: bid.includedServices
                  .map((s) => Chip(
                        label: Text(s, style: const TextStyle(fontSize: 10)),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('View Full Proposal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
