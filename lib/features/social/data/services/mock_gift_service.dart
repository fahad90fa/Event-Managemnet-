import '../../domain/entities/gift_entities.dart';
import '../../domain/repositories/gift_repository.dart';

class MockGiftService implements GiftRepository {
  final List<GiftItem> _items = [
    const GiftItem(
      id: 'g1',
      weddingId: 'wedding-1',
      title: 'Haier 55" 4K LED TV',
      description: 'The perfect addition to our new living room.',
      price: 125000,
      imageUrl:
          'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400',
      category: 'Electronics',
      status: GiftStatus.available,
    ),
    const GiftItem(
      id: 'g2',
      weddingId: 'wedding-1',
      title: 'Kenwood Kitchen Machine',
      description: 'To help us make amazing meals together.',
      price: 45000,
      imageUrl:
          'https://images.unsplash.com/photo-1594385208974-2e75f9d86c48?w=400',
      category: 'Appliances',
      status: GiftStatus.partiallyFunded,
      currentFunding: 15000,
    ),
    const GiftItem(
      id: 'g3',
      weddingId: 'wedding-1',
      title: 'Home Decoration Fund',
      description: 'Help us settle into our new home with beautiful decor.',
      price: 100000,
      category: 'Cash Fund',
      status: GiftStatus.available,
      isCashFund: true,
      currentFunding: 20000,
    ),
  ];

  @override
  Future<List<GiftItem>> getRegistry(String weddingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _items;
  }

  @override
  Future<void> addGift(GiftItem gift) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _items.add(gift);
  }

  @override
  Future<void> claimGift(String giftId, String guestName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _items.indexWhere((i) => i.id == giftId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(status: GiftStatus.claimed);
    }
  }

  @override
  Future<void> contributeToFund(String giftId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _items.indexWhere((i) => i.id == giftId);
    if (index != -1) {
      final old = _items[index];
      final newFunding = old.currentFunding + amount;
      _items[index] = old.copyWith(
        currentFunding: newFunding,
        status: newFunding >= old.price
            ? GiftStatus.purchased
            : GiftStatus.partiallyFunded,
      );
    }
  }
}
