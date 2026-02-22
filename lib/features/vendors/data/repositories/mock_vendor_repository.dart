import 'package:uuid/uuid.dart';
import '../../domain/repositories/vendor_repository.dart';
import '../models/bid_models.dart';

class MockVendorRepository implements VendorRepository {
  final _uuid = const Uuid();
  final List<BidRequest> _mockRequests = [];
  final List<VendorBid> _mockBids = [];

  MockVendorRepository() {
    // Seed with some data
    _mockRequests.addAll([
      BidRequest(
        id: 'req-001',
        weddingProjectId: 'wp-123',
        categoryId: 'Photography',
        title: 'Wedding Photography & Videography',
        requirements: const {'days': 3, 'drone': true},
        budgetRangeMin: 150000,
        budgetRangeMax: 250000,
        status: BidRequestStatus.published,
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        bidsReceivedCount: 3,
        locationAddress: 'Lahore, Pakistan',
      ),
      BidRequest(
        id: 'req-002',
        weddingProjectId: 'wp-123',
        categoryId: 'Catering',
        title: 'Valima Dinner Catering',
        requirements: const {'guests': 400, 'menu': 'Premium'},
        budgetRangeMin: 800000,
        budgetRangeMax: 1200000,
        status: BidRequestStatus.closed,
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        bidsReceivedCount: 5,
        locationAddress: 'Islamabad, Pakistan',
      ),
    ]);

    _mockBids.addAll([
      VendorBid(
        id: 'bid-001',
        bidRequestId: 'req-001',
        vendorId: 'v-001',
        vendorName: 'Studios 89',
        bidAmount: 180000,
        breakdown: const {'Photography': 120000, 'Videography': 60000},
        includedServices: const ['Drone', 'Album', 'Raw Footage'],
        message: 'We specialize in cinematic wedding films.',
        status: BidStatus.shortlisted,
        submittedAt: DateTime.now().subtract(const Duration(days: 1)),
        validUntil: DateTime.now().add(const Duration(days: 7)),
      ),
      VendorBid(
        id: 'bid-002',
        bidRequestId: 'req-001',
        vendorId: 'v-002',
        vendorName: 'Maha\'s Photography',
        bidAmount: 220000,
        breakdown: const {'Photography': 150000, 'Videography': 70000},
        includedServices: const ['Drone', '2 Albums', 'Promo Teaser'],
        status: BidStatus.submitted,
        submittedAt: DateTime.now().subtract(const Duration(hours: 12)),
        validUntil: DateTime.now().add(const Duration(days: 5)),
      ),
      VendorBid(
        id: 'bid-003',
        bidRequestId: 'req-001',
        vendorId: 'v-003',
        vendorName: 'Xpressions',
        bidAmount: 160000,
        breakdown: const {'Global': 160000},
        includedServices: const ['Standard Coverage'],
        status: BidStatus.submitted,
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
        validUntil: DateTime.now().add(const Duration(days: 3)),
      ),
    ]);
  }

  @override
  Future<String> createBidRequest(BidRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    final newId = _uuid.v4();
    final newRequest = BidRequest(
      id: newId,
      weddingProjectId: request.weddingProjectId,
      categoryId: request.categoryId,
      title: request.title,
      requirements: request.requirements,
      budgetRangeMin: request.budgetRangeMin,
      budgetRangeMax: request.budgetRangeMax,
      status: BidRequestStatus.published, // Auto-publish for mock
      publishedAt: DateTime.now(),
      locationAddress: request.locationAddress,
      preferredDate: request.preferredDate,
    );
    _mockRequests.add(newRequest);
    return newId;
  }

  @override
  Future<List<BidRequest>> getBidRequests({String? weddingId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (weddingId != null) {
      return _mockRequests
          .where((r) => r.weddingProjectId == weddingId)
          .toList();
    }
    return _mockRequests;
  }

  @override
  Future<List<VendorBid>> getBidsForRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockBids.where((b) => b.bidRequestId == requestId).toList();
  }

  @override
  Future<void> acceptBid(String bidId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, update bid status
  }
}
