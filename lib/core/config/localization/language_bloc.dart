import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

enum AppLanguage { english, urdu }

class LanguageState extends Equatable {
  final Locale locale;
  final TextDirection direction;
  final AppLanguage language;

  const LanguageState({
    required this.locale,
    required this.direction,
    required this.language,
  });

  factory LanguageState.english() => const LanguageState(
        locale: Locale('en', 'US'),
        direction: TextDirection.ltr,
        language: AppLanguage.english,
      );

  factory LanguageState.urdu() => const LanguageState(
        locale: Locale('ur', 'PK'),
        direction: TextDirection.rtl,
        language: AppLanguage.urdu,
      );

  @override
  List<Object?> get props => [locale, direction, language];
}

abstract class LanguageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToggleLanguage extends LanguageEvent {}

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState.english()) {
    on<ToggleLanguage>((event, emit) {
      if (state.language == AppLanguage.english) {
        emit(LanguageState.urdu());
      } else {
        emit(LanguageState.english());
      }
    });
  }
}
