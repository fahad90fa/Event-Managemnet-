import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../domain/guest_entity.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GuestListItem extends StatelessWidget {
  final GuestEntity guest;
  final VoidCallback onDelete;
  final int index;

  const GuestListItem({
    super.key,
    required this.guest,
    required this.onDelete,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(guest.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
            foregroundColor: Colors.redAccent,
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            borderRadius: BorderRadius.circular(24),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(color: Colors.white10),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                leading: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: guest.side == GuestSide.bride
                        ? AppColors.royalGradient
                        : AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.backgroundDark,
                    child: Text(
                      guest.name[0].toUpperCase(),
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  guest.name,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  "${guest.relation} • ${guest.familySize} Guests",
                  style: GoogleFonts.inter(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.qr_code_2_rounded,
                          color: Colors.white38, size: 22),
                      onPressed: () => _showPremiumQrDialog(context),
                    ),
                    const SizedBox(width: 4),
                    _buildPremiumStatusBadge(context, guest.rsvpStatus),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumStatusBadge(BuildContext context, RSVPStatus status) {
    Color color;
    IconData icon;

    switch (status) {
      case RSVPStatus.attending:
        color = Colors.greenAccent;
        icon = Icons.check_circle_outline_rounded;
        break;
      case RSVPStatus.pending:
        color = Colors.orangeAccent;
        icon = Icons.access_time_rounded;
        break;
      case RSVPStatus.declined:
        color = Colors.redAccent;
        icon = Icons.cancel_outlined;
        break;
      case RSVPStatus.notSent:
        color = Colors.white38;
        icon = Icons.mail_outline_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }

  void _showPremiumQrDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: AppColors.surfaceDark.withValues(alpha: 0.8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(guest.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.w900, color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: QrImageView(
                  data: 'https://wedding-os.app/guest/${guest.id}',
                  version: QrVersions.auto,
                  size: 200.0,
                  eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.circle, color: Colors.black),
                  dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.circle,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              Text('ROYAL ACCESS QR',
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondary,
                      letterSpacing: 2)),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close',
                    style: TextStyle(color: AppColors.secondary))),
          ],
        ),
      ),
    );
  }
}
