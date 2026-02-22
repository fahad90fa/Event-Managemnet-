import '../../domain/entities/invitation_entities.dart';
import '../../domain/repositories/invitation_repository.dart';
import 'package:uuid/uuid.dart';

class MockInvitationService implements InvitationRepository {
  final List<InvitationTemplate> _templates = [
    const InvitationTemplate(
      id: 't1',
      name: 'Royal Mughal',
      previewImageUrl:
          'https://images.unsplash.com/photo-1621259182978-f09e5e2ca1ff?w=400',
      layout: InvitationLayout.royal,
    ),
    const InvitationTemplate(
      id: 't2',
      name: 'Floral Walima',
      previewImageUrl:
          'https://images.unsplash.com/photo-1549416878-b9ca35c24946?w=400',
      layout: InvitationLayout.floral,
    ),
    const InvitationTemplate(
      id: 't3',
      name: 'Modern Minimalist',
      previewImageUrl:
          'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400',
      layout: InvitationLayout.modern,
    ),
  ];

  final List<GuestInvitation> _sentInvitations = [];

  @override
  Future<List<InvitationTemplate>> getTemplates() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _templates;
  }

  @override
  Future<void> sendInvitation(String guestId, String templateId,
      {String? message}) async {
    await Future.delayed(const Duration(seconds: 1));
    _sentInvitations.add(GuestInvitation(
      id: const Uuid().v4(),
      guestId: guestId,
      weddingId: 'wedding-1',
      qrCodeData: 'https://wedding-os.app/guest/$guestId',
      customMessage: message,
      sentAt: DateTime.now(),
    ));
  }

  @override
  Future<List<GuestInvitation>> getSentInvitations(String weddingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _sentInvitations;
  }

  @override
  Future<String> generateGuestQr(String guestId) async {
    return 'GUEST-QR-$guestId';
  }
}
