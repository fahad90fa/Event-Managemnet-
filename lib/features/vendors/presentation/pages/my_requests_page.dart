import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../bloc/bidding_bloc.dart';
import '../../data/models/bid_models.dart';

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Vendor Bids',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateRequestDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<BiddingBloc, BiddingState>(
        builder: (context, state) {
          if (state is BiddingInitial) {
            context.read<BiddingBloc>().add(LoadMyRequests('wedding-1'));
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BiddingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RequestsLoaded) {
            return _buildRequestList(context, state.requests);
          }
          if (state is BiddingError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildRequestList(BuildContext context, List<BidRequest> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gavel_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No active bid requests',
                style:
                    GoogleFonts.inter(fontSize: 18, color: Colors.grey[600])),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _showCreateRequestDialog(context),
              child: const Text('Create Your First Request'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () {
              context.read<BiddingBloc>().add(LoadBidsForRequest(req.id));
              context.push('/vendor-bids/${req.id}');
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(req.categoryId.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 10)),
                      ),
                      Text(
                        'Ends ${_formatDate(req.preferredDate ?? DateTime.now())}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(req.title,
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(req.requirements['description'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people_outline,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${req.guestCount} Guests',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                      Text(
                        'Rs. ${NumberFormat('#,###').format(req.budgetRangeMin)} - ${NumberFormat('#,###').format(req.budgetRangeMax)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCreateRequestDialog(BuildContext context) {
    // Implementation of dialog...
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Create request dialog coming soon!')));
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
}
