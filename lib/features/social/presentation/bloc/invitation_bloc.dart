import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/invitation_entities.dart';
import '../../domain/repositories/invitation_repository.dart';

// Events
abstract class InvitationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTemplates extends InvitationEvent {}

class SendInvitation extends InvitationEvent {
  final String guestId;
  final String templateId;
  final String? message;
  SendInvitation(this.guestId, this.templateId, {this.message});
}

// States
abstract class InvitationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InvitationInitial extends InvitationState {}

class InvitationLoading extends InvitationState {}

class TemplatesLoaded extends InvitationState {
  final List<InvitationTemplate> templates;
  TemplatesLoaded(this.templates);
  @override
  List<Object?> get props => [templates];
}

class InvitationSent extends InvitationState {}

class InvitationError extends InvitationState {
  final String message;
  InvitationError(this.message);
}

// Bloc
class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  final InvitationRepository repository;

  InvitationBloc({required this.repository}) : super(InvitationInitial()) {
    on<LoadTemplates>((event, emit) async {
      emit(InvitationLoading());
      try {
        final templates = await repository.getTemplates();
        emit(TemplatesLoaded(templates));
      } catch (e) {
        emit(InvitationError(e.toString()));
      }
    });

    on<SendInvitation>((event, emit) async {
      emit(InvitationLoading());
      try {
        await repository.sendInvitation(event.guestId, event.templateId,
            message: event.message);
        emit(InvitationSent());
        add(LoadTemplates()); // Refresh
      } catch (e) {
        emit(InvitationError(e.toString()));
      }
    });
  }
}
