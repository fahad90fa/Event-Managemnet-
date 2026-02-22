import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/config/theme/app_colors.dart';

class CreateBookingPage extends StatefulWidget {
  final String businessId;
  final String serviceName;
  final int price;

  const CreateBookingPage({
    super.key,
    required this.businessId,
    required this.serviceName,
    required this.price,
  });

  @override
  State<CreateBookingPage> createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTimeSlot;
  int _currentStep = 0;

  final List<String> _timeSlots = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '06:00 PM',
    '07:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('Book Service',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Steps Indicator
          _buildStepsIndicator(),

          Expanded(
              child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: PageController(initialPage: _currentStep),
            children: [
              if (_currentStep == 0) _buildDateSelectionStep(),
              if (_currentStep == 1) _buildReviewStep(),
            ],
          )),

          // Bottom Action Bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildDateSelectionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Date',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(12),
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 90)),
              focusedDay: _focusedDay,
              currentDay: DateTime.now(),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                defaultTextStyle: const TextStyle(color: Colors.white),
                weekendTextStyle: const TextStyle(color: Colors.white70),
                selectedDecoration: const BoxDecoration(
                    color: AppColors.primaryDeep, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(
                    color: AppColors.primaryDeep.withValues(alpha: 0.3),
                    shape: BoxShape.circle),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: GoogleFonts.inter(
                    color: Colors.white, fontWeight: FontWeight.bold),
                leftChevronIcon:
                    const Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon:
                    const Icon(Icons.chevron_right, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Available Time Slots',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _timeSlots.map((time) {
              final isSelected = _selectedTimeSlot == time;
              return ChoiceChip(
                label: Text(time),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedTimeSlot = selected ? time : null;
                  });
                },
                backgroundColor: AppColors.surfaceDark,
                selectedColor: AppColors.primaryDeep,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color:
                            isSelected ? Colors.transparent : Colors.white12)),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review Booking',
              style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 24),
          _buildReviewCard(),
          const SizedBox(height: 24),
          Text('Payment Method',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.credit_card, color: Colors.white),
            title: const Text('Visa ending in 4242',
                style: TextStyle(color: Colors.white)),
            trailing: TextButton(onPressed: () {}, child: const Text('Change')),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    final currencyFormatter =
        NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildReviewRow('Service', widget.serviceName),
          const SizedBox(height: 12),
          _buildReviewRow(
              'Date',
              _selectedDay != null
                  ? DateFormat('MMM dd, yyyy').format(_selectedDay!)
                  : '-'),
          const SizedBox(height: 12),
          _buildReviewRow('Time', _selectedTimeSlot ?? '-'),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: Colors.white12)),
          _buildReviewRow('Total', currencyFormatter.format(widget.price),
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value,
            style: TextStyle(
                color: Colors.white,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14)),
      ],
    );
  }

  Widget _buildStepsIndicator() {
    return Row(
      children: [
        Expanded(
            child: Container(
                height: 4,
                color: _currentStep >= 0
                    ? AppColors.primaryDeep
                    : Colors.white12)),
        Expanded(
            child: Container(
                height: 4,
                color: _currentStep >= 1
                    ? AppColors.primaryDeep
                    : Colors.white12)),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _selectedDay == null || _selectedTimeSlot == null
              ? null
              : () {
                  if (_currentStep == 0) {
                    setState(() => _currentStep = 1);
                  } else {
                    // Confirm Booking
                    _confirmBooking();
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDeep,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            disabledBackgroundColor: Colors.white12,
          ),
          child: Text(
            _currentStep == 0 ? 'Continue' : 'Confirm & Pay',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _confirmBooking() {
    // Show success dialog or navigate
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              backgroundColor: AppColors.surfaceDark,
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 64),
                  SizedBox(height: 16),
                  Text('Booking Confirmed!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('You will receive a confirmation email shortly.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      context.go('/bookings'); // Go to bookings tab
                    },
                    child: const Text('View Bookings'))
              ],
            ));
  }
}
