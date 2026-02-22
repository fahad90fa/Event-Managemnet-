import '../entities/invitation_entities.dart';

abstract class InvitationRepository {
  Future<List<InvitationTemplate>> getTemplates();
  Future<void> sendInvitation(String guestId, String templateId,
      {String? message});
  Future<List<GuestInvitation>> getSentInvitations(String weddingId);
  Future<String> generateGuestQr(String guestId);
}
