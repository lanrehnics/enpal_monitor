import 'package:enpal_monitor/bloc/monitoring_cubit/monitoring_cubit.dart';
import 'package:enpal_monitor/bloc/theme_cubit/theme_cubit.dart';
import 'package:enpal_monitor/bloc/utility_cubit/utility_cubit.dart';
import 'package:enpal_monitor/core/di/service_locator.dart';
import 'package:enpal_monitor/core/utils/after_build.dart';
import 'package:enpal_monitor/core/utils/bubble_tab_indicator.dart';
import 'package:enpal_monitor/core/utils/periodic_timer.dart';
import 'package:enpal_monitor/data/models/monitoring_response.dart';
import 'package:enpal_monitor/data/repository/i_monitory_repository.dart';
import 'package:enpal_monitor/presentation/pages/views/battery_consumption.dart';
import 'package:enpal_monitor/presentation/pages/views/house_consumption.dart';
import 'package:enpal_monitor/presentation/pages/views/solar_generation.dart';
import 'package:enpal_monitor/presentation/widgets/connectivity_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// A StatefulWidget representing the home screen of the Enpal Monitor app.
/// This screen provides tabs for solar generation, house consumption, and battery consumption data.
///
/// The widget can optionally enable polling to fetch monitoring data periodically.
///
/// Properties:
/// - `enablePolling`: A boolean to control whether periodic polling is enabled for data fetching.
class Home extends StatefulWidget {
  final bool enablePolling;

  const Home({this.enablePolling = false, super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterBuild {
  PeriodicTimer? periodicTimer;
  final IMonitoringRepository repository = sl<IMonitoringRepository>();

  @override
  void initState() {
    // Initialize polling if enabled
    if (widget.enablePolling) {
      periodicTimer = PeriodicTimer(const Duration(seconds: 10));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Monitoring'), // AppBar with the title 'Monitoring'
          actions: const [
            _OptionsMenu(), // Options menu with cache clearing and theme toggling
          ],
        ),
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              const SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConnectivityStatus(), // Displays connectivity status
                    SizedBox(height: 20),
                    _MonitoringTabBar(), // Custom TabBar for navigation
                  ],
                ),
              ),
            ],
            body: TabBarView(
              children: [
                // Solar Generation tab
                BlocProvider(
                  create: (_) => MonitoringCubit(repository, storageKey: DataType.solar.toShortString()),
                  child: const SolarGenerationTab(),
                ),
                // House Consumption tab
                BlocProvider(
                  create: (_) => MonitoringCubit(repository, storageKey: DataType.house.toShortString()),
                  child: const HouseConsumptionTab(),
                ),
                // Battery Consumption tab
                BlocProvider(
                  create: (_) => MonitoringCubit(repository, storageKey: DataType.battery.toShortString()),
                  child: const BatteryConsumptionTab(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void afterBuild(BuildContext context) {
    // Trigger data fetching when the widget is built
    BlocProvider.of<UtilityCubit>(context).fetchMonitoringData();

    // Start polling for data periodically if enabled
    periodicTimer?.startTimer(() {
      BlocProvider.of<UtilityCubit>(context).fetchMonitoringData();
      Logger().i("Data polling");
    });
  }
}

/// A widget representing the options menu in the AppBar.
/// This menu allows the user to clear the cache and toggle between light and dark themes.
class _OptionsMenu extends StatelessWidget {
  const _OptionsMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle options menu selection
        switch (value) {
          case 'clearCache':
            BlocProvider.of<UtilityCubit>(context).clearCache();
            break;
          case 'switchTheme':
            BlocProvider.of<ThemeCubit>(context).toggleTheme();
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          // Option to clear cache
          const PopupMenuItem<String>(
            value: 'clearCache',
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.grey,
                ),
                SizedBox(width: 8),
                Text('Clear Cache'),
              ],
            ),
          ),
          // Option to toggle theme (light/dark)
          PopupMenuItem<String>(
            value: 'switchTheme',
            child: Row(
              children: [
                const Icon(
                  Icons.color_lens_rounded,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(Theme.of(context).brightness == Brightness.dark ? 'Light Mode' : 'Dark Mode'),
              ],
            ),
          ),
        ];
      },
    );
  }
}

/// A widget that displays a custom TabBar with tabs for Solar, House, and Battery data.
/// This TabBar is styled based on the current theme (light or dark).
class _MonitoringTabBar extends StatelessWidget {
  const _MonitoringTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? Theme.of(context).cardColor : Colors.white,
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : const Color(0xFFCCDBFD),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: isDarkMode ? Colors.grey[400] : const Color(0xFF0C1B3D),
        unselectedLabelStyle: const TextStyle(fontSize: 15),
        labelColor: Colors.white,
        labelStyle: const TextStyle(fontSize: 15),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        indicator: BubbleTabIndicator(
          indicatorHeight: 39.0,
          indicatorColor: Theme.of(context).primaryColor,
          tabBarIndicatorSize: TabBarIndicatorSize.label,
        ),
        tabs: const [
          Tab(child: Text('Solar')),
          Tab(child: Text('House')),
          Tab(child: Text('Battery')),
        ],
      ),
    );
  }
}
