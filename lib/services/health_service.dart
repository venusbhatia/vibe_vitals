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

  // In-memory cache
  final Map<MetricType, List<HealthMetric>> _cache = {};

  // Singleton instance
  static final HealthService _instance = HealthService._internal();

  factory HealthService() {
    return _instance;
  }

  HealthService._internal();

  // Get the storage key for a metric type
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

  // Add a new health metric
  Future<void> addMetric(HealthMetric metric) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getKeyForType(metric.type);
    
    // Get existing data
    final List<HealthMetric> metrics = await getMetrics(metric.type);
    metrics.add(metric);
    
    // Update cache
    _cache[metric.type] = metrics;
    
    // Save to storage
    final jsonList = metrics.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  // Get metrics by type
  Future<List<HealthMetric>> getMetrics(MetricType type) async {
    // Return from cache if available
    if (_cache.containsKey(type)) {
      return _cache[type]!;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final key = _getKeyForType(type);
    final jsonList = prefs.getStringList(key) ?? [];
    
    final metrics = jsonList
        .map((jsonStr) => HealthMetric.fromJson(jsonDecode(jsonStr)))
        .toList();
    
    // Update cache
    _cache[type] = metrics;
    
    return metrics;
  }

  // Get the latest metric value by type
  Future<double> getLatestValue(MetricType type) async {
    final metrics = await getMetrics(type);
    if (metrics.isEmpty) {
      return 0;
    }
    
    // Sort by timestamp (descending) and get the first one
    metrics.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return metrics.first.value;
  }

  // Get the sum of today's metrics by type
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

  // Generate a unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  // Create a new health metric
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