import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wedding_app/core/config/theme/app_colors.dart';
import '../bloc/invitation_bloc.dart';
import '../../domain/entities/invitation_entities.dart';

class InvitationGalleryPage extends StatelessWidget {
  const InvitationGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFB),
      appBar: AppBar(
        title: Text('Invitation Templates',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: BlocBuilder<InvitationBloc, InvitationState>(
        builder: (context, state) {
          if (state is InvitationInitial) {
            context.read<InvitationBloc>().add(LoadTemplates());
            return const Center(child: CircularProgressIndicator());
          }
          if (state is InvitationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TemplatesLoaded) {
            return _buildTemplateGrid(context, state.templates);
          }
          if (state is InvitationError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildTemplateGrid(
      BuildContext context, List<InvitationTemplate> templates) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.7,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return GestureDetector(
          onTap: () => _showTemplatePreview(context, template),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(template.previewImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(template.name,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              Text(template.layout.name.toUpperCase(),
                  style: GoogleFonts.inter(
                      letterSpacing: 1,
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }

  void _showTemplatePreview(BuildContext context, InvitationTemplate template) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(template.previewImageUrl),
                            fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(template.name,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(
                      'This template features a ${template.layout.name} design, perfect for traditional and modern Pakistani ceremonies.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: Colors.grey[600], height: 1.5),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Logic to customize or send
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Customization coming soon!')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('Use This Template',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
