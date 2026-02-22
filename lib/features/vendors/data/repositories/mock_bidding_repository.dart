import '../models/bid_models.dart';
import '../../domain/repositories/bidding_repository.dart';

class MockBiddingRepository implements BiddingRepository {
  final List<BidRequest> _requests = [
    BidRequest(
      id: 'req-1',
      weddingProjectId: 'wedding-1',
      categoryId: 'Catering',
      title: 'Buffet Dinner for 500 Guests',
      requirements: const {
        'description':
            'Looking for traditional Pakistani menu (Biryani, Korma, BBQ). Must include desserts.'
      },
      guestCount: 500,
      budgetRangeMin: 800000,
      budgetRangeMax: 1200000,
      preferredDate: DateTime.now().add(const Duration(days: 30)),
      status: BidRequestStatus.published,
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    BidRequest(
      id: 'req-2',
      weddingProjectId: 'wedding-1',
      categoryId: 'Photography',
      title: 'Barat & Walima Coverage',
      requirements: const {
        'description':
            'Need 2 photographers and 1 cinematographer. Cinematic video focus.'
      },
      guestCount: 300,
      budgetRangeMin: 150000,
      budgetRangeMax: 250000,
      preferredDate: DateTime.now().add(const Duration(days: 35)),
      status: BidRequestStatus.published,
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  final List<VendorBid> _bids = [
    VendorBid(
      id: 'bid-1',
      bidRequestId: 'req-1',
      vendorId: 'v1',
      vendorName: 'Royal Catering',
      vendorImageUrl:
          'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=200',
      bidAmount: 950000,
      breakdown: const {},
      message:
          'We specialize in luxury Pakistani weddings. Our staff is highly trained and our food quality is guaranteed.',
      includedServices: const [
        'Premium Waiters',
        'Bone China Crockery',
        'Table Decor',
        '4 Desserts'
      ],
      status: BidStatus.submitted,
      aiRankingScore: 92.5,
      submittedAt: DateTime.now().subtract(const Duration(hours: 4)),
      validUntil: DateTime.now().add(const Duration(days: 15)),
    ),
    VendorBid(
      id: 'bid-2',
      bidRequestId: 'req-1',
      vendorId: 'v2',
      vendorName: 'Desi Flavors',
      vendorImageUrl:
          'https://images.unsplash.com/photo-1604328698692-f76ea9498e76?w=200',
      bidAmount: 820000,
      breakdown: const {},
      message: 'Best value in town. Authentic taste and generous portions.',
      includedServices: const ['Waiters', 'Disposable Crockery', '3 Desserts'],
      status: BidStatus.submitted,
      aiRankingScore: 84.0,
      submittedAt: DateTime.now().subtract(const Duration(hours: 10)),
      validUntil: DateTime.now().add(const Duration(days: 15)),
    ),
  ];

  @override
  Future<List<BidRequest>> getMyRequests(String weddingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _requests.where((r) => r.weddingProjectId == weddingId).toList();
  }

  @override
  Future<BidRequest> createRequest(BidRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _requests.add(request);
    return request;
  }

  @override
  Future<List<VendorBid>> getBidsForRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _bids.where((b) => b.bidRequestId == requestId).toList();
  }

  @override
  Future<void> updateBidStatus(String bidId, BidStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _bids.indexWhere((b) => b.id == bidId);
    if (index != -1) {
      final old = _bids[index];
      _bids[index] = VendorBid(
        id: old.id,
        bidRequestId: old.bidRequestId,
        vendorId: old.vendorId,
        vendorName: old.vendorName,
        vendorImageUrl: old.vendorImageUrl,
        bidAmount: old.bidAmount,
        breakdown: old.breakdown,
        includedServices: old.includedServices,
        message: old.message,
        status: status,
        aiRankingScore: old.aiRankingScore,
        submittedAt: old.submittedAt,
        validUntil: old.validUntil,
      );
    }
  }

  @override
  Future<void> submitBid(VendorBid bid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _bids.add(bid);
  }
}
