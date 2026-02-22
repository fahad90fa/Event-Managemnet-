// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftItemModel _$GiftItemModelFromJson(Map<String, dynamic> json) =>
    GiftItemModel(
      id: json['id'] as String,
      weddingId: json['weddingId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
      status: $enumDecode(_$GiftStatusEnumMap, json['status']),
      currentFunding: (json['currentFunding'] as num?)?.toDouble() ?? 0,
      isCashFund: json['isCashFund'] as bool? ?? false,
    );

Map<String, dynamic> _$GiftItemModelToJson(GiftItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weddingId': instance.weddingId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
      'status': _$GiftStatusEnumMap[instance.status]!,
      'currentFunding': instance.currentFunding,
      'isCashFund': instance.isCashFund,
    };

const _$GiftStatusEnumMap = {
  GiftStatus.available: 'available',
  GiftStatus.claimed: 'claimed',
  GiftStatus.partiallyFunded: 'partiallyFunded',
  GiftStatus.purchased: 'purchased',
};
