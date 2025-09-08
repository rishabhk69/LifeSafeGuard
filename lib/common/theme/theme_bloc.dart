import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_themes.dart';

class ThemeEvent {
  final AppTheme appTheme;
  ThemeEvent({required this.appTheme});
}

class ThemeState {
  final ThemeData? themeData;
  ThemeState({required this.themeData});
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  //
  ThemeBloc()
      : super(
    ThemeState(
      themeData: AppThemes.appThemeData[AppTheme.lightTheme],
    ),
  );
  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeEvent) {
      yield ThemeState(
        themeData: AppThemes.appThemeData[event.appTheme],
      );
    }
  }
}