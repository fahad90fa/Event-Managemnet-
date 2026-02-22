import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/bid_models.dart';

class BidComparisonPage extends StatelessWidget {
  final List<VendorBid> bids;

  const BidComparisonPage({super.key, required this.bids});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Compare Proposals',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
      ),
      body: bids.isEmpty
          ? const Center(child: Text('No bids selected for comparison'))
          : _buildComparisonMatrix(context, bids),
    );
  }

  Widget _buildComparisonMatrix(BuildContext context, List<VendorBid> bids) {
    final currencyFormat =
        NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Comparison Summary',
              style:
                  GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 24,
              columns: [
                const DataColumn(label: Text('Feature')),
                ...bids.map((b) => DataColumn(
                        label: Text(
                      b.vendorName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ))),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Total Amount')),
                  ...bids.map((b) =>
                      DataCell(Text(currencyFormat.format(b.bidAmount)))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('AI Match Score')),
                  ...bids.map((b) => DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('${b.aiRankingScore?.toInt() ?? 0}/100',
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Includes')),
                  ...bids.map((b) =>
                      DataCell(Text('${b.includedServices.length} items'))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Status')),
                  ...bids
                      .map((b) => DataCell(Text(b.status.name.toUpperCase()))),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text('Detailed Inclusions',
              style:
                  GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bids
                .map((b) => Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b.vendorName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const Divider(),
                              ...b.includedServices.map((s) => Row(
                                    children: [
                                      const Icon(Icons.check,
                                          size: 14, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Expanded(
                                          child: Text(s,
                                              style: const TextStyle(
                                                  fontSize: 12))),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
