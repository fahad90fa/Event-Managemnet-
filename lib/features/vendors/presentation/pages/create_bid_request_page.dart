import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/bid_models.dart';
import '../bloc/bidding_bloc.dart';

class CreateBidRequestPage extends StatefulWidget {
  const CreateBidRequestPage({super.key});

  @override
  State<CreateBidRequestPage> createState() => _CreateBidRequestPageState();
}

class _CreateBidRequestPageState extends State<CreateBidRequestPage> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String? _selectedCategory;
  final _titleController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _minBudgetController = TextEditingController();
  final _maxBudgetController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  final List<String> _categories = [
    'Venue',
    'Catering',
    'Photography',
    'Decoration',
    'Makeup',
    'Music/DJ',
    'Clothing',
    'Other'
  ];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _requirementsController.dispose();
    _minBudgetController.dispose();
    _maxBudgetController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      try {
        final newRequest = BidRequest(
          id: 'req-${DateTime.now().millisecondsSinceEpoch}',
          weddingProjectId: 'wedding-1', // Placeholder
          categoryId: _selectedCategory!,
          title: _titleController.text,
          requirements: {'description': _requirementsController.text},
          budgetRangeMin: double.parse(_minBudgetController.text),
          budgetRangeMax: double.parse(_maxBudgetController.text),
          preferredDate: _selectedDate,
          status: BidRequestStatus.published,
          publishedAt: DateTime.now(),
        );

        context.read<BiddingBloc>().add(CreateBidRequest(newRequest));

        if (!mounted) return;

        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bid Request Published Successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Bid Request'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Info'),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Category', Icons.category),
                initialValue:
                    _selectedCategory, // Changed from value to satisfy lint
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Request Title', Icons.title)
                    .copyWith(hintText: 'e.g., Wedding Photography for 3 Days'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Event Details'),
              const SizedBox(height: 16),

              // Date Picker
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: _inputDecoration('Date', Icons.calendar_today),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Requirements
              TextFormField(
                controller: _requirementsController,
                maxLines: 4,
                decoration: _inputDecoration('Requirements', Icons.description)
                    .copyWith(alignLabelWithHint: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your requirements';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Budget'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minBudgetController,
                      keyboardType: TextInputType.number,
                      decoration:
                          _inputDecoration('Min Budget', Icons.attach_money),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _maxBudgetController,
                      keyboardType: TextInputType.number,
                      decoration:
                          _inputDecoration('Max Budget', Icons.attach_money),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Publish Request',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
