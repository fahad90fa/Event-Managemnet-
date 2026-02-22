import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bid_models.g.dart';

enum BidRequestStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('published')
  published,
  @JsonValue('closed')
  closed,
  @JsonValue('cancelled')
  cancelled,
}

enum BidStatus {
  @JsonValue('submitted')
  submitted,
  @JsonValue('shortlisted')
  shortlisted,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
  @JsonValue('withdrawn')
  withdrawn,
}

@JsonSerializable()
class BidRequest extends Equatable {
  final String id;
  final String weddingProjectId;
  final String? eventId;
  final String categoryId;
  final String title;
  final Map<String, dynamic> requirements;
  final double? budgetRangeMin;
  final double? budgetRangeMax;
  final int? guestCount;
  final DateTime? preferredDate;
  final String? locationAddress;
  final List<String> specialRequirements;
  final BidRequestStatus status;
  final DateTime? publishedAt;
  final DateTime? closesAt;
  final int bidsReceivedCount;

  const BidRequest({
    required this.id,
    required this.weddingProjectId,
    this.eventId,
    required this.categoryId,
    required this.title,
    required this.requirements,
    this.budgetRangeMin,
    this.budgetRangeMax,
    this.guestCount,
    this.preferredDate,
    this.locationAddress,
    this.specialRequirements = const [],
    required this.status,
    this.publishedAt,
    this.closesAt,
    this.bidsReceivedCount = 0,
  });

  factory BidRequest.fromJson(Map<String, dynamic> json) =>
      _$BidRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BidRequestToJson(this);

  @override
  List<Object?> get props => [
        id,
        weddingProjectId,
        eventId,
        categoryId,
        title,
        requirements,
        budgetRangeMin,
        budgetRangeMax,
        guestCount,
        preferredDate,
        locationAddress,
        specialRequirements,
        status,
        publishedAt,
        closesAt,
        bidsReceivedCount,
      ];
}

@JsonSerializable()
class VendorBid extends Equatable {
  final String id;
  final String bidRequestId;
  final String vendorId;
  final String vendorName;
  final String? vendorImageUrl;
  final double bidAmount;
  final Map<String, dynamic> breakdown;
  final List<String> includedServices;
  final String? message; // Cover letter or notes
  final BidStatus status;
  final double? aiRankingScore;
  final DateTime submittedAt;
  final DateTime validUntil;

  const VendorBid({
    required this.id,
    required this.bidRequestId,
    required this.vendorId,
    required this.vendorName,
    this.vendorImageUrl,
    required this.bidAmount,
    required this.breakdown,
    required this.includedServices,
    this.message,
    required this.status,
    this.aiRankingScore,
    required this.submittedAt,
    required this.validUntil,
  });

  factory VendorBid.fromJson(Map<String, dynamic> json) =>
      _$VendorBidFromJson(json);

  Map<String, dynamic> toJson() => _$VendorBidToJson(this);

  @override
  List<Object?> get props => [
        id,
        bidRequestId,
        vendorId,
        vendorName,
        vendorImageUrl,
        bidAmount,
        breakdown,
        includedServices,
        message,
        status,
        aiRankingScore,
        submittedAt,
        validUntil,
      ];
}
