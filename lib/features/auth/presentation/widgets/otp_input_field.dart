import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isError;
  final int length;

  const OtpInputField({
    super.key,
    required this.controller,
    this.isError = false,
    this.length = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (index) {
        return Container(
          width: 48,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isError
                  ? AppColors.error
                  : AppColors.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Center(
            child: Text(
              controller.text.length > index ? controller.text[index] : "",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ).animate().scale(
              duration: 400.ms,
              delay: (100 * index).ms,
              curve: Curves.easeOutBack,
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
            );
      }),
    );
  }
}
