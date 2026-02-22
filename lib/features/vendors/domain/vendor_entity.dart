import 'package:equatable/equatable.dart';

class VendorEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewsCount;
  final String startPrice;
  final String imageUrl;
  final List<String> portfolioImages;
  final bool isFeatured;

  const VendorEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.startPrice,
    required this.imageUrl,
    this.portfolioImages = const [],
    this.isFeatured = false,
  });

  @override
  List<Object> get props => [
        id,
        name,
        category,
        rating,
        reviewsCount,
        startPrice,
        imageUrl,
        isFeatured
      ];
}
