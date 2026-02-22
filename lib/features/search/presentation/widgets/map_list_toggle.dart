import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';

class MapListToggle extends StatelessWidget {
  final bool isMapView;
  final Function(bool) onToggle;

  const MapListToggle({
    super.key,
    required this.isMapView,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            icon: Icons.list_rounded,
            isActive: !isMapView,
            onTap: () => onToggle(false),
          ),
          _buildToggleButton(
            icon: Icons.map_outlined,
            isActive: isMapView,
            onTap: () => onToggle(true),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryDeep.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isActive ? AppColors.primaryLight : Colors.white54,
          size: 18,
        ),
      ),
    );
  }
}
