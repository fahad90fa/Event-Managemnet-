import '../entities/gift_entities.dart';

abstract class GiftRepository {
  Future<List<GiftItem>> getRegistry(String weddingId);
  Future<void> addGift(GiftItem gift);
  Future<void> claimGift(String giftId, String guestName);
  Future<void> contributeToFund(String giftId, double amount);
}
