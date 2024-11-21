import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'utility_cubit.freezed.dart';
part 'utility_state.dart';

/// `UtilityCubit` handles utility-related states such as cache clearing and monitoring data fetching.
/// It provides methods for clearing cache and initiating data fetches, while managing state transitions.
///
/// Features:
/// - Clears cache by emitting a `clearCache` state and resets after a delay.
/// - Fetches monitoring data by emitting a `fetchMonitoringData` state and resets after a delay.
///
/// Default State:
/// - The initial state is `UtilityState.initial()`.
///
/// Methods:
/// - **clearCache**: Emits a `clearCache` state and resets the state after a delay.
/// - **fetchMonitoringData**: Emits a `fetchMonitoringData` state and resets the state after a delay.
/// - **_reset**: A private method that resets the state back to `initial` after a 1-second delay.
///
/// Example Usage:
/// ```dart
/// final utilityCubit = UtilityCubit();
/// utilityCubit.clearCache(); // Clears the cache and resets the state.
/// utilityCubit.fetchMonitoringData(); // Fetches monitoring data and resets the state.
/// ```
class UtilityCubit extends Cubit<UtilityState> {
  /// Initializes the cubit with the default state (`UtilityState.initial()`).
  UtilityCubit() : super(const UtilityState.initial());

  /// Clears the cache and resets the state.
  void clearCache() async {
    emit(const UtilityState.clearCache());
    _reset();
  }

  /// Initiates monitoring data fetching and resets the state.
  void fetchMonitoringData() async {
    emit(const UtilityState.fetchMonitoringData());
    _reset();
  }

  /// Private method that resets the state back to `initial` after a 1-second delay.
  void _reset() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(const UtilityState.initial());
  }
}
