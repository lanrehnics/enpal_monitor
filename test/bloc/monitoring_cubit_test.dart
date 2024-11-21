import 'package:either_dart/either.dart';
import 'package:enpal_monitor/bloc/monitoring_cubit/monitoring_cubit.dart';
import 'package:enpal_monitor/data/models/monitoring_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mock_monitoring_repository.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('MonitoringCubit', () {
    late Storage storage;
    late MonitoringCubit monitoringCubit;
    late MockMonitoringRepository mockMonitoringRepository;

    setUpAll(() {
      registerFallbackValue(DataType.solar);
    });

    setUp(() {
      // Initialize the mock storage and repository
      storage = MockStorage();
      when(
        () => storage.write(any(), any<dynamic>()),
      ).thenAnswer((_) async {});
      HydratedBloc.storage = storage;

      mockMonitoringRepository = MockMonitoringRepository();
      monitoringCubit = MonitoringCubit(mockMonitoringRepository, storageKey: 'testKey');
    });

    tearDown(() {
      monitoringCubit.close();
    });

    test('should start with initial state', () {
      expect(monitoringCubit.state, equals(const MonitoringState.initial()));
    });

    test('should emit solarDataLoading and then solarDataLoadedSuccessfully on success', () async {
      final mockResponse = MonitoringResponse(data: [MonitoringData(timestamp: DateTime.now(), value: 5000)]);

      // Mock the fetchMonitoring call to return a successful response
      when(() => mockMonitoringRepository.fetchMonitoring(any(), any())).thenAnswer((_) async => Right(mockResponse));

      final time = DateTime.now();

      // Listen to the cubit state changes
      final states = <MonitoringState>[];
      monitoringCubit.stream.listen(states.add);

      // Trigger fetchSolarMonitoringData method
      monitoringCubit.fetchSolarMonitoringData(time);

      // Wait for the cubit to emit states
      await untilCalled(() => mockMonitoringRepository.fetchMonitoring(any(), any()));


      await Future.delayed(const Duration(milliseconds: 100)); // Delay to wait for state transition

      expect(states, [
        const MonitoringState.solarDataLoading(), // First emitted state
        MonitoringState.solarDataLoadedSuccessfully(mockResponse), // Final state
      ]);
    });

    test('should emit solarDataLoading and then solarDataLoadedWithError on error', () async {
      const errorMessage = 'Failed to fetch data';

      // Mock the fetchMonitoring call to return an error
      when(() => mockMonitoringRepository.fetchMonitoring(any(), any()))
          .thenAnswer((_) async => const Left(errorMessage));

      final time = DateTime.now();

      // Listen to the cubit state changes
      final states = <MonitoringState>[];
      monitoringCubit.stream.listen(states.add);

      // Trigger fetchSolarMonitoringData method
      monitoringCubit.fetchSolarMonitoringData(time);

      // Wait for the cubit to emit states
      await untilCalled(() => mockMonitoringRepository.fetchMonitoring(any(), any()));


      await Future.delayed(const Duration(milliseconds: 100)); // Delay to wait for state transition
      // Ensure all expected states are emitted
      expect(states, [
        const MonitoringState.solarDataLoading(), // First emitted state
        const MonitoringState.solarDataLoadedWithError(errorMessage), // Final state
      ]);
    });

    test('clearCache should reset to initial state', () async {
      // Mock the clear() method of HydratedBloc
      when(() => storage.delete(any())).thenAnswer((_) async => {});

      // Call the clearCache method
      monitoringCubit.clearCache();

      // Check that the state is reset to initial
      expect(monitoringCubit.state, const MonitoringState.initial());
    });

    test('toJson and fromJson should work correctly for solar data', () {
      final data = MonitoringResponse(data: [MonitoringData(timestamp: DateTime.now(), value: 5000)]);

      final state = MonitoringState.solarDataLoadedSuccessfully(data);

      // Serialize the state to JSON
      final json = monitoringCubit.toJson(state);
      expect(json, isNotNull);

      // Deserialize the JSON back to a state
      final deserializedState = monitoringCubit.fromJson(json!);
      expect(deserializedState, equals(state));
    });
  });
}
