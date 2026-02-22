import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isError;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isError
            ? Border.all(color: AppColors.error, width: 2)
            : Border.all(color: Colors.grey.shade200),
        boxShadow: [AppColors.lightShadow],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          // Country Code - Simulating Dropdown slide down
          Container(
            padding: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              children: [
                const Text(
                  "🇵🇰 +92",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 18)
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: 0, end: 2, duration: 1000.ms),
              ],
            ),
          ).animate().slideY(
                begin: -1,
                end: 0,
                curve: Curves.easeOutBack,
                duration: 600.ms,
              ),

          const SizedBox(width: 12),

          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "300 1234567",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
