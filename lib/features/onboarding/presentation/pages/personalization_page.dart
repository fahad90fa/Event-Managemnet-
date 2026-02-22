import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';

class PersonalizationPage extends StatefulWidget {
  final String? intent; // 'book' or 'plan'

  const PersonalizationPage({super.key, this.intent});

  @override
  State<PersonalizationPage> createState() => _PersonalizationPageState();
}

class _PersonalizationPageState extends State<PersonalizationPage> {
  int _currentStep = 0;
  String? _selectedCity;
  final List<String> _selectedAreas = [];
  final List<BusinessCategory> _selectedInterests = [];
  GenderPolicy? _genderPreference;

  final List<String> _cities = [
    'Lahore',
    'Karachi',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Peshawar',
    'Quetta',
  ];

  final Map<String, List<String>> _areasByCity = {
    'Lahore': ['DHA', 'Gulberg', 'Johar Town', 'Model Town', 'Bahria Town'],
    'Karachi': ['DHA', 'Clifton', 'Gulshan', 'Nazimabad', 'Bahria Town'],
    'Islamabad': ['F-6', 'F-7', 'F-8', 'G-6', 'Blue Area', 'Bahria Town'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Premium Background
          const _PremiumBackground(),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Progress Indicator
                _buildProgressIndicator(),

                // Step Content
                Expanded(
                  child: _buildStepContent(),
                ),

                // Navigation Buttons
                _buildNavigationButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            _getStepTitle(),
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: 0.3, end: 0),
          const SizedBox(height: 8),
          Text(
            _getStepSubtitle(),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white60,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryDeep
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: isCompleted
                  ? Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )
                  : null,
            ),
          );
        }),
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildStepContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _currentStep == 0
          ? _buildCitySelection()
          : _currentStep == 1
              ? _buildInterestsSelection()
              : _buildGenderPreference(),
    );
  }

  Widget _buildCitySelection() {
    return SingleChildScrollView(
      key: const ValueKey('city'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City Selection
          Text(
            "Select your city",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _cities.map((city) {
              final isSelected = _selectedCity == city;
              return _buildChip(
                label: city,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedCity = city;
                    _selectedAreas.clear();
                  });
                },
              );
            }).toList(),
          ),

          if (_selectedCity != null) ...[
            const SizedBox(height: 32),
            Text(
              "Select areas (optional)",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: (_areasByCity[_selectedCity] ?? []).map((area) {
                final isSelected = _selectedAreas.contains(area);
                return _buildChip(
                  label: area,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedAreas.remove(area);
                      } else {
                        _selectedAreas.add(area);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInterestsSelection() {
    return SingleChildScrollView(
      key: const ValueKey('interests'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What services interest you?",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: BusinessCategory.values.map((category) {
              final isSelected = _selectedInterests.contains(category);
              return _buildCategoryChip(
                category: category,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedInterests.remove(category);
                    } else {
                      _selectedInterests.add(category);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderPreference() {
    return SingleChildScrollView(
      key: const ValueKey('gender'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender preference (optional)",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Filter businesses based on your preference",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 24),
          ...GenderPolicy.values.map((policy) {
            final isSelected = _genderPreference == policy;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildGenderCard(
                policy: policy,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _genderPreference = isSelected ? null : policy;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryDeep.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryDeep
                  : Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primaryLight : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required BusinessCategory category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryDeep.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryDeep
                  : Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                category.emoji,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                category.label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primaryLight : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard({
    required GenderPolicy policy,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = {
      GenderPolicy.womenOnly: const Color(0xFFDB2777),
      GenderPolicy.menOnly: const Color(0xFF2563EB),
      GenderPolicy.unisex: const Color(0xFF8B5CF6),
      GenderPolicy.segregated: const Color(0xFF10B981),
    };

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colors[policy]!.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors[policy]!.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? colors[policy]!
                        : Colors.white.withValues(alpha: 0.1),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors[policy]!.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getGenderIcon(policy),
                        color: colors[policy],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        policy.label,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: colors[policy],
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getGenderIcon(GenderPolicy policy) {
    switch (policy) {
      case GenderPolicy.womenOnly:
        return Icons.woman_rounded;
      case GenderPolicy.menOnly:
        return Icons.man_rounded;
      case GenderPolicy.unisex:
        return Icons.people_rounded;
      case GenderPolicy.segregated:
        return Icons.family_restroom_rounded;
    }
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Back",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.royalGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDeep.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleNext,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        _currentStep < 2 ? "Next" : "Get Started",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Save preferences and navigate to explore
      // Preferences saved
      context.go('/explore');
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return "Where are you located?";
      case 1:
        return "What interests you?";
      case 2:
        return "Your preferences";
      default:
        return "";
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return "Help us show you relevant services nearby";
      case 1:
        return "Select categories you're interested in";
      case 2:
        return "Customize your experience";
      default:
        return "";
    }
  }
}

class _PremiumBackground extends StatelessWidget {
  const _PremiumBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
