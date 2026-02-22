import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/gift_entities.dart';

part 'gift_models.g.dart';

@JsonSerializable()
class GiftItemModel extends GiftItem {
  const GiftItemModel({
    required super.id,
    required super.weddingId,
    required super.title,
    required super.description,
    required super.price,
    super.imageUrl,
    required super.category,
    required super.status,
    super.currentFunding,
    super.isCashFund,
  });

  factory GiftItemModel.fromJson(Map<String, dynamic> json) =>
      _$GiftItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$GiftItemModelToJson(this);
}
