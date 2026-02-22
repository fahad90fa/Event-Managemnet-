import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/guest_entity.dart';

class FilterChips extends StatelessWidget {
  final RSVPStatus? selectedFilter;
  final Function(RSVPStatus?) onSelect;

  const FilterChips({
    super.key,
    required this.selectedFilter,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _FilterChip(
              label: "All",
              isSelected: selectedFilter == null,
              onTap: () => onSelect(null),
            ),
            _FilterChip(
              label: "Attending",
              isSelected: selectedFilter == RSVPStatus.attending,
              onTap: () => onSelect(RSVPStatus.attending),
              color: AppColors.success,
            ),
            _FilterChip(
              label: "Pending",
              isSelected: selectedFilter == RSVPStatus.pending,
              onTap: () => onSelect(RSVPStatus.pending),
              color: AppColors.warning,
            ),
            _FilterChip(
              label: "Declined",
              isSelected: selectedFilter == RSVPStatus.declined,
              onTap: () => onSelect(RSVPStatus.declined),
              color: AppColors.error,
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color:
                  isSelected ? activeColor : Colors.grey.withValues(alpha: 0.3),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: activeColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4))
                  ]
                : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
