import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/gift_entities.dart';
import '../../domain/repositories/gift_repository.dart';

// Events
abstract class GiftEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRegistry extends GiftEvent {
  final String weddingId;
  LoadRegistry(this.weddingId);
  @override
  List<Object?> get props => [weddingId];
}

class AddGiftItem extends GiftEvent {
  final GiftItem item;
  AddGiftItem(this.item);
  @override
  List<Object?> get props => [item];
}

class ClaimGiftItem extends GiftEvent {
  final String giftId;
  final String guestName;
  ClaimGiftItem(this.giftId, this.guestName);
  @override
  List<Object?> get props => [giftId, guestName];
}

// States
abstract class GiftState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GiftInitial extends GiftState {}

class GiftLoading extends GiftState {}

class RegistryLoaded extends GiftState {
  final List<GiftItem> items;
  RegistryLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class GiftError extends GiftState {
  final String message;
  GiftError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class GiftBloc extends Bloc<GiftEvent, GiftState> {
  final GiftRepository repository;

  GiftBloc({required this.repository}) : super(GiftInitial()) {
    on<LoadRegistry>((event, emit) async {
      emit(GiftLoading());
      try {
        final items = await repository.getRegistry(event.weddingId);
        emit(RegistryLoaded(items));
      } catch (e) {
        emit(GiftError(e.toString()));
      }
    });

    on<AddGiftItem>((event, emit) async {
      try {
        await repository.addGift(event.item);
        add(LoadRegistry(event.item.weddingId));
      } catch (e) {
        emit(GiftError(e.toString()));
      }
    });

    on<ClaimGiftItem>((event, emit) async {
      try {
        await repository.claimGift(event.giftId, event.guestName);
        // Refresh local state or re-fetch
        if (state is RegistryLoaded) {
          final items = (state as RegistryLoaded).items;
          add(LoadRegistry(items.first.weddingId));
        }
      } catch (e) {
        emit(GiftError(e.toString()));
      }
    });
  }
}
