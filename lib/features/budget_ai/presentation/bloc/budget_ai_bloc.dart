import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/budget_prediction_entities.dart';
import '../../domain/repositories/budget_prediction_repository.dart';

// Events
abstract class BudgetAiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestPrediction extends BudgetAiEvent {
  final int guestCount;
  final String city;
  final double targetBudget;
  final List<String> selectedServices;

  RequestPrediction({
    required this.guestCount,
    required this.city,
    required this.targetBudget,
    required this.selectedServices,
  });

  @override
  List<Object?> get props => [guestCount, city, targetBudget, selectedServices];
}

// States
abstract class BudgetAiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BudgetAiInitial extends BudgetAiState {}

class BudgetAiLoading extends BudgetAiState {}

class BudgetAiLoaded extends BudgetAiState {
  final BudgetPrediction prediction;
  BudgetAiLoaded(this.prediction);
  @override
  List<Object?> get props => [prediction];
}

class BudgetAiError extends BudgetAiState {
  final String message;
  BudgetAiError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class BudgetAiBloc extends Bloc<BudgetAiEvent, BudgetAiState> {
  final BudgetPredictionRepository repository;

  BudgetAiBloc({required this.repository}) : super(BudgetAiInitial()) {
    on<RequestPrediction>((event, emit) async {
      emit(BudgetAiLoading());
      try {
        final prediction = await repository.getBudgetPrediction(
          guestCount: event.guestCount,
          city: event.city,
          targetBudget: event.targetBudget,
          selectedServices: event.selectedServices,
        );
        emit(BudgetAiLoaded(prediction));
      } catch (e) {
        emit(BudgetAiError(e.toString()));
      }
    });
  }
}
