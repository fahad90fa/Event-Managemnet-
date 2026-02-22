import '../../data/models/bid_models.dart';

abstract class VendorRepository {
  Future<String> createBidRequest(BidRequest request);
  Future<List<BidRequest>> getBidRequests({String? weddingId});
  Future<List<VendorBid>> getBidsForRequest(String requestId);
  Future<void> acceptBid(String bidId);
}
