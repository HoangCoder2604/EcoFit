class HealthMetrics {
  const HealthMetrics({
    required this.bmr,
    required this.tdee,
    required this.calories,
    required this.bmi,
    required this.bmiLabel,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  final int bmr;
  final int tdee;
  final int calories;
  final double bmi;
  final String bmiLabel;
  final int protein;
  final int fat;
  final int carbs;
}
