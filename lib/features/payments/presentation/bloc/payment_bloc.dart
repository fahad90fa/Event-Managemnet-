import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_entities.dart';
import '../../domain/repositories/payment_repository.dart';

// Events
abstract class PaymentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPaymentData extends PaymentEvent {
  final String weddingId;
  LoadPaymentData(this.weddingId);
  @override
  List<Object?> get props => [weddingId];
}

class LoadMilestones extends PaymentEvent {
  final String weddingId;
  LoadMilestones(this.weddingId);
  @override
  List<Object?> get props => [weddingId];
}

class PayMilestone extends PaymentEvent {
  final String milestoneId;
  PayMilestone(this.milestoneId);
  @override
  List<Object?> get props => [milestoneId];
}

class InitiateTransaction extends PaymentEvent {
  final String gatewayCode;
  final double amount;
  final String currency;
  final Map<String, dynamic> params;

  InitiateTransaction({
    required this.gatewayCode,
    required this.amount,
    required this.currency,
    this.params = const {},
  });

  @override
  List<Object?> get props => [gatewayCode, amount, currency, params];
}

// States
abstract class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentDataLoaded extends PaymentState {
  final Map<String, dynamic> summary;
  final List<PaymentTransaction> transactions;
  final List<PaymentGateway> gateways;
  final List<VendorPaymentMilestone> milestones;

  PaymentDataLoaded({
    required this.summary,
    required this.transactions,
    required this.gateways,
    this.milestones = const [],
  });

  @override
  List<Object?> get props => [summary, transactions, gateways, milestones];
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository repository;

  PaymentBloc({required this.repository}) : super(PaymentInitial()) {
    on<LoadPaymentData>((event, emit) async {
      emit(PaymentLoading());
      try {
        final summary = await repository.getPaymentSummary(event.weddingId);
        final transactions = await repository.getTransactions(event.weddingId);
        final gateways = await repository.getGateways();
        final milestones =
            await repository.getVendorMilestones(event.weddingId);

        emit(PaymentDataLoaded(
          summary: summary,
          transactions: transactions,
          gateways: gateways,
          milestones: milestones,
        ));
      } catch (e) {
        emit(PaymentError(e.toString()));
      }
    });

    on<PayMilestone>((event, emit) async {
      try {
        await repository.payMilestone(event.milestoneId);
        add(LoadPaymentData('wedding-1')); // Refresh everything
      } catch (e) {
        emit(PaymentError(e.toString()));
      }
    });

    on<InitiateTransaction>((event, emit) async {
      try {
        await repository.initiatePayment(
            event.gatewayCode, event.amount, event.currency, event.params);
        add(LoadPaymentData('wedding-1'));
      } catch (e) {
        emit(PaymentError(e.toString()));
      }
    });
  }
}
