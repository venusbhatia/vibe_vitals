import 'dart:convert';
import 'dart:math';
import 'package:health_monitor/models/health_metric.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthService {
  static const String _stepsKey = 'steps_data';
  static const String _heartRateKey = 'heart_rate_data';
  static const String _waterKey = 'water_data';
  static const String _sleepKey = 'sleep_data';
  static const String _digitalDetoxKey = 'digital_detox_data';
  static const String _activeBreaksKey = 'active_breaks_data';

  final Map<MetricType, List<HealthMetric>> _cache = {};

  static final HealthService _instance = HealthService._internal();

  factory HealthService() {
    return _instance;
  }

  HealthService._internal();

  String _getKeyForType(MetricType type) {
    switch (type) {
      case MetricType.steps:
        return _stepsKey;
      case MetricType.heartRate:
        return _heartRateKey;
      case MetricType.water:
        return _waterKey;
      case MetricType.sleep:
        return _sleepKey;
      case MetricType.digitalDetox:
        return _digitalDetoxKey;
      case MetricType.activeBreaks:
        return _activeBreaksKey;
    }
  }

  Future<void> addMetric(HealthMetric metric) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getKeyForType(metric.type);
    
    final List<HealthMetric> metrics = await getMetrics(metric.type);
    metrics.add(metric);
    
    _cache[metric.type] = metrics;
    
    final jsonList = metrics.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  Future<List<HealthMetric>> getMetrics(MetricType type) async {
    if (_cache.containsKey(type)) {
      return _cache[type]!;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final key = _getKeyForType(type);
    final jsonList = prefs.getStringList(key) ?? [];
    
    final metrics = jsonList
        .map((jsonStr) => HealthMetric.fromJson(jsonDecode(jsonStr)))
        .toList();
    
    _cache[type] = metrics;
    
    return metrics;
  }

  Future<double> getLatestValue(MetricType type) async {
    final metrics = await getMetrics(type);
    if (metrics.isEmpty) {
      return 0;
    }
    
    metrics.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return metrics.first.value;
  }

  Future<double> getTodayTotal(MetricType type) async {
    final metrics = await getMetrics(type);
    if (metrics.isEmpty) {
      return 0;
    }
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    double total = 0;
    for (var metric in metrics) {
      if (metric.timestamp.isAfter(today)) {
        total += metric.value;
      }
    }
    
    return total;
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  HealthMetric createMetric({
    required String title,
    required double value,
    required String unit,
    required MetricType type,
  }) {
    return HealthMetric(
      id: _generateId(),
      title: title,
      value: value,
      unit: unit,
      timestamp: DateTime.now(),
      type: type,
    );
  }
} 