import 'package:enpal_monitor/core/constants/app_color.dart';
import 'package:enpal_monitor/core/utils/utils.dart';
import 'package:enpal_monitor/presentation/widgets/card_container.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

mixin MonitoringMixin {
  ValueNotifier<DateTime?> dateNotify = ValueNotifier(null);
  ValueNotifier<bool> useKiloWattNotify = ValueNotifier<bool>(false);

  // Loading animation for line chart
  Widget lineChartLoadingAnimation() => ElevatedContainer(
        child: Shimmer.fromColors(
          baseColor: containerBackground,
          highlightColor: Colors.grey.withOpacity(0.1),
          child: dummyChart(),
        ),
      );

  // Date selection widget
  Widget dateSelector(BuildContext context, VoidCallback callback) => GestureDetector(
        onTap: callback,
        child: ElevatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: accentColour,
                size: 20,
              ),
              const Spacer(),
              ValueListenableBuilder<DateTime?>(
                valueListenable: dateNotify,
                builder: (_, DateTime? dateTime, __) {
                  return Text(DateFormat("yyyy-MM-dd").format(dateNotify.value ?? DateTime.now()));
                },
              ),
            ],
          ),
        ),
      );

  // Unit switch widget (Watts <-> kiloWatts)
  Widget unitSwitch() => FlipCard(
        fill: Fill.fillBack,
        direction: FlipDirection.VERTICAL,
        side: CardSide.FRONT,
        front: ElevatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.swap_horizontal_circle_outlined,
                color: accentColour,
                size: 20,
              ),
              Text('Watts'),
            ],
          ),
        ),
        back: ElevatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.swap_horizontal_circle_outlined,
                color: accentColour,
                size: 20,
              ),
              Text('kiloWatts'),
            ],
          ),
        ),
        onFlip: () {
          useKiloWattNotify.value = !useKiloWattNotify.value;
        },
      );
}
