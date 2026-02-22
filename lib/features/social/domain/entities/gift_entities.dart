import 'package:equatable/equatable.dart';

enum GiftStatus { available, claimed, partiallyFunded, purchased }

class GiftItem extends Equatable {
  final String id;
  final String weddingId;
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final String category; // e.g., 'Home', 'Electronics', 'Cash Fund'
  final GiftStatus status;
  final double currentFunding;
  final bool isCashFund;

  const GiftItem({
    required this.id,
    required this.weddingId,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.category,
    required this.status,
    this.currentFunding = 0,
    this.isCashFund = false,
  });

  @override
  List<Object?> get props =>
      [id, weddingId, title, price, status, currentFunding];

  GiftItem copyWith({
    String? id,
    String? weddingId,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    GiftStatus? status,
    double? currentFunding,
    bool? isCashFund,
  }) {
    return GiftItem(
      id: id ?? this.id,
      weddingId: weddingId ?? this.weddingId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      status: status ?? this.status,
      currentFunding: currentFunding ?? this.currentFunding,
      isCashFund: isCashFund ?? this.isCashFund,
    );
  }
}
