import 'package:enpal_monitor/bloc/theme_cubit/theme_cubit.dart';
import 'package:enpal_monitor/bloc/utility_cubit/utility_cubit.dart';
import 'package:enpal_monitor/core/constants/app_color.dart';
import 'package:enpal_monitor/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// `EnpalApp` is the root widget of the Enpal Monitor application.
///
/// It sets up the application with the following features:
/// - Provides [`ThemeCubit`](../bloc/theme_cubit/theme_cubit.dart) and
///   [`UtilityCubit`](../bloc/utility_cubit/utility_cubit.dart)
///   for state management via `MultiBlocProvider`.
/// - Supports dynamic theming using light and dark modes, managed by [`ThemeCubit`](../bloc/theme_cubit/theme_cubit.dart).
/// - Configures the app's appearance and behavior using `MaterialApp`, with:
///   - A light theme based on [`primaryColour`](../core/constants/app_color.dart).
///   - A dark theme also based on [`primaryColour`](../core/constants/app_color.dart).
/// - Launches the app with the [`Home`](../presentation/pages/home.dart) widget as the starting screen.
///
/// Dependencies:
/// - [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) for state management.
/// - [`app_color.dart`](../core/constants/app_color.dart) for theme color definitions.
/// - [`theme_cubit.dart`](../bloc/theme_cubit/theme_cubit.dart) and
///   [`utility_cubit.dart`](../bloc/utility_cubit/utility_cubit.dart) for business logic.
/// - [`home.dart`](../presentation/pages/home.dart) for the main application screen.



class EnpalApp extends StatelessWidget {
  const EnpalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (BuildContext context) => ThemeCubit(),
        ),
        BlocProvider<UtilityCubit>(
          create: (BuildContext context) => UtilityCubit(),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Enpal Monitor',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: primaryColour),
              useMaterial3: false,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: primaryColour,
                brightness: Brightness.dark,
              ),
              useMaterial3: false,
            ),
            themeMode: themeMode,
            home: const Home(
              enablePolling: true,
            ),
          );
        },
      ),
    );
  }
}

