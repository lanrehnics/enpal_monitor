import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:enpal_monitor/bloc/monitoring_cubit/monitoring_cubit.dart';
import 'package:enpal_monitor/bloc/theme_cubit/theme_cubit.dart';
import 'package:enpal_monitor/bloc/utility_cubit/utility_cubit.dart';
import 'package:enpal_monitor/data/models/monitoring_response.dart';
import 'package:enpal_monitor/data/repository/i_monitory_repository.dart';
import 'package:enpal_monitor/presentation/pages/home.dart';
import 'package:enpal_monitor/presentation/pages/views/solar_generation.dart';
import 'package:enpal_monitor/presentation/widgets/connectivity_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_monitoring_repository.dart';

class MockMonitoringCubit extends MockCubit<MonitoringState> implements MonitoringCubit {}

class MockUtilityCubit extends MockCubit<UtilityState> implements UtilityCubit {}

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

class MockStorage extends Mock implements HydratedStorage {}

void main() {
  final getIt = GetIt.instance;

  late MonitoringCubit mockMonitoringCubit;
  late MockUtilityCubit mockUtilityCubit;
  late MockThemeCubit mockThemeCubit;
  late IMonitoringRepository repository;

  late HydratedStorage storage;

  setUpAll(() {
    registerFallbackValue(DataType.solar);
    registerFallbackValue(DataType.house);
    registerFallbackValue(DataType.battery);
  });

  setUp(() {
    getIt.registerSingleton<IMonitoringRepository>(MockMonitoringRepository());

    storage = MockStorage();
    HydratedBloc.storage = storage;

    mockUtilityCubit = MockUtilityCubit();
    mockThemeCubit = MockThemeCubit();
    when(() => mockThemeCubit.state).thenReturn(ThemeMode.light);

    repository = MockMonitoringRepository();
    mockMonitoringCubit = MonitoringCubit(repository, storageKey: 'testKey');

    final mockResponse = MonitoringResponse(data: [
      MonitoringData(timestamp: DateTime.now(), value: 5000),
    ]);
    when(() => repository.fetchMonitoring(any(), any())).thenAnswer(
      (_) async => Right(mockResponse),
    );

    when(() => mockUtilityCubit.state).thenReturn(const UtilityState.initial());
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MonitoringCubit>(create: (_) => mockMonitoringCubit),
        BlocProvider<UtilityCubit>(create: (_) => mockUtilityCubit),
        BlocProvider<ThemeCubit>(create: (_) => mockThemeCubit),
      ],
      child: const MaterialApp(
        home: Home(),
      ),
    );
  }

  group('Home Widget Tests', () {
    testWidgets('renders Home widget with all elements', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pumpAndSettle();

      // Verify AppBar title
      expect(find.text('Monitoring'), findsOneWidget);

      // Verify ConnectivityStatus widget
      expect(find.byType(ConnectivityStatus), findsOneWidget);

      // Verify TabBar
      expect(find.byType(TabBar), findsOneWidget);

      // Verify TabBarView children
      expect(find.byType(SolarGenerationTab), findsOneWidget);
    });

    testWidgets('invokes clearCache on UtilityCubit when Clear Cache is selected', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Open PopupMenuButton
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Select "Clear Cache" option
      await tester.tap(find.text('Clear Cache'));
      await tester.pumpAndSettle();

      // Verify clearCache is called
      verify(() => mockUtilityCubit.clearCache()).called(1);
    });

    testWidgets('invokes toggleTheme on ThemeCubit when Switch Theme is selected', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Open PopupMenuButton
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Select "Dark Mode" option (or whatever the initial option is)
      await tester.tap(find.text('Dark Mode'));
      await tester.pumpAndSettle();

      // Verify toggleTheme is called
      verify(() => mockThemeCubit.toggleTheme()).called(1);
    });
  });
}
