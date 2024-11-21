import 'package:either_dart/either.dart';
import 'package:enpal_monitor/data/models/monitoring_response.dart';

/// An abstract class that defines the contract for fetching monitoring data.
///
/// This repository interface is intended to be implemented by classes that handle data fetching
/// from an external source (e.g., a REST API) for solar, house, or battery monitoring.
///
/// Methods:
/// - **fetchMonitoring**: A method that fetches monitoring data based on the provided time and data type.
///   - Parameters:
///     - `time`: A `String` representing the date in the format `yyyy-MM-dd` for which data is to be fetched.
///     - `type`: A `DataType` enum that specifies which type of monitoring data is being requested (e.g., solar, battery).
///   - Returns: A `Future` that resolves to an `Either<String, MonitoringResponse>`, indicating either an error message (`String`)
///     or the successfully fetched monitoring data (`MonitoringResponse`).
///
/// Example Usage:
/// ```dart
/// final monitoringRepository = MonitoringRepositoryImpl();
/// final result = await monitoringRepository.fetchMonitoring('2024-11-01', DataType.battery);
/// result.fold(
///   (error) => print("Error: $error"), // Handle error
///   (data) => print("Fetched data: $data"), // Handle fetched data
/// );
/// ```
abstract class IMonitoringRepository {
  /// Fetches monitoring data for the given time and type.
  ///
  /// - `time`: The date for which monitoring data is requested.
  /// - `type`: The type of monitoring data (solar, house, or battery).
  ///
  /// Returns a `Future` containing either an error message (`String`) or the monitoring response (`MonitoringResponse`).
  Future<Either<String, MonitoringResponse>> fetchMonitoring(String time, DataType type);
}
