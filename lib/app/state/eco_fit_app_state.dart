import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/health_metrics.dart';
import '../../domain/services/health_metrics_calculator.dart';

class EcoFitAppState extends ChangeNotifier {
  EcoFitAppState._();

  static final EcoFitAppState instance = EcoFitAppState._();

  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async =>
      _preferences ??= await SharedPreferences.getInstance();

  String name = 'Minh Anh';
  String school = 'Đại học Kinh tế';
  int age = 20;
  String gender = 'male';
  double height = 170;
  double weight = 65;
  double activity = 1.375;
  String goal = 'lose';

  bool _loaded = false;

  String get initials {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return 'EF';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  HealthMetrics get metrics => HealthMetricsCalculator.calculate(
    age: age,
    gender: gender,
    height: height,
    weight: weight,
    activity: activity,
    goal: goal,
  );

  Future<void> load() async {
    if (_loaded) return;
    try {
      final preferences = await _prefs;
      name = preferences.getString('profile.name') ?? name;
      school = preferences.getString('profile.school') ?? school;
      age = preferences.getInt('metrics.age') ?? age;
      gender = preferences.getString('metrics.gender') ?? gender;
      height = preferences.getDouble('metrics.height') ?? height;
      weight = preferences.getDouble('metrics.weight') ?? weight;
      activity = preferences.getDouble('metrics.activity') ?? activity;
      goal = preferences.getString('metrics.goal') ?? goal;
    } catch (error) {
      debugPrint('Không thể đọc dữ liệu Eco Fit đã lưu: $error');
    } finally {
      _loaded = true;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String name,
    required String school,
  }) async {
    this.name = name.trim();
    this.school = school.trim();
    notifyListeners();
    try {
      final preferences = await _prefs;
      await Future.wait([
        preferences.setString('profile.name', this.name),
        preferences.setString('profile.school', this.school),
      ]);
    } catch (error) {
      debugPrint('Không thể lưu hồ sơ Eco Fit: $error');
    }
  }

  Future<void> updateMetrics({
    required int age,
    required String gender,
    required double height,
    required double weight,
    required double activity,
    required String goal,
  }) async {
    this.age = age;
    this.gender = gender;
    this.height = height;
    this.weight = weight;
    this.activity = activity;
    this.goal = goal;
    notifyListeners();
    try {
      final preferences = await _prefs;
      await Future.wait([
        preferences.setInt('metrics.age', age),
        preferences.setString('metrics.gender', gender),
        preferences.setDouble('metrics.height', height),
        preferences.setDouble('metrics.weight', weight),
        preferences.setDouble('metrics.activity', activity),
        preferences.setString('metrics.goal', goal),
      ]);
    } catch (error) {
      debugPrint('Không thể lưu chỉ số Eco Fit: $error');
    }
  }
}
