import 'package:enpal_monitor/bloc/monitoring_cubit/monitoring_cubit.dart';
import 'package:enpal_monitor/bloc/utility_cubit/utility_cubit.dart';
import 'package:enpal_monitor/core/constants/app_color.dart';
import 'package:enpal_monitor/core/utils/after_build.dart';
import 'package:enpal_monitor/core/utils/utils.dart';
import 'package:enpal_monitor/presentation/pages/mixins/ui_mixin.dart';
import 'package:enpal_monitor/presentation/widgets/card_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget representing the House Consumption tab.
///
/// Displays house consumption data in a chart and provides user controls
/// for selecting the date and units to display (e.g., kilowatts or other units).
///
/// This widget listens for state changes in the `UtilityCubit` to refresh data
/// and shows a line chart based on the monitoring data fetched from the backend.
///
/// The widget also supports pull-to-refresh functionality and handles errors
/// by displaying an error snack bar.

class HouseConsumptionTab extends StatefulWidget {
  const HouseConsumptionTab({super.key});

  @override
  State<StatefulWidget> createState() => _HouseConsumptionState();
}

class _HouseConsumptionState extends State<HouseConsumptionTab>
    with MonitoringMixin, AutomaticKeepAliveClientMixin, AfterBuild {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<UtilityCubit, UtilityState>(
      listener: (_, state) {
        state.maybeWhen(
            clearCache: () => BlocProvider.of<MonitoringCubit>(context).clearCache(),
            fetchMonitoringData: () =>
                BlocProvider.of<MonitoringCubit>(context).fetchHouseConsumptionData(dateNotify.value),
            orElse: () {});
      },
      child: RefreshIndicator(
          backgroundColor: Colors.white,
          color: accentColour,
          onRefresh: () async {
            BlocProvider.of<MonitoringCubit>(context).fetchHouseConsumptionData(dateNotify.value, force: true);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                dateSelector(context, () {
                  showDateSelector(context, dateNotify.value, (DateTime selectedDate) {
                    dateNotify.value = selectedDate;
                    BlocProvider.of<MonitoringCubit>(context).fetchHouseConsumptionData(dateNotify.value, force: true);
                  });
                }),
                const SizedBox(
                  height: 30,
                ),
                unitSwitch(),
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<MonitoringCubit, MonitoringState>(listener: (_, state) {
                  if (state is HouseDataLoadedWithError) {
                    showErrorSnackBar(context, state.error);
                  }
                }, builder: (_, state) {
                  return state.maybeWhen(
                      houseDataLoading: () => lineChartLoadingAnimation(),
                      houseDataLoadedSuccessfully: (res) => ElevatedContainer(
                              child: AspectRatio(
                            aspectRatio: 1.70,
                            child: ValueListenableBuilder(
                                valueListenable: useKiloWattNotify,
                                builder: (_, bool useKiloWatt, __) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      right: 18,
                                      left: 12,
                                      top: 24,
                                      bottom: 12,
                                    ),
                                    child: LineChart(
                                      mainData(res.data, useKiloWatt),
                                    ),
                                  );
                                }),
                          )),
                      orElse: () => const SizedBox.shrink());
                })
              ],
            ),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void afterBuild(BuildContext context) {
    BlocProvider.of<MonitoringCubit>(context).fetchHouseConsumptionData(DateTime.now());
  }
}
