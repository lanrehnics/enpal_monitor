part of 'monitoring_cubit.dart';

@freezed
class MonitoringState with _$MonitoringState {
  const factory MonitoringState.initial() = MonitoringStateInitial;

  const factory MonitoringState.solarDataLoading() = SolarDataLoading;
  const factory MonitoringState.solarDataLoadedWithError(String error) = SolarDataLoadedWithError;
  const factory MonitoringState.solarDataLoadedSuccessfully(MonitoringResponse response) = SolarDataLoadedSuccessfully;

  const factory MonitoringState.houseDataLoading() = HouseDataLoading;
  const factory MonitoringState.houseDataLoadedWithError(String error) = HouseDataLoadedWithError;
  const factory MonitoringState.houseDataLoadedSuccessfully(MonitoringResponse response) = HouseDataLoadedSuccessfully;

  const factory MonitoringState.batteryDataLoading() = BatteryDataLoading;
  const factory MonitoringState.batteryDataLoadedWithError(String error) = BatteryDataLoadedWithError;
  const factory MonitoringState.batteryDataLoadedSuccessfully(MonitoringResponse response) = BatteryDataLoadedSuccessfully;
}
