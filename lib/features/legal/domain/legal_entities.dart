import 'package:equatable/equatable.dart';

enum DocumentStatus { verified, pending, rejected, missing }

class OfficialDocument extends Equatable {
  final String id;
  final String title;
  final String description;
  final DocumentStatus status;
  final String? fileUrl;
  final DateTime? expiryDate;
  final bool isRequired;

  const OfficialDocument({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.fileUrl,
    this.expiryDate,
    this.isRequired = true,
  });

  @override
  List<Object?> get props =>
      [id, title, description, status, fileUrl, expiryDate, isRequired];
}

class LegalTask extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final List<String> steps;
  final String urgency; // low, medium, high

  const LegalTask({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.steps,
    this.urgency = 'medium',
  });

  @override
  List<Object?> get props =>
      [id, title, description, isCompleted, steps, urgency];
}
