import 'package:either_dart/either.dart';
import 'package:enpal_monitor/core/constants/endpoints.dart';
import 'package:enpal_monitor/core/network/network_provider.dart';
import 'package:enpal_monitor/data/models/monitoring_response.dart';
import 'package:enpal_monitor/data/repository/i_monitory_repository.dart';

class MonitoringRepository implements IMonitoringRepository {
  final NetworkProvider _network;

  MonitoringRepository(this._network);

  @override
  Future<Either<String, MonitoringResponse>> fetchMonitoring(String time, DataType type) async {
    late Either<String, MonitoringResponse> res;
    try {
      final response = await _network.call(Endpoints.monitoring(time, type), RequestMethod.get);
      if ([200, 201].contains(response.statusCode)) {
        res = Right(MonitoringResponse.fromJson({"data": response.data}));
      } else {
        res = Left(MonitoringResponse.fromJson(response.data).message ?? '');
      }
    } catch (e) {
      res = Left(e.toString());
    }
    return res;
  }
}
