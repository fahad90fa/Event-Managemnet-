import 'package:equatable/equatable.dart';

enum InvitationLayout { modern, traditional, floral, royal }

class InvitationTemplate extends Equatable {
  final String id;
  final String name;
  final String previewImageUrl;
  final InvitationLayout layout;
  final String? premiumMetadata; // JSON for custom styles

  const InvitationTemplate({
    required this.id,
    required this.name,
    required this.previewImageUrl,
    required this.layout,
    this.premiumMetadata,
  });

  @override
  List<Object?> get props => [id, name, layout];
}

class GuestInvitation extends Equatable {
  final String id;
  final String guestId;
  final String weddingId;
  final String qrCodeData;
  final String? customMessage;
  final DateTime? sentAt;
  final bool isOpened;

  const GuestInvitation({
    required this.id,
    required this.guestId,
    required this.weddingId,
    required this.qrCodeData,
    this.customMessage,
    this.sentAt,
    this.isOpened = false,
  });

  @override
  List<Object?> get props => [id, guestId, qrCodeData, sentAt, isOpened];
}
