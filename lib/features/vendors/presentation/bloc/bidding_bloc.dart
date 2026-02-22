import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/bid_models.dart';
import '../../domain/repositories/bidding_repository.dart';

// Events
abstract class BiddingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMyRequests extends BiddingEvent {
  final String weddingId;
  LoadMyRequests(this.weddingId);
  @override
  List<Object?> get props => [weddingId];
}

class LoadBidsForRequest extends BiddingEvent {
  final String requestId;
  LoadBidsForRequest(this.requestId);
  @override
  List<Object?> get props => [requestId];
}

class CreateBidRequest extends BiddingEvent {
  final BidRequest request;
  CreateBidRequest(this.request);
  @override
  List<Object?> get props => [request];
}

// States
abstract class BiddingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BiddingInitial extends BiddingState {}

class BiddingLoading extends BiddingState {}

class RequestsLoaded extends BiddingState {
  final List<BidRequest> requests;
  RequestsLoaded(this.requests);
  @override
  List<Object?> get props => [requests];
}

class BidsLoaded extends BiddingState {
  final List<VendorBid> bids;
  final BidRequest request;
  BidsLoaded(this.bids, this.request);
  @override
  List<Object?> get props => [bids, request];
}

class BiddingError extends BiddingState {
  final String message;
  BiddingError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class BiddingBloc extends Bloc<BiddingEvent, BiddingState> {
  final BiddingRepository repository;

  BiddingBloc({required this.repository}) : super(BiddingInitial()) {
    on<LoadMyRequests>((event, emit) async {
      emit(BiddingLoading());
      try {
        final requests = await repository.getMyRequests(event.weddingId);
        emit(RequestsLoaded(requests));
      } catch (e) {
        emit(BiddingError(e.toString()));
      }
    });

    on<LoadBidsForRequest>((event, emit) async {
      final currentState = state;
      emit(BiddingLoading());
      try {
        final bids = await repository.getBidsForRequest(event.requestId);
        BidRequest? request;
        if (currentState is RequestsLoaded) {
          request =
              currentState.requests.firstWhere((r) => r.id == event.requestId);
        }

        emit(BidsLoaded(bids, request!));
      } catch (e) {
        emit(BiddingError(e.toString()));
      }
    });

    on<CreateBidRequest>((event, emit) async {
      try {
        await repository.createRequest(event.request);
        add(LoadMyRequests(event.request.weddingProjectId));
      } catch (e) {
        emit(BiddingError(e.toString()));
      }
    });
  }
}
