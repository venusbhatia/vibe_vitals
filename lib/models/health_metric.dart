import 'package:flutter/material.dart';

enum MetricType {
  steps,
  heartRate,
  water,
  sleep,
  digitalDetox,
  activeBreaks,
}

class HealthMetric {
  final String id;
  final String title;
  final double value;
  final String unit;
  final DateTime timestamp;
  final MetricType type;

  HealthMetric({
    required this.id,
    required this.title,
    required this.value,
    required this.unit,
    required this.timestamp,
    required this.type,
  });

  factory HealthMetric.fromJson(Map<String, dynamic> json) {
    return HealthMetric(
      id: json['id'],
      title: json['title'],
      value: json['value'].toDouble(),
      unit: json['unit'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MetricType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
    };
  }
} 