// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidRequest _$BidRequestFromJson(Map<String, dynamic> json) => BidRequest(
      id: json['id'] as String,
      weddingProjectId: json['weddingProjectId'] as String,
      eventId: json['eventId'] as String?,
      categoryId: json['categoryId'] as String,
      title: json['title'] as String,
      requirements: json['requirements'] as Map<String, dynamic>,
      budgetRangeMin: (json['budgetRangeMin'] as num?)?.toDouble(),
      budgetRangeMax: (json['budgetRangeMax'] as num?)?.toDouble(),
      guestCount: (json['guestCount'] as num?)?.toInt(),
      preferredDate: json['preferredDate'] == null
          ? null
          : DateTime.parse(json['preferredDate'] as String),
      locationAddress: json['locationAddress'] as String?,
      specialRequirements: (json['specialRequirements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: $enumDecode(_$BidRequestStatusEnumMap, json['status']),
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      closesAt: json['closesAt'] == null
          ? null
          : DateTime.parse(json['closesAt'] as String),
      bidsReceivedCount: (json['bidsReceivedCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BidRequestToJson(BidRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weddingProjectId': instance.weddingProjectId,
      'eventId': instance.eventId,
      'categoryId': instance.categoryId,
      'title': instance.title,
      'requirements': instance.requirements,
      'budgetRangeMin': instance.budgetRangeMin,
      'budgetRangeMax': instance.budgetRangeMax,
      'guestCount': instance.guestCount,
      'preferredDate': instance.preferredDate?.toIso8601String(),
      'locationAddress': instance.locationAddress,
      'specialRequirements': instance.specialRequirements,
      'status': _$BidRequestStatusEnumMap[instance.status]!,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'closesAt': instance.closesAt?.toIso8601String(),
      'bidsReceivedCount': instance.bidsReceivedCount,
    };

const _$BidRequestStatusEnumMap = {
  BidRequestStatus.draft: 'draft',
  BidRequestStatus.published: 'published',
  BidRequestStatus.closed: 'closed',
  BidRequestStatus.cancelled: 'cancelled',
};

VendorBid _$VendorBidFromJson(Map<String, dynamic> json) => VendorBid(
      id: json['id'] as String,
      bidRequestId: json['bidRequestId'] as String,
      vendorId: json['vendorId'] as String,
      vendorName: json['vendorName'] as String,
      vendorImageUrl: json['vendorImageUrl'] as String?,
      bidAmount: (json['bidAmount'] as num).toDouble(),
      breakdown: json['breakdown'] as Map<String, dynamic>,
      includedServices: (json['includedServices'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      message: json['message'] as String?,
      status: $enumDecode(_$BidStatusEnumMap, json['status']),
      aiRankingScore: (json['aiRankingScore'] as num?)?.toDouble(),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      validUntil: DateTime.parse(json['validUntil'] as String),
    );

Map<String, dynamic> _$VendorBidToJson(VendorBid instance) => <String, dynamic>{
      'id': instance.id,
      'bidRequestId': instance.bidRequestId,
      'vendorId': instance.vendorId,
      'vendorName': instance.vendorName,
      'vendorImageUrl': instance.vendorImageUrl,
      'bidAmount': instance.bidAmount,
      'breakdown': instance.breakdown,
      'includedServices': instance.includedServices,
      'message': instance.message,
      'status': _$BidStatusEnumMap[instance.status]!,
      'aiRankingScore': instance.aiRankingScore,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'validUntil': instance.validUntil.toIso8601String(),
    };

const _$BidStatusEnumMap = {
  BidStatus.submitted: 'submitted',
  BidStatus.shortlisted: 'shortlisted',
  BidStatus.accepted: 'accepted',
  BidStatus.rejected: 'rejected',
  BidStatus.withdrawn: 'withdrawn',
};
