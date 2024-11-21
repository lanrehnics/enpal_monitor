import 'package:enpal_monitor/data/models/monitoring_response.dart';
import 'package:enpal_monitor/data/repository/i_monitory_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

part 'monitoring_cubit.freezed.dart';
part 'monitoring_state.dart';

/// The `MonitoringCubit` class manages the state of monitoring data for solar, house, and battery usage.
///
/// Features:
/// - Fetches data for solar monitoring, house consumption, and battery consumption from the provided repository.
/// - Handles success and error states for each data type.
/// - Implements caching and allows clearing cached data.
/// - Persists state using `HydratedCubit` to ensure data is retained across app restarts.
///
/// Dependencies:
/// - `IMonitoringRepository`: The interface for fetching monitoring data.
/// - `MonitoringResponse`: The model class for monitoring data.
/// - `hydrated_bloc`: For state persistence.
/// - `Logger`: For logging errors.
/// - `freezed`: For defining immutable states with sealed class-like behavior.
/// - `intl`: For formatting dates.
///
/// States:
/// - `MonitoringState` handles the various states of data loading, success, and error.
/// - States are serialized to and deserialized from JSON for persistence.
///
/// Methods:
/// - **fetchSolarMonitoringData**: Fetches solar monitoring data for a specific date.
/// - **fetchHouseConsumptionData**: Fetches house consumption data for a specific date.
/// - **fetchBatteryConsumptionData**: Fetches battery consumption data for a specific date.
/// - **clearCache**: Clears the cached data and resets the state to initial.
///
/// Serialization:
/// - Converts state data to JSON (`toJson`) and back from JSON (`fromJson`) for storage.
/// - Handles deserialization errors gracefully by reverting to the initial state.
class MonitoringCubit extends HydratedCubit<MonitoringState> {
  final IMonitoringRepository repository;
  var logger = Logger();

  /// A unique key for storage.
  final String storageKey;

  /// Initializes the `MonitoringCubit` with a repository and storage key.
  MonitoringCubit(this.repository, {required this.storageKey}) : super(const MonitoringState.initial());

  /// Fetches solar monitoring data for the specified date.
  /// If `force` is true, clears the cache before fetching.
  void fetchSolarMonitoringData(DateTime? time, {bool force = false}) async {
    if (force) {
      clearCache();
    }

    if (state is MonitoringStateInitial || state is SolarDataLoadedWithError) {
      emit(const MonitoringState.solarDataLoading());
    }
    final res = await repository.fetchMonitoring(
      DateFormat('yyyy-MM-dd').format(time ?? DateTime.now()),
      DataType.battery,
    );
    res.fold(
          (l) => emit(MonitoringState.solarDataLoadedWithError(l)),
          (r) => emit(MonitoringState.solarDataLoadedSuccessfully(r)),
    );
  }

  /// Fetches house consumption data for the specified date.
  /// If `force` is true, clears the cache before fetching.
  void fetchHouseConsumptionData(DateTime? time, {bool force = false}) async {
    if (force) {
      clearCache();
    }

    if (state is MonitoringStateInitial || state is HouseDataLoadedWithError) {
      emit(const MonitoringState.houseDataLoading());
    }
    final res = await repository.fetchMonitoring(
      DateFormat('yyyy-MM-dd').format(time ?? DateTime.now()),
      DataType.battery,
    );
    res.fold(
          (l) => emit(MonitoringState.houseDataLoadedWithError(l)),
          (r) => emit(MonitoringState.houseDataLoadedSuccessfully(r)),
    );
  }

  /// Fetches battery consumption data for the specified date.
  /// If `force` is true, clears the cache before fetching.
  void fetchBatteryConsumptionData(DateTime? time, {bool force = false}) async {
    if (force) {
      clearCache();
    }

    if (state is MonitoringStateInitial || state is BatteryDataLoadedWithError) {
      emit(const MonitoringState.batteryDataLoading());
    }
    final res = await repository.fetchMonitoring(
      DateFormat('yyyy-MM-dd').format(time ?? DateTime.now()),
      DataType.battery,
    );
    res.fold(
          (l) => emit(MonitoringState.batteryDataLoadedWithError(l)),
          (r) => emit(MonitoringState.batteryDataLoadedSuccessfully(r)),
    );
  }

  /// Clears cached data and resets the state to initial.
  void clearCache() {
    clear();
    emit(const MonitoringState.initial());
  }

  @override
  String get id => storageKey;

  /// Converts the current state to JSON for storage.
  @override
  Map<String, dynamic>? toJson(MonitoringState state) {
    return state.maybeWhen(
      solarDataLoadedSuccessfully: (data) => {
        'type': 'solarDataLoadedSuccessfully',
        'data': data.toJson(),
      },
      houseDataLoadedSuccessfully: (data) => {
        'type': 'houseDataLoadedSuccessfully',
        'data': data.toJson(),
      },
      batteryDataLoadedSuccessfully: (data) => {
        'type': 'batteryDataLoadedSuccessfully',
        'data': data.toJson(),
      },
      orElse: () => null,
    );
  }

  /// Restores the state from JSON.
  /// Falls back to the initial state in case of deserialization errors.
  @override
  MonitoringState? fromJson(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String;
      final data = MonitoringResponse.fromJson(json['data']);
      switch (type) {
        case 'solarDataLoadedSuccessfully':
          return MonitoringState.solarDataLoadedSuccessfully(data);
        case 'houseDataLoadedSuccessfully':
          return MonitoringState.houseDataLoadedSuccessfully(data);
        case 'batteryDataLoadedSuccessfully':
          return MonitoringState.batteryDataLoadedSuccessfully(data);
        default:
          return const MonitoringState.initial();
      }
    } catch (e) {
      logger.e("Error deserializing state: ", error: e);
      return const MonitoringState.initial();
    }
  }
}

