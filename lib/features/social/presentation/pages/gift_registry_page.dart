import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../bloc/gift_bloc.dart';
import '../../domain/entities/gift_entities.dart';

class GiftRegistryPage extends StatelessWidget {
  const GiftRegistryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Gift Registry',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<GiftBloc, GiftState>(
        builder: (context, state) {
          if (state is GiftInitial) {
            context.read<GiftBloc>().add(LoadRegistry('wedding-1'));
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GiftLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RegistryLoaded) {
            return _buildRegistryView(context, state.items);
          }
          if (state is GiftError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Add Gift'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildRegistryView(BuildContext context, List<GiftItem> items) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildRegistryHeader(items),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildGiftCard(context, items[index]),
              childCount: items.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }

  Widget _buildRegistryHeader(List<GiftItem> items) {
    final totalValue = items.fold(0.0, (sum, item) => sum + item.price);
    final totalFunded =
        items.fold(0.0, (sum, item) => sum + item.currentFunding);
    final progress = totalFunded / totalValue;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Registry Progress',
              style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toInt()}% Funded',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Rs. ${NumberFormat('#,###').format(totalFunded)}',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftCard(BuildContext context, GiftItem item) {
    final currencyFormat =
        NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                color: Colors.grey[100],
                image: item.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(item.imageUrl!), fit: BoxFit.cover)
                    : null,
              ),
              child: item.imageUrl == null
                  ? const Center(
                      child: Icon(Icons.card_giftcard,
                          size: 40, color: Colors.blue))
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(currencyFormat.format(item.price),
                    style: GoogleFonts.inter(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 8),
                _buildStatusBadge(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(GiftItem item) {
    Color color;
    String label;

    switch (item.status) {
      case GiftStatus.available:
        color = Colors.green;
        label = 'Available';
        break;
      case GiftStatus.claimed:
        color = Colors.orange;
        label = 'Claimed';
        break;
      case GiftStatus.partiallyFunded:
        color = Colors.blue;
        label = '${((item.currentFunding / item.price) * 100).toInt()}% Done';
        break;
      case GiftStatus.purchased:
        color = Colors.purple;
        label = 'Completed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
