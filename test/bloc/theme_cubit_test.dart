import 'package:enpal_monitor/bloc/theme_cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('ThemeCubit', () {
    late Storage storage;
    late ThemeCubit themeCubit;

    setUpAll(() {
      registerFallbackValue(ThemeMode.light);
    });

    setUp(() {
      storage = MockStorage();
      when(
        () => storage.write(any(), any<dynamic>()),
      ).thenAnswer((_) async {});
      HydratedBloc.storage = storage;

      // Make sure to initialize the ThemeCubit in a known state (light)
      themeCubit = ThemeCubit();
    });

    tearDown(() {
      themeCubit.close();
    });

    test('should toggle to dark theme mode when toggled from light', () {
      // Initially light
      expect(themeCubit.state, ThemeMode.light);

      themeCubit.toggleTheme();

      // After toggling, it should be dark
      expect(themeCubit.state, ThemeMode.dark);
    });

    test('should toggle to light theme mode when toggled from dark', () {
      themeCubit.toggleTheme(); // First toggle to dark

      // Now it should be dark
      expect(themeCubit.state, ThemeMode.dark);

      themeCubit.toggleTheme(); // Toggle again to light

      // Now it should be light
      expect(themeCubit.state, ThemeMode.light);
    });

    test('toJson should serialize the theme state correctly', () {
      // Ensure the initial state is light
      expect(themeCubit.state, ThemeMode.light);

      // Manually toggle to light theme to ensure proper serialization
      themeCubit.toggleTheme(); // Now it's dark
      final json = themeCubit.toJson(themeCubit.state);
      expect(json, {'themeMode': 2}); // Should be 1 for dark

      // Toggle back to light
      themeCubit.toggleTheme();
      final jsonLight = themeCubit.toJson(themeCubit.state);
      expect(jsonLight, {'themeMode': 1}); // Should be 0 for light
    });

    test('fromJson should deserialize the theme state correctly', () {
      final jsonLight = {'themeMode': 1}; // Simulate serialized light theme
      final themeMode = themeCubit.fromJson(jsonLight);

      expect(themeMode, ThemeMode.light); // Should match light theme

      final jsonDark = {'themeMode': 2}; // Simulate serialized dark theme
      final themeModeDark = themeCubit.fromJson(jsonDark);

      expect(themeModeDark, ThemeMode.dark); // Should match dark theme
    });
  });
}
