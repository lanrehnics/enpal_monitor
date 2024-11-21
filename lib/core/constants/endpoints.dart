
import 'package:enpal_monitor/data/models/monitoring_response.dart';

class Endpoints {
  static String monitoring(String time, DataType type) => "/monitoring?date=$time&type=${type.toShortString()}";
}
