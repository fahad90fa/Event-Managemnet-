import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';

class SearchFilterDrawer extends StatefulWidget {
  final List<String> selectedAreas;
  final double minBudget;
  final double maxBudget;
  final DateTime? availabilityDate;
  final double? minRating;
  final bool verifiedOnly;
  final bool hasDeals;
  final GenderPolicy? genderFilter;
  final Function(Map<String, dynamic>) onApply;

  const SearchFilterDrawer({
    super.key,
    required this.selectedAreas,
    required this.minBudget,
    required this.maxBudget,
    this.availabilityDate,
    this.minRating,
    required this.verifiedOnly,
    required this.hasDeals,
    this.genderFilter,
    required this.onApply,
  });

  @override
  State<SearchFilterDrawer> createState() => _SearchFilterDrawerState();
}

class _SearchFilterDrawerState extends State<SearchFilterDrawer> {
  late List<String> _selectedAreas;
  late double _minBudget;
  late double _maxBudget;
  late DateTime? _availabilityDate;
  late double? _minRating;
  late bool _verifiedOnly;
  late bool _hasDeals;
  late GenderPolicy? _genderFilter;

  final List<String> _allAreas = [
    'DHA',
    'Gulberg',
    'Johar Town',
    'Model Town',
    'Bahria Town',
    'Cantt',
    'Garden Town',
    'Faisal Town',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAreas = List.from(widget.selectedAreas);
    _minBudget = widget.minBudget;
    _maxBudget = widget.maxBudget;
    _availabilityDate = widget.availabilityDate;
    _minRating = widget.minRating;
    _verifiedOnly = widget.verifiedOnly;
    _hasDeals = widget.hasDeals;
    _genderFilter = widget.genderFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Filters',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _resetFilters,
                      child: Text(
                        'Reset',
                        style: GoogleFonts.inter(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Filters Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Budget Range
                      _buildSectionTitle('Budget Range'),
                      const SizedBox(height: 12),
                      _buildBudgetSlider(),
                      const SizedBox(height: 24),

                      // Areas
                      _buildSectionTitle('Areas'),
                      const SizedBox(height: 12),
                      _buildAreasSelection(),
                      const SizedBox(height: 24),

                      // Availability Date
                      _buildSectionTitle('Availability Date'),
                      const SizedBox(height: 12),
                      _buildDatePicker(),
                      const SizedBox(height: 24),

                      // Minimum Rating
                      _buildSectionTitle('Minimum Rating'),
                      const SizedBox(height: 12),
                      _buildRatingSelection(),
                      const SizedBox(height: 24),

                      // Gender Policy
                      _buildSectionTitle('Gender Preference'),
                      const SizedBox(height: 12),
                      _buildGenderSelection(),
                      const SizedBox(height: 24),

                      // Additional Filters
                      _buildSectionTitle('Additional Filters'),
                      const SizedBox(height: 12),
                      _buildAdditionalFilters(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // Apply Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
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
                        onTap: _applyFilters,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              'Apply Filters',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBudgetSlider() {
    return Column(
      children: [
        RangeSlider(
          values: RangeValues(_minBudget, _maxBudget),
          min: 0,
          max: 100000,
          divisions: 100,
          activeColor: AppColors.primaryDeep,
          inactiveColor: Colors.white.withValues(alpha: 0.1),
          onChanged: (values) {
            setState(() {
              _minBudget = values.start;
              _maxBudget = values.end;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₨${_minBudget.toInt()}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryLight,
              ),
            ),
            Text(
              '₨${_maxBudget.toInt()}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAreasSelection() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _allAreas.map((area) {
        final isSelected = _selectedAreas.contains(area);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedAreas.remove(area);
              } else {
                _selectedAreas.add(area);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryDeep.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryDeep
                    : Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            child: Text(
              area,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primaryLight : Colors.white70,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _availabilityDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primaryDeep,
                  surface: AppColors.surfaceDark,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          setState(() {
            _availabilityDate = date;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _availabilityDate != null
                ? AppColors.primaryDeep
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: _availabilityDate != null
                  ? AppColors.primaryLight
                  : Colors.white54,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _availabilityDate != null
                  ? '${_availabilityDate!.day}/${_availabilityDate!.month}/${_availabilityDate!.year}'
                  : 'Select date',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    _availabilityDate != null ? Colors.white : Colors.white54,
              ),
            ),
            const Spacer(),
            if (_availabilityDate != null)
              IconButton(
                icon: const Icon(
                  Icons.clear_rounded,
                  color: Colors.white54,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _availabilityDate = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSelection() {
    return Row(
      children: [3.0, 3.5, 4.0, 4.5, 5.0].map((rating) {
        final isSelected = _minRating == rating;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _minRating = isSelected ? null : rating;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryDeep.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryDeep
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: isSelected ? AppColors.gold : Colors.white54,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rating.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColors.primaryLight
                            : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      children: GenderPolicy.values.map((policy) {
        final isSelected = _genderFilter == policy;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _genderFilter = isSelected ? null : policy;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryDeep.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryDeep
                      : Colors.white.withValues(alpha: 0.1),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getGenderIcon(policy),
                    color: isSelected ? AppColors.primaryLight : Colors.white54,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    policy.label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primaryLight,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdditionalFilters() {
    return Column(
      children: [
        _buildCheckboxTile(
          label: 'Verified businesses only',
          value: _verifiedOnly,
          onChanged: (value) {
            setState(() {
              _verifiedOnly = value;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildCheckboxTile(
          label: 'Has special deals',
          value: _hasDeals,
          onChanged: (value) {
            setState(() {
              _hasDeals = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCheckboxTile({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: value
              ? AppColors.primaryDeep.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? AppColors.primaryDeep
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              value
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: value ? AppColors.primaryLight : Colors.white54,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: value ? Colors.white : Colors.white70,
              ),
            ),
          ],
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

  void _resetFilters() {
    setState(() {
      _selectedAreas = [];
      _minBudget = 0;
      _maxBudget = 100000;
      _availabilityDate = null;
      _minRating = null;
      _verifiedOnly = false;
      _hasDeals = false;
      _genderFilter = null;
    });
  }

  void _applyFilters() {
    widget.onApply({
      'areas': _selectedAreas,
      'minBudget': _minBudget,
      'maxBudget': _maxBudget,
      'date': _availabilityDate,
      'minRating': _minRating,
      'verifiedOnly': _verifiedOnly,
      'hasDeals': _hasDeals,
      'genderFilter': _genderFilter,
    });
    Navigator.pop(context);
  }
}
