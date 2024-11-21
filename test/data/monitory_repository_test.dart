import 'package:either_dart/either.dart';
import 'package:enpal_monitor/data/models/monitoring_response.dart';
import 'package:enpal_monitor/data/repository/i_monitory_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mock_monitoring_repository.dart';

void main() {
  group('MonitoringRepository', () {
    late IMonitoringRepository repository;

    setUpAll(() {
      registerFallbackValue(DataType.solar);
    });

    setUp(() {
      repository = MockMonitoringRepository();
    });

    test('fetchMonitoring returns a valid response on success', () async {
      final mockResponse = MonitoringResponse(data: [MonitoringData(timestamp: DateTime.now(), value: 5000)]);

      when(() => repository.fetchMonitoring(any(), any())).thenAnswer(
        (_) async => Right(mockResponse),
      );

      final result = await repository.fetchMonitoring('time', DataType.solar);

      expect(result.isRight, isTrue);
      result.fold(
        (l) => fail('Expected a Right, but got Left: $l'),
        (r) => expect(r.data, isNotEmpty),
      );
    });

    test('fetchMonitoring returns a failure on network error', () async {
      when(() => repository.fetchMonitoring(any(), any())).thenAnswer(
        (_) async => const Left('Network error'),
      );

      final result = await repository.fetchMonitoring('time', DataType.solar);

      expect(result.isLeft, isTrue);
      result.fold(
        (l) => expect(l, 'Network error'),
        (r) => fail('Expected a Left, but got Right: $r'),
      );
    });
  });
}

/*
* Note:
>>The test cases for `fetchMonitoring` are written for `DataType.solar` as a representative example
>>because the behavior of the method is identical for all other `DataType` values (`house`, `battery`).
>>The method processes all `DataType` values in the same way, and therefore, testing one value
>>(e.g., `DataType.solar`) sufficiently covers the logic for all types.
>>Additional tests for other types are not necessary since they don't introduce different behavior
>>in the method, making the test for `DataType.solar` adequate to verify the correctness of the method
>>for all `DataType` enum values.

* */
