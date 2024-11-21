part of 'utility_cubit.dart';

@freezed
class UtilityState with _$UtilityState {
  const factory UtilityState.initial() = _Initial;

  const factory UtilityState.clearCache() = _ClearCache;
  const factory UtilityState.fetchMonitoringData() = _FetchMonitoringData;
}
