import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/guest_entity.dart';

// Events
abstract class GuestEvent extends Equatable {
  const GuestEvent();
  @override
  List<Object> get props => [];
}

class LoadGuests extends GuestEvent {}

class SearchGuests extends GuestEvent {
  final String query;
  const SearchGuests(this.query);
  @override
  List<Object> get props => [query];
}

class FilterGuests extends GuestEvent {
  final String side; // "all", "bride", "groom"
  const FilterGuests(this.side);
  @override
  List<Object> get props => [side];
}

class DeleteGuest extends GuestEvent {
  final String guestId;
  const DeleteGuest(this.guestId);
  @override
  List<Object> get props => [guestId];
}

class CheckInGuest extends GuestEvent {
  final String guestId;
  const CheckInGuest(this.guestId);
  @override
  List<Object> get props => [guestId];
}

// States
abstract class GuestState extends Equatable {
  const GuestState();
  @override
  List<Object> get props => [];
}

class GuestInitial extends GuestState {}

class GuestLoading extends GuestState {}

class GuestLoaded extends GuestState {
  final List<GuestEntity> guests;
  final List<GuestEntity> filteredGuests;
  final String activeFilter; // "all", "bride", "groom"

  const GuestLoaded({
    required this.guests,
    required this.filteredGuests,
    required this.activeFilter,
  });

  @override
  List<Object> get props => [guests, filteredGuests, activeFilter];
}

class GuestError extends GuestState {
  final String message;
  const GuestError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class GuestBloc extends Bloc<GuestEvent, GuestState> {
  // Mock Data
  final List<GuestEntity> _allGuests = [
    const GuestEntity(
        id: '1',
        name: 'Uncle Majed',
        relation: 'Uncle',
        familySize: 5,
        rsvpStatus: RSVPStatus.attending,
        side: GuestSide.groom),
    const GuestEntity(
        id: '2',
        name: 'Aunt Salma',
        relation: 'Aunt',
        familySize: 3,
        rsvpStatus: RSVPStatus.pending,
        side: GuestSide.groom),
    const GuestEntity(
        id: '3',
        name: 'Ahmed Khan',
        relation: 'Friend',
        familySize: 1,
        rsvpStatus: RSVPStatus.attending,
        side: GuestSide.bride),
    const GuestEntity(
        id: '4',
        name: 'Sara Ali',
        relation: 'Cousin',
        familySize: 2,
        rsvpStatus: RSVPStatus.declined,
        side: GuestSide.bride),
    const GuestEntity(
        id: '5',
        name: 'Kamran & Family',
        relation: 'Neighbor',
        familySize: 6,
        rsvpStatus: RSVPStatus.notSent,
        side: GuestSide.groom),
  ];

  GuestBloc() : super(GuestInitial()) {
    on<LoadGuests>((event, emit) async {
      emit(GuestLoading());
      await Future.delayed(const Duration(milliseconds: 800));
      emit(GuestLoaded(
          guests: _allGuests, filteredGuests: _allGuests, activeFilter: 'all'));
    });

    on<SearchGuests>((event, emit) {
      final currentState = state;
      if (currentState is GuestLoaded) {
        final query = event.query.toLowerCase();
        final filtered = currentState.guests.where((guest) {
          return guest.name.toLowerCase().contains(query) ||
              guest.relation.toLowerCase().contains(query);
        }).toList();
        emit(GuestLoaded(
            guests: currentState.guests,
            filteredGuests: filtered,
            activeFilter: currentState.activeFilter));
      }
    });

    on<DeleteGuest>((event, emit) {
      final currentState = state;
      if (currentState is GuestLoaded) {
        final updatedList = List<GuestEntity>.from(currentState.guests)
          ..removeWhere((g) => g.id == event.guestId);
        emit(GuestLoaded(
            guests: updatedList,
            filteredGuests: updatedList,
            activeFilter: currentState.activeFilter));
      }
    });

    on<FilterGuests>((event, emit) {
      final currentState = state;
      if (currentState is GuestLoaded) {
        final filtered = currentState.guests.where((guest) {
          if (event.side == 'all') return true;
          if (event.side == 'bride') return guest.side == GuestSide.bride;
          if (event.side == 'groom') return guest.side == GuestSide.groom;
          return true;
        }).toList();
        emit(GuestLoaded(
            guests: currentState.guests,
            filteredGuests: filtered,
            activeFilter: event.side));
      }
    });

    on<CheckInGuest>((event, emit) {
      final currentState = state;
      if (currentState is GuestLoaded) {
        final updatedList = currentState.guests.map((guest) {
          if (guest.id == event.guestId) {
            return guest.copyWith(
                isCheckedIn: true, checkInTime: DateTime.now());
          }
          return guest;
        }).toList();

        emit(GuestLoaded(
          guests: updatedList,
          filteredGuests:
              updatedList, // Logic for maintaining filter can be added if needed
          activeFilter: currentState.activeFilter,
        ));
      }
    });
  }
}
