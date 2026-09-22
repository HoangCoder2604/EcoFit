import 'package:eco_fit/domain/models/health_metrics.dart';
import 'package:eco_fit/domain/services/health_metrics_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HealthMetricsCalculator', () {
    test('tính đúng BMI, BMR và TDEE cho dữ liệu mẫu', () {
      final result = HealthMetricsCalculator.calculate(
        age: 20,
        gender: 'male',
        height: 170,
        weight: 65,
        activity: 1.375,
        goal: 'lose',
      );

      expect(result.bmi, 22.5);
      expect(result.bmiLabel, 'Bình thường');
      expect(result.bmr, 1618);
      expect(result.tdee, 2225);
      expect(result.calories, 1875);
      expect(result.protein, 117);
      expect(result.fat, 59);
      expect(result.carbs, 219);
    });

    test('điều chỉnh calories theo mục tiêu', () {
      HealthMetrics calculate(String goal) => HealthMetricsCalculator.calculate(
        age: 25,
        gender: 'female',
        height: 160,
        weight: 55,
        activity: 1.2,
        goal: goal,
      );

      final maintain = calculate('maintain');
      expect(calculate('gain').calories, maintain.calories + 250);
      expect(calculate('lose').calories, maintain.calories - 350);
    });

    test('không chấp nhận đầu vào không hợp lệ', () {
      expect(
        () => HealthMetricsCalculator.calculate(
          age: 0,
          gender: 'male',
          height: 170,
          weight: 65,
          activity: 1.2,
          goal: 'maintain',
        ),
        throwsArgumentError,
      );
    });
  });
}
