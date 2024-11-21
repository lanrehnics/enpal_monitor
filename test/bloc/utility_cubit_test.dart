import 'package:bloc_test/bloc_test.dart';
import 'package:enpal_monitor/bloc/utility_cubit/utility_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UtilityCubit', () {
    late UtilityCubit utilityCubit;

    setUp(() {
      utilityCubit = UtilityCubit();
    });

    tearDown(() {
      utilityCubit.close();
    });

    blocTest<UtilityCubit, UtilityState>(
      'emits [clearCache, initial] when clearCache is called',
      build: () => utilityCubit,
      act: (cubit) => cubit.clearCache(),
      wait: const Duration(seconds: 2), // Add wait to account for delayed state
      expect: () => [
        const UtilityState.clearCache(),
        const UtilityState.initial(),
      ],
    );

    blocTest<UtilityCubit, UtilityState>(
      'emits [fetchMonitoringData, initial] when fetchMonitoringData is called',
      build: () => utilityCubit,
      act: (cubit) => cubit.fetchMonitoringData(),
      wait: const Duration(seconds: 2), // Add wait to account for delayed state
      expect: () => [
        const UtilityState.fetchMonitoringData(),
        const UtilityState.initial(),
      ],
    );
  });
}
