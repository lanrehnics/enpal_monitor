import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// `ThemeCubit` manages the application's theme state (light or dark) and persists it using `HydratedCubit`.
///
/// Features:
/// - Toggles between light and dark theme modes.
/// - Persists the current theme state using `HydratedCubit`.
/// - Restores the theme state from persistent storage upon app restart.
///
/// Default State:
/// - The initial state is set to `ThemeMode.light`.
///
/// Methods:
/// - **toggleTheme**: Toggles between `ThemeMode.light` and `ThemeMode.dark`.
/// - **fromJson**: Restores the theme state from a JSON object.
/// - **toJson**: Converts the theme state to a JSON object for storage.
///
/// Example Usage:
/// ```dart
/// final themeCubit = ThemeCubit();
/// themeCubit.toggleTheme(); // Switches between light and dark mode.
/// ```
class ThemeCubit extends HydratedCubit<ThemeMode> {
  /// Initializes the cubit with the default theme mode (`ThemeMode.light`).
  ThemeCubit() : super(ThemeMode.light);

  /// Toggles the theme mode between light and dark.
  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  /// Restores the theme state from a JSON object.
  ///
  /// The JSON format is expected to have a `themeMode` key with an integer value:
  /// - `1`: Light mode.
  /// - `2`: Dark mode.
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[json['themeMode'] as int];
  }

  /// Converts the current theme state to a JSON object for persistent storage.
  ///
  /// Example output:
  /// ```json
  /// { "themeMode": 1 }
  /// ```
  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'themeMode': state.index};
  }
}


