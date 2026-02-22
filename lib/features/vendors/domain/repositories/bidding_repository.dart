import '../../data/models/bid_models.dart';

abstract class BiddingRepository {
  Future<List<BidRequest>> getMyRequests(String weddingId);
  Future<BidRequest> createRequest(BidRequest request);
  Future<List<VendorBid>> getBidsForRequest(String requestId);
  Future<void> updateBidStatus(String bidId, BidStatus status);
  Future<void> submitBid(VendorBid bid);
}
