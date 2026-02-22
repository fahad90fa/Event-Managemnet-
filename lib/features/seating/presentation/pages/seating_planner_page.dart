import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wedding_app/core/config/theme/app_colors.dart';
import 'package:wedding_app/features/guests/presentation/bloc/guest_bloc.dart';
import 'package:wedding_app/features/guests/domain/guest_entity.dart';
import 'package:wedding_app/core/config/localization/language_bloc.dart';
import 'package:wedding_app/core/config/localization/translator.dart';
import '../bloc/seating_bloc.dart';
import '../../domain/entities/seating_entities.dart';

class SeatingPlannerPage extends StatefulWidget {
  const SeatingPlannerPage({super.key});

  @override
  State<SeatingPlannerPage> createState() => _SeatingPlannerPageState();
}

class _SeatingPlannerPageState extends State<SeatingPlannerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, lang) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.backgroundDark,
          appBar: _buildPremiumAppBar(context, lang.language),
          endDrawer: _buildPremiumGuestDrawer(lang.language),
          body: Stack(
            children: [
              const _BackgroundMesh(),
              BlocBuilder<SeatingBloc, SeatingState>(
                builder: (context, state) {
                  if (state is SeatingInitial) {
                    context
                        .read<SeatingBloc>()
                        .add(LoadSeatingLayouts('event-1'));
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SeatingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SeatingLayoutsLoaded) {
                    return _buildPremiumLayoutList(
                        context, state.layouts, lang.language);
                  }
                  if (state is SeatingDetailsLoaded) {
                    return _buildVisualPlanner(context, state, lang.language);
                  }
                  if (state is SeatingError) {
                    return Center(
                        child: Text(state.message,
                            style: const TextStyle(color: Colors.white)));
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildPremiumAppBar(
      BuildContext context, AppLanguage language) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("seating_title".tr(language),
          style: GoogleFonts.playfairDisplay(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 22)),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.group_add_rounded, color: AppColors.secondary),
          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
        IconButton(
          icon: const Icon(Icons.add_box_rounded, color: Colors.white70),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildPremiumGuestDrawer(AppLanguage language) {
    return Drawer(
      width: 320,
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark.withValues(alpha: 0.8),
            border: const Border(left: BorderSide(color: Colors.white12)),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text("unseated_guests".tr(language),
                      style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900)),
                ),
                Expanded(
                  child: BlocBuilder<GuestBloc, GuestState>(
                    builder: (context, state) {
                      if (state is GuestLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GuestLoaded) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.guests.length,
                          itemBuilder: (context, index) {
                            final guest = state.guests[index];
                            return Draggable<GuestEntity>(
                              data: guest,
                              feedback: _PremiumGuestDragItem(
                                  guest: guest, isDragging: true),
                              childWhenDragging: Opacity(
                                  opacity: 0.3,
                                  child: _PremiumGuestDragItem(guest: guest)),
                              child: _PremiumGuestDragItem(guest: guest),
                            );
                          },
                        );
                      }
                      return const Center(
                          child: Text("No guests found",
                              style: TextStyle(color: Colors.white38)));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumLayoutList(
      BuildContext context, List<SeatingLayout> layouts, AppLanguage language) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: layouts.length,
      itemBuilder: (context, index) {
        final layout = layouts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4))
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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  title: Text(layout.layoutName,
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                  subtitle: Text(
                      "${layout.layoutType.name.toUpperCase()} • ${layout.totalCapacity} ${"seats".tr(language)}",
                      style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white24, size: 16),
                  onTap: () =>
                      context.read<SeatingBloc>().add(SelectLayout(layout)),
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildVisualPlanner(
      BuildContext context, SeatingDetailsLoaded state, AppLanguage language) {
    return Column(
      children: [
        _buildPremiumSectionTabs(state, language),
        Expanded(
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(600),
            minScale: 0.2,
            maxScale: 2.0,
            child: Center(
              child: Container(
                width: 1200,
                height: 1200,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(40),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Stack(
                  children: [
                    _buildArchitecturalGrid(),
                    _buildPremiumStage(language),
                    ...state.sectionTables.values
                        .expand((element) => element)
                        .map((table) {
                      return Positioned(
                        left: table.positionX * 5,
                        top: table.positionY * 5,
                        child: _PremiumTable(table: table, language: language),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumSectionTabs(
      SeatingDetailsLoaded state, AppLanguage language) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.sections.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildPremiumSectionChip(
                "all_sections".tr(language), AppColors.secondary, true);
          }
          final section = state.sections[index - 1];
          return _buildPremiumSectionChip(
            section.sectionName,
            Color(int.parse(section.colorCode.replaceAll('#', '0xFF'))),
            false,
          );
        },
      ),
    );
  }

  Widget _buildPremiumSectionChip(String label, Color color, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: ChoiceChip(
        label: Text(label,
            style: GoogleFonts.inter(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w700,
                fontSize: 12)),
        selected: isSelected,
        onSelected: (val) {},
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        selectedColor: color.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildArchitecturalGrid() {
    return CustomPaint(
        size: const Size(1200, 1200), painter: ArchitecturalGridPainter());
  }

  Widget _buildPremiumStage(AppLanguage language) {
    return Positioned(
      top: 50,
      left: 400,
      child: Container(
        width: 400,
        height: 100,
        decoration: BoxDecoration(
          gradient: AppColors.royalGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColors.primaryDeep.withValues(alpha: 0.4),
                blurRadius: 20)
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              const SizedBox(height: 4),
              Text("stage".tr(language),
                  style: GoogleFonts.playfairDisplay(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 2)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumTable extends StatelessWidget {
  final SeatingTable table;
  final AppLanguage language;
  const _PremiumTable({required this.table, required this.language});

  @override
  Widget build(BuildContext context) {
    return DragTarget<GuestEntity>(
      onWillAcceptWithDetails: (details) =>
          table.currentOccupied < table.capacity,
      onAcceptWithDetails: (details) {
        final guest = details.data;
        context.read<SeatingBloc>().add(AssignGuestToTable(
            tableId: table.id, guestId: guest.id, count: guest.familySize));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primaryDeep,
            content:
                Text("${"assigned_success".tr(language)} ${table.tableNumber}"),
          ),
        );
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return Container(
          width: table.tableShape == TableShape.round ? 110 : 140,
          height: 110,
          decoration: BoxDecoration(
            color: isHovering
                ? AppColors.secondary.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.05),
            shape: table.tableShape == TableShape.round
                ? BoxShape.circle
                : BoxShape.rectangle,
            borderRadius: table.tableShape == TableShape.round
                ? null
                : BorderRadius.circular(20),
            border: Border.all(
                color: isHovering ? AppColors.secondary : Colors.white24,
                width: isHovering ? 2 : 1),
            boxShadow: [
              if (isHovering)
                BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                    blurRadius: 15)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("T-${table.tableNumber}",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12)),
              const SizedBox(height: 8),
              _buildModernOccupancy(),
              const SizedBox(height: 4),
              Text("${table.currentOccupied}/${table.capacity}",
                  style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernOccupancy() {
    final percent = table.currentOccupied / table.capacity;
    return Container(
      width: 50,
      height: 6,
      decoration: BoxDecoration(
          color: Colors.white12, borderRadius: BorderRadius.circular(10)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percent.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              percent >= 1.0
                  ? Colors.red
                  : (percent >= 0.8 ? Colors.orange : AppColors.secondary),
              Colors.white.withValues(alpha: 0.5)
            ]),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class _PremiumGuestDragItem extends StatelessWidget {
  final GuestEntity guest;
  final bool isDragging;
  const _PremiumGuestDragItem({required this.guest, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: guest.side == GuestSide.bride
                ? AppColors.royalGradient
                : AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.backgroundDark,
            child: Text(guest.name[0],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        title: Text(guest.name,
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
        subtitle: Text("${guest.familySize} seats",
            style: const TextStyle(color: Colors.white38, fontSize: 10)),
        trailing: const Icon(Icons.drag_indicator_rounded,
            color: Colors.white24, size: 20),
      ),
    );
  }
}

class ArchitecturalGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    final majorPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1.5;

    for (double i = 0; i <= size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height),
          i % 200 == 0 ? majorPaint : paint);
    }
    for (double i = 0; i <= size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i),
          i % 200 == 0 ? majorPaint : paint);
    }
  }

  @override
  bool shouldRepaint(ArchitecturalGridPainter oldDelegate) => false;
}

class _BackgroundMesh extends StatelessWidget {
  const _BackgroundMesh();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration:
                const BoxDecoration(gradient: AppColors.midnightGradient)),
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryDeep.withValues(alpha: 0.2),
                  Colors.transparent
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              duration: 8.seconds,
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2)),
        ),
        Opacity(
          opacity: 0.03,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://www.transparenttextures.com/patterns/stardust.png"),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
