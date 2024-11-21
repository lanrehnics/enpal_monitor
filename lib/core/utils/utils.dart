import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:enpal_monitor/core/constants/app_color.dart';
import 'package:enpal_monitor/data/models/monitoring_response.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> showDateSelector(BuildContext ctx, DateTime? selectedTime, Function(DateTime date) callback) async {
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    selectedTime,
  ];

  ValueNotifier<DateTime?> dateNotify = ValueNotifier<DateTime?>(selectedTime);

  final isDarkMode = Theme.of(ctx).brightness == Brightness.dark;

  showModalBottomSheet(
    elevation: 10,
    isDismissible: true,
    backgroundColor: Theme.of(ctx).cardColor,
    // Use theme card color
    barrierColor: isDarkMode ? Colors.black.withOpacity(0.9) : Colors.black.withOpacity(0.7),
    // Adjust based on theme
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
    ),
    context: ctx,
    builder: (context) => Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          top: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Spacer(),
                  Container(
                    width: 108,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: BorderSide(
                          width: 1.8,
                          color: isDarkMode ? Colors.grey[700]! : const Color(0xFFD9D9D9), // Dark mode adjustment
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Select Date',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.4,
                      color: isDarkMode ? Colors.white10 : Colors.black12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.single,
                  centerAlignModePicker: true,
                  lastDate: DateTime.now(),
                  nextMonthIcon: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: isDarkMode ? Colors.white70 : Colors.black,
                    ),
                  ),
                  lastMonthIcon: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 11,
                      color: isDarkMode ? Colors.white70 : Colors.black,
                    ),
                  ),
                  customModePickerIcon: const Icon(
                    Icons.circle,
                    color: Colors.transparent,
                  ),
                  selectedDayHighlightColor: accentColour,
                  controlsTextStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: _singleDatePickerValueWithDefaultValue,
                onValueChanged: (dates) {
                  _singleDatePickerValueWithDefaultValue = dates;
                  dateNotify.value = dates[0];
                },
              ),
              const SizedBox(height: 5),
              ValueListenableBuilder(
                valueListenable: dateNotify,
                builder: (_, DateTime? v, __) {
                  return (v == null)
                      ? const SizedBox()
                      : Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 100,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  color: isDarkMode ? Colors.grey[800] : const Color(0x266C7A93),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.grey[300] : const Color(0xF26C7A93),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                if (dateNotify.value != null) {
                                  Navigator.of(context).pop();
                                  callback(dateNotify.value!);
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  color: Theme.of(ctx).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: const Text(
                                  'Apply',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                          ],
                        );
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    ),
  );
}


void showErrorSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    ),
    backgroundColor: Colors.redAccent,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.white,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

LineChartData mainData(List<MonitoringData>? data, bool useKiloWatt) {
  final chartData = (data ?? []).map((entry) {
    return FlSpot((entry.timestamp)!.millisecondsSinceEpoch.toDouble(), (entry.value)!.toDouble());
  }).toList();

  final minX = chartData.first.x;
  final maxX = chartData.last.x;

  List<FlSpot> downsampledData = [];
  int step = (chartData.length / 20).ceil(); // Keep a maximum of 20 points
  for (int i = 0; i < chartData.length; i += step) {
    downsampledData.add(chartData[i]);
  }

  return LineChartData(
    minX: minX,
    maxX: maxX,
    minY: chartData.map((e) => e.y).reduce((a, b) => a < b ? a : b),
    maxY: chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 2000,
    lineBarsData: [
      LineChartBarData(
        spots: downsampledData, // Use downsampled data for fewer points
        isCurved: true, // Smooth curve
        gradient: const LinearGradient(colors: [
          contentColorCyan,
          contentColorBlue,
        ]),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              contentColorCyan,
              contentColorBlue,
            ].map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ),
    ],
    titlesData: FlTitlesData(
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false), // Remove right titles
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false), // Remove top titles
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 16,
          interval: (maxX - minX) / 3, // Reduce the number of x-axis labels
          getTitlesWidget: (value, meta) {
            final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
            return Text(
              DateFormat('HH:mm').format(date),
              style: const TextStyle(fontSize: 10),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 60,
          interval: 3000, // Fewer labels on y-axis for readability
          getTitlesWidget: (value, meta) {
            return useKiloWatt
                ? Text(
                    '${value ~/ 1000}kW', // Show values in thousands (e.g., "1kW")
                    style: const TextStyle(fontSize: 9),
                  )
                : Text(
                    '${value}W', // Show values in wattage (e.g., "1000W")
                    style: const TextStyle(fontSize: 9),
                  );
          },
        ),
      ),
    ),
    gridData: FlGridData(
      show: false,
      drawVerticalLine: false,
      verticalInterval: (maxX - minX) / 4, // Sync grid with fewer x-axis intervals
      horizontalInterval: 1000, // Sync grid with y-axis intervals
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey, width: 1), // Add a border for clarity
    ),
  );
}

// Dummy place holder widget
Widget dummyChart() => AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: 6,
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 3),
                  FlSpot(2.6, 2),
                  FlSpot(4.9, 5),
                  FlSpot(6.8, 3.1),
                  FlSpot(8, 4),
                  FlSpot(9.5, 3),
                  FlSpot(11, 4),
                ],
                isCurved: true, // Smooth curve
                gradient: const LinearGradient(
                  colors: [
                    contentColorCyan,
                    contentColorBlue,
                  ],
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      contentColorCyan,
                      contentColorBlue,
                    ].map((color) => color.withOpacity(0.3)).toList(),
                  ),
                ),
              ),
            ],
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Remove right titles
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Remove top titles
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 16,
                  interval: 1, // Reduce the number of x-axis labels
                  getTitlesWidget: (value, meta) {
                    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return const Text(
                     '',
                      style: TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60,
                  interval: 3000, // Fewer labels on y-axis for readability
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value ~/ 1000}kW', // Show values in thousands (e.g., "1kW")
                      style: const TextStyle(fontSize: 9),
                    );
                  },
                ),
              ),
            ),
            gridData: const FlGridData(
              show: false,
              drawVerticalLine: false,
              horizontalInterval: 1,
              verticalInterval: 1, //Sync grid with y-axis intervals
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey, width: 1), // Add a border for clarity
            ),
          ),
        ),
      ),
    );
Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  Widget text;
  switch (value.toInt()) {
    case 2:
      text = const Text('00:00', style: style);
      break;
    case 5:
      text = const Text('10:20', style: style);
      break;
    case 8:
      text = const Text('12:00', style: style);
      break;
    default:
      text = const Text('23:59', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  String text;
  switch (value.toInt()) {
    case 1:
      text = '10KW';
      break;
    case 3:
      text = '30kW';
      break;
    case 5:
      text = '50kW';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}
