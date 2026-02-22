import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/seating_entities.dart';
import '../../domain/repositories/seating_repository.dart';

// Events
abstract class SeatingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSeatingLayouts extends SeatingEvent {
  final String eventId;
  LoadSeatingLayouts(this.eventId);
  @override
  List<Object?> get props => [eventId];
}

class SelectLayout extends SeatingEvent {
  final SeatingLayout layout;
  SelectLayout(this.layout);
  @override
  List<Object?> get props => [layout];
}

class LoadSections extends SeatingEvent {
  final String layoutId;
  LoadSections(this.layoutId);
  @override
  List<Object?> get props => [layoutId];
}

class CreateLayout extends SeatingEvent {
  final SeatingLayout layout;
  CreateLayout(this.layout);
  @override
  List<Object?> get props => [layout];
}

class UpdateTablePosition extends SeatingEvent {
  final String tableId;
  final double x;
  final double y;
  UpdateTablePosition(
      {required this.tableId, required this.x, required this.y});
  @override
  List<Object?> get props => [tableId, x, y];
}

class AssignGuestToTable extends SeatingEvent {
  final String tableId;
  final String guestId;
  final int count;
  AssignGuestToTable(
      {required this.tableId, required this.guestId, required this.count});
  @override
  List<Object?> get props => [tableId, guestId, count];
}

// State
abstract class SeatingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SeatingInitial extends SeatingState {}

class SeatingLoading extends SeatingState {}

class SeatingLayoutsLoaded extends SeatingState {
  final List<SeatingLayout> layouts;
  SeatingLayoutsLoaded(this.layouts);
  @override
  List<Object?> get props => [layouts];
}

class SeatingError extends SeatingState {
  final String message;
  SeatingError(this.message);
  @override
  List<Object?> get props => [message];
}

class SeatingDetailsLoaded extends SeatingState {
  final SeatingLayout selectedLayout;
  final List<SeatingSection> sections;
  final Map<String, List<SeatingTable>> sectionTables;

  SeatingDetailsLoaded({
    required this.selectedLayout,
    required this.sections,
    required this.sectionTables,
  });

  @override
  List<Object?> get props => [selectedLayout, sections, sectionTables];
}

// Bloc
class SeatingBloc extends Bloc<SeatingEvent, SeatingState> {
  final SeatingRepository repository;

  SeatingBloc({required this.repository}) : super(SeatingInitial()) {
    on<LoadSeatingLayouts>((event, emit) async {
      emit(SeatingLoading());
      try {
        final layouts = await repository.getLayouts(event.eventId);
        emit(SeatingLayoutsLoaded(layouts));
      } catch (e) {
        emit(SeatingError(e.toString()));
      }
    });

    on<SelectLayout>((event, emit) async {
      emit(SeatingLoading());
      try {
        final sections = await repository.getSections(event.layout.id);
        final Map<String, List<SeatingTable>> sectionTables = {};
        for (final section in sections) {
          final tables = await repository.getTables(section.id);
          sectionTables[section.id] = tables;
        }
        emit(SeatingDetailsLoaded(
          selectedLayout: event.layout,
          sections: sections,
          sectionTables: sectionTables,
        ));
      } catch (e) {
        emit(SeatingError(e.toString()));
      }
    });

    on<CreateLayout>((event, emit) async {
      try {
        await repository.createLayout(event.layout);
        add(LoadSeatingLayouts(event.layout.eventId));
      } catch (e) {
        emit(SeatingError(e.toString()));
      }
    });

    on<UpdateTablePosition>((event, emit) async {
      try {
        await repository.updateTablePosition(event.tableId, event.x, event.y);
        if (state is SeatingDetailsLoaded) {
          final currentState = state as SeatingDetailsLoaded;
          final updatedSectionTables =
              Map<String, List<SeatingTable>>.from(currentState.sectionTables);

          for (final entry in updatedSectionTables.entries) {
            final tableIndex =
                entry.value.indexWhere((t) => t.id == event.tableId);
            if (tableIndex != -1) {
              final oldTable = entry.value[tableIndex];
              entry.value[tableIndex] = SeatingTable(
                id: oldTable.id,
                seatingSectionId: oldTable.seatingSectionId,
                tableNumber: oldTable.tableNumber,
                tableShape: oldTable.tableShape,
                capacity: oldTable.capacity,
                positionX: event.x,
                positionY: event.y,
                rotationDegrees: oldTable.rotationDegrees,
                currentOccupied: oldTable.currentOccupied,
                tableStatus: oldTable.tableStatus,
                specialFeatures: oldTable.specialFeatures,
                notes: oldTable.notes,
              );
              break;
            }
          }

          emit(SeatingDetailsLoaded(
            selectedLayout: currentState.selectedLayout,
            sections: currentState.sections,
            sectionTables: updatedSectionTables,
          ));
        }
      } catch (e) {
        emit(SeatingError(e.toString()));
      }
    });

    on<AssignGuestToTable>((event, emit) async {
      try {
        await repository.assignGuestToTable(
            event.tableId, event.guestId, event.count);
        if (state is SeatingDetailsLoaded) {
          final currentState = state as SeatingDetailsLoaded;
          final updatedSectionTables =
              Map<String, List<SeatingTable>>.from(currentState.sectionTables);

          for (final entry in updatedSectionTables.entries) {
            final tableIndex =
                entry.value.indexWhere((t) => t.id == event.tableId);
            if (tableIndex != -1) {
              final oldTable = entry.value[tableIndex];
              final newOccupied = oldTable.currentOccupied + event.count;
              entry.value[tableIndex] = SeatingTable(
                id: oldTable.id,
                seatingSectionId: oldTable.seatingSectionId,
                tableNumber: oldTable.tableNumber,
                tableShape: oldTable.tableShape,
                capacity: oldTable.capacity,
                positionX: oldTable.positionX,
                positionY: oldTable.positionY,
                rotationDegrees: oldTable.rotationDegrees,
                currentOccupied: newOccupied,
                tableStatus: newOccupied >= oldTable.capacity
                    ? TableStatus.full
                    : TableStatus.partial,
                specialFeatures: oldTable.specialFeatures,
                notes: oldTable.notes,
              );
              break;
            }
          }

          emit(SeatingDetailsLoaded(
            selectedLayout: currentState.selectedLayout,
            sections: currentState.sections,
            sectionTables: updatedSectionTables,
          ));
        }
      } catch (e) {
        emit(SeatingError(e.toString()));
      }
    });
  }
}
