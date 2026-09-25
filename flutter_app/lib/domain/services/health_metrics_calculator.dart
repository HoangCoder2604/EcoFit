import '../models/health_metrics.dart';

abstract final class HealthMetricsCalculator {
  static HealthMetrics calculate({
    required int age,
    required String gender,
    required double height,
    required double weight,
    required double activity,
    required String goal,
  }) {
    if (age <= 0 || height <= 0 || weight <= 0 || activity <= 0) {
      throw ArgumentError('Các chỉ số cơ thể phải lớn hơn 0.');
    }

    final sexOffset = gender == 'male' ? 5 : -161;
    final bmr = (10 * weight + 6.25 * height - 5 * age + sexOffset).round();
    final tdee = (bmr * activity).round();
    final calories = tdee + _goalAdjustment(goal);
    final bmi = double.parse(
      (weight / ((height / 100) * (height / 100))).toStringAsFixed(1),
    );
    final protein = (weight * (goal == 'gain' ? 2 : 1.8)).round();
    final fat = (weight * .9).round();
    final carbs = ((calories - protein * 4 - fat * 9) / 4).round().clamp(
      0,
      9999,
    );

    return HealthMetrics(
      bmr: bmr,
      tdee: tdee,
      calories: calories,
      bmi: bmi,
      bmiLabel: _bmiLabel(bmi),
      protein: protein,
      fat: fat,
      carbs: carbs,
    );
  }

  static int _goalAdjustment(String goal) => switch (goal) {
    'gain' => 250,
    'lose' => -350,
    _ => 0,
  };

  static String _bmiLabel(double bmi) => switch (bmi) {
    < 18.5 => 'Hơi nhẹ cân',
    < 25 => 'Bình thường',
    < 30 => 'Hơi cao',
    _ => 'Cao',
  };
}

HealthMetrics calculateMetrics({
  required int age,
  required String gender,
  required double height,
  required double weight,
  required double activity,
  required String goal,
}) {
  return HealthMetricsCalculator.calculate(
    age: age,
    gender: gender,
    height: height,
    weight: weight,
    activity: activity,
    goal: goal,
  );
}
