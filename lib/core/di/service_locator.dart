import 'package:enpal_monitor/core/constants/app_config.dart';
import 'package:enpal_monitor/core/network/network_provider.dart';
import 'package:enpal_monitor/data/repository/i_monitory_repository.dart';
import 'package:enpal_monitor/data/repository/monitory_repository.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance; // Service Locator

void setupDependencies() {
  // Register NetworkProvider
  sl.registerLazySingleton<NetworkProvider>(() => NetworkProvider(baseUrl: AppConfig.baseUrl));

  // Register the Repository
  sl.registerLazySingleton<IMonitoringRepository>(
        () => MonitoringRepository(sl<NetworkProvider>()),
  );
}
