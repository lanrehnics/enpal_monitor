import 'package:enpal_monitor/app.dart';
import 'package:enpal_monitor/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

/// The entry point of the Enpal Monitor application.
///
/// This function is responsible for initializing all necessary services and
/// running the app. It ensures the app state is persisted across restarts
/// using `HydratedBloc` and sets up the necessary dependencies before starting
/// the app.
///
/// Steps:
/// 1. Initialize Flutter bindings to ensure proper setup for async operations.
/// 2. Set up the application's dependencies and services via `setupDependencies()`.
/// 3. Initialize `HydratedStorage` to persist the state of the app (via `HydratedBloc`).
/// 4. Launch the app by calling `runApp` with the root widget `EnpalApp`.
///
/// Example usage:
/// This function is automatically called when the app starts, so no need to call it manually.
void main() async {
  // Ensures that Flutter has been initialized before running async code
  WidgetsFlutterBinding.ensureInitialized();

  // Set up services, repositories, and dependencies used across the app
  setupDependencies();

  // Initialize the storage for HydratedBloc to persist state across app restarts
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  HydratedBloc.storage = storage;

  // Run the app
  runApp(const EnpalApp());
}
