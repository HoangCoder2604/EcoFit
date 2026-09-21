class Meal {
  const Meal(
    this.id,
    this.type,
    this.name,
    this.kcal,
    this.protein,
    this.carbs,
    this.fat,
    this.price,
    this.tag,
    this.emoji,
  );
  final String id, type, name, tag, emoji;
  final int kcal, protein, carbs, fat, price;
}

const meals = [
  Meal(
    'oatmeal',
    'Bữa sáng',
    'Yến mạch trái cây',
    420,
    15,
    58,
    12,
    16000,
    'Tiết kiệm',
    '🥣',
  ),
  Meal(
    'chicken-rice',
    'Bữa trưa',
    'Cơm gà rau củ',
    520,
    35,
    65,
    12,
    29000,
    'Phổ biến',
    '🍱',
  ),
  Meal(
    'yogurt',
    'Bữa phụ',
    'Sữa chua + chuối',
    180,
    10,
    28,
    4,
    12000,
    'Giàu protein',
    '🍌',
  ),
  Meal(
    'salmon',
    'Bữa tối',
    'Cá hồi + khoai lang',
    480,
    30,
    45,
    16,
    35000,
    'Tốt cho sức khỏe',
    '🐟',
  ),
];

class GroceryGroup {
  const GroceryGroup(this.title, this.icon, this.items);
  final String title, icon;
  final List<(String, int)> items;
}

const groceryGroups = [
  GroceryGroup('Protein', '🥩', [
    ('Ức gà (500g)', 45000),
    ('Trứng (10 quả)', 30000),
    ('Cá hồi (200g)', 55000),
  ]),
  GroceryGroup('Rau củ', '🥦', [
    ('Rau cải bó xôi (300g)', 15000),
    ('Bông cải xanh (300g)', 20000),
    ('Cà rốt (500g)', 10000),
    ('Cà chua (500g)', 15000),
  ]),
  GroceryGroup('Tinh bột', '🍚', [
    ('Gạo lứt (1kg)', 25000),
    ('Khoai lang (1kg)', 22000),
    ('Yến mạch (500g)', 28000),
  ]),
];

const workoutDays = [
  ('Thứ 4', 'Upper Body', 'Ngực · Vai · Tay sau', '🏋️'),
  ('Thứ 5', 'Lower Body', 'Chân · Mông', '🦵'),
  ('Thứ 6', 'Core & Cardio', 'Bụng · Thể lực', '🏃'),
  ('Thứ 7', 'Full Body', 'Toàn thân', '💪'),
  ('Chủ nhật', 'Nghỉ ngơi', 'Phục hồi cơ thể', '💚'),
];

const exercises = [
  ('Bench Press', '4 hiệp × 8–12 reps', 'Nghỉ 60s', '🏋️'),
  ('Incline Dumbbell Press', '3 hiệp × 8–12 reps', 'Nghỉ 60s', '💪'),
  ('Shoulder Press', '3 hiệp × 8–12 reps', 'Nghỉ 60s', '🏋️'),
  ('Lateral Raise', '3 hiệp × 12–15 reps', 'Nghỉ 45s', '🙆'),
  ('Tricep Pushdown', '3 hiệp × 12–15 reps', 'Nghỉ 45s', '🦾'),
];

({
  int bmr,
  int tdee,
  int calories,
  double bmi,
  String bmiLabel,
  int protein,
  int fat,
  int carbs,
})
calculateMetrics({
  required int age,
  required String gender,
  required double height,
  required double weight,
  required double activity,
  required String goal,
}) {
  final bmr =
      (10 * weight + 6.25 * height - 5 * age + (gender == 'male' ? 5 : -161))
          .round();
  final tdee = (bmr * activity).round();
  final calories =
      tdee +
      (goal == 'gain'
          ? 250
          : goal == 'lose'
          ? -350
          : 0);
  final bmi = double.parse(
    (weight / ((height / 100) * (height / 100))).toStringAsFixed(1),
  );
  final protein = (weight * (goal == 'gain' ? 2 : 1.8)).round();
  final fat = (weight * .9).round();
  final carbs = ((calories - protein * 4 - fat * 9) / 4).round().clamp(0, 9999);
  final label = bmi < 18.5
      ? 'Hơi nhẹ cân'
      : bmi < 25
      ? 'Bình thường'
      : bmi < 30
      ? 'Hơi cao'
      : 'Cao';
  return (
    bmr: bmr,
    tdee: tdee,
    calories: calories,
    bmi: bmi,
    bmiLabel: label,
    protein: protein,
    fat: fat,
    carbs: carbs,
  );
}
