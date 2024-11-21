import 'package:flutter/foundation.dart'; // for listEquals

class MonitoringResponse {
  final List<MonitoringData>? data;
  final String? message;

  MonitoringResponse({
    this.data,
    this.message,
  });

  factory MonitoringResponse.fromJson(Map<String, dynamic> json) => MonitoringResponse(
        data:
            json["data"] == null ? [] : List<MonitoringData>.from(json["data"]!.map((x) => MonitoringData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  // Override == and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonitoringResponse && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}

class MonitoringData {
  final DateTime? timestamp;
  final int? value;

  MonitoringData({
    this.timestamp,
    this.value,
  });

  factory MonitoringData.fromJson(Map<String, dynamic> json) => MonitoringData(
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp?.toIso8601String(),
        "value": value,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonitoringData && other.timestamp == timestamp && other.value == value;
  }

  @override
  int get hashCode => timestamp.hashCode ^ value.hashCode;
}

enum DataType { solar, house, battery }

extension TypeExtension on DataType {
  String toShortString() {
    return toString().split('.').last.toLowerCase();
  }
}
