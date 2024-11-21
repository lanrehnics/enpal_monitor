import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:enpal_monitor/bloc/monitoring_cubit/monitoring_cubit.dart';
import 'package:enpal_monitor/bloc/utility_cubit/utility_cubit.dart';
import 'package:enpal_monitor/data/models/monitoring_response.dart';
import 'package:enpal_monitor/presentation/pages/views/house_consumption.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shimmer/shimmer.dart';

import '../../../mocks/mock_monitoring_repository.dart';

class MockMonitoringCubit extends MockCubit<MonitoringState> implements MonitoringCubit {}

class MockUtilityCubit extends MockCubit<UtilityState> implements UtilityCubit {}

void main() {
  late MockMonitoringCubit mockMonitoringCubit;
  late MockMonitoringRepository mockMonitoringRepository;
  late MockUtilityCubit mockUtilityCubit;

  setUpAll(() {
    registerFallbackValue(DataType.house);
  });

  setUp(() {
    mockMonitoringRepository = MockMonitoringRepository();
    mockMonitoringCubit = MockMonitoringCubit();
    mockUtilityCubit = MockUtilityCubit();

    // Set up your mock repository to return the expected data
    final mockResponse = MonitoringResponse(data: [MonitoringData(timestamp: DateTime.now(), value: 5000)]);
    when(() => mockMonitoringRepository.fetchMonitoring(any(), any())).thenAnswer((_) async => Right(mockResponse));

    // Mock initial states
    when(() => mockMonitoringCubit.state).thenReturn(const MonitoringStateInitial());
    when(() => mockUtilityCubit.state).thenReturn(const UtilityState.initial());
  });

  tearDown(() {
    mockUtilityCubit.close();
    mockMonitoringCubit.close();
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MonitoringCubit>(create: (_) => mockMonitoringCubit),
        BlocProvider<UtilityCubit>(create: (_) => mockUtilityCubit),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: HouseConsumptionTab(),
        ),
      ),
    );
  }

  group('HouseConsumptionTab Tests', () {
    testWidgets('displays initial elements correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Ensure SingleChildScrollView is displayed
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Check for Container but allow it to be present (since Cardo uses it)
      expect(find.byType(Container), findsNWidgets(3)); // Expecting 3 Containers

      // Check that LineChart is not displayed initially (since data is likely loading)
      expect(find.byType(LineChart), findsNothing);
    });

    testWidgets('shows line chart when house consumption data is loaded successfully', (tester) async {
      List<Map<String, dynamic>> data = [
        {"timestamp": "2025-11-16T20:55:00.000Z", "value": 8579},
        {"timestamp": "2025-11-16T21:00:00.000Z", "value": 3981},
        {"timestamp": "2025-11-16T21:05:00.000Z", "value": 4573},
        {"timestamp": "2025-11-16T21:10:00.000Z", "value": 5401},
        {"timestamp": "2025-11-16T21:15:00.000Z", "value": 2459},
        {"timestamp": "2025-11-16T21:20:00.000Z", "value": 1781},
        {"timestamp": "2025-11-16T21:25:00.000Z", "value": 3955},
        {"timestamp": "2025-11-16T21:30:00.000Z", "value": 7024},
        {"timestamp": "2025-11-16T21:35:00.000Z", "value": 6991},
        {"timestamp": "2025-11-16T21:40:00.000Z", "value": 2465},
        {"timestamp": "2025-11-16T21:45:00.000Z", "value": 5531},
        {"timestamp": "2025-11-16T21:50:00.000Z", "value": 8504},
        {"timestamp": "2025-11-16T21:55:00.000Z", "value": 4658},
        {"timestamp": "2025-11-16T22:00:00.000Z", "value": 8311},
        {"timestamp": "2025-11-16T22:05:00.000Z", "value": 2795},
        {"timestamp": "2025-11-16T22:10:00.000Z", "value": 2363},
        {"timestamp": "2025-11-16T22:15:00.000Z", "value": 3383},
        {"timestamp": "2025-11-16T22:20:00.000Z", "value": 6643},
        {"timestamp": "2025-11-16T22:25:00.000Z", "value": 1466},
        {"timestamp": "2025-11-16T22:30:00.000Z", "value": 1942},
        {"timestamp": "2025-11-16T22:35:00.000Z", "value": 7484},
        {"timestamp": "2025-11-16T22:40:00.000Z", "value": 8165},
        {"timestamp": "2025-11-16T22:45:00.000Z", "value": 4265},
      ];

      // Convert the List of Maps to a List of MonitoringData
      List<MonitoringData> mockData = data.map((item) {
        return MonitoringData(
          timestamp: DateTime.parse(item['timestamp']),
          value: item['value'],
        );
      }).toList();

      // Ensure that mockMonitoringCubit emits the correct state
      whenListen(
        mockMonitoringCubit,
        Stream.fromIterable([HouseDataLoadedSuccessfully(MonitoringResponse(data: mockData))]),
        initialState: const MonitoringStateInitial(),
      );

      // Trigger widget rendering and state change
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 10)); // Increased timeout duration

      // Ensure the LineChart widget is rendered
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('shows loading animation when house consumption data is loading', (tester) async {
      // Emit loading state
      whenListen(
        mockMonitoringCubit,
        Stream.fromIterable([const HouseDataLoading()]),
        initialState: const MonitoringStateInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100)); // Avoid pumpAndSettle timeout

      // Verify Shimmer widget (from loading animation) is displayed
      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('shows error snackbar when house consumption data fails to load', (tester) async {
      const errorMessage = 'Failed to load house consumption data';

      // Emit error state
      whenListen(
        mockMonitoringCubit,
        Stream.fromIterable([const HouseDataLoadedWithError(errorMessage)]),
        initialState: const MonitoringStateInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify Snackbar with error is shown
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('calls fetchHouseConsumptionData on refresh', (WidgetTester tester) async {
      // Stub the fetchHouseConsumptionData method
      when(() => mockMonitoringCubit.fetchHouseConsumptionData(any(), force: true)).thenAnswer((_) async {});

      // Build the widget tree
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<UtilityCubit>.value(value: mockUtilityCubit),
            BlocProvider<MonitoringCubit>.value(value: mockMonitoringCubit),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: HouseConsumptionTab(),
            ),
          ),
        ),
      );

      Logger().d('Cubit in widget tree: ${tester.firstWidget(find.byType(BlocProvider<MonitoringCubit>))}');

      // Ensure RefreshIndicator is present
      expect(find.byType(RefreshIndicator), findsOneWidget);

      // Simulate a pull-to-refresh gesture
      await tester.fling(find.byType(RefreshIndicator), const Offset(0, 300), 1000);

      await tester.pumpAndSettle(const Duration(seconds: 2)); // Wait a bit longer to settle

      // Verify that the fetchHouseConsumptionData was called at least once
      verify(() => mockMonitoringCubit.fetchHouseConsumptionData(any(), force: true)).called(1);
    });
  });
}
