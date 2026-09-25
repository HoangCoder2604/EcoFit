import '../../domain/models/grocery_group.dart';
import '../../domain/models/meal.dart';

const meals = <Meal>[
  Meal(
    id: 'oatmeal',
    type: 'Bữa sáng',
    name: 'Yến mạch trái cây',
    kcal: 420,
    protein: 15,
    carbs: 58,
    fat: 12,
    price: 16000,
    tag: 'Tiết kiệm',
    emoji: '🥣',
  ),
  Meal(
    id: 'chicken-rice',
    type: 'Bữa trưa',
    name: 'Cơm gà rau củ',
    kcal: 520,
    protein: 35,
    carbs: 65,
    fat: 12,
    price: 29000,
    tag: 'Phổ biến',
    emoji: '🍱',
  ),
  Meal(
    id: 'yogurt',
    type: 'Bữa phụ',
    name: 'Sữa chua + chuối',
    kcal: 180,
    protein: 10,
    carbs: 28,
    fat: 4,
    price: 12000,
    tag: 'Giàu protein',
    emoji: '🍌',
  ),
  Meal(
    id: 'salmon',
    type: 'Bữa tối',
    name: 'Cá hồi + khoai lang',
    kcal: 480,
    protein: 30,
    carbs: 45,
    fat: 16,
    price: 35000,
    tag: 'Tốt cho sức khỏe',
    emoji: '🐟',
  ),
];

const groceryGroups = <GroceryGroup>[
  GroceryGroup(
    title: 'Protein',
    icon: '🥩',
    items: [
      ('Ức gà (500g)', 45000),
      ('Trứng (10 quả)', 30000),
      ('Cá hồi (200g)', 55000),
    ],
  ),
  GroceryGroup(
    title: 'Rau củ',
    icon: '🥦',
    items: [
      ('Rau cải bó xôi (300g)', 15000),
      ('Bông cải xanh (300g)', 20000),
      ('Cà rốt (500g)', 10000),
      ('Cà chua (500g)', 15000),
    ],
  ),
  GroceryGroup(
    title: 'Tinh bột',
    icon: '🍚',
    items: [
      ('Gạo lứt (1kg)', 25000),
      ('Khoai lang (1kg)', 22000),
      ('Yến mạch (500g)', 28000),
    ],
  ),
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

const mealsEn = <Meal>[
  Meal(
    id: 'oatmeal',
    type: 'Breakfast',
    name: 'Berry Fruit Oatmeal',
    kcal: 420,
    protein: 15,
    carbs: 58,
    fat: 12,
    price: 16000,
    tag: 'Budget',
    emoji: '🥣',
  ),
  Meal(
    id: 'chicken-rice',
    type: 'Lunch',
    name: 'Chicken & Veggie Rice',
    kcal: 520,
    protein: 35,
    carbs: 65,
    fat: 12,
    price: 29000,
    tag: 'Popular',
    emoji: '🍱',
  ),
  Meal(
    id: 'yogurt',
    type: 'Snack',
    name: 'Greek Yogurt & Banana',
    kcal: 180,
    protein: 10,
    carbs: 28,
    fat: 4,
    price: 12000,
    tag: 'High Protein',
    emoji: '🍌',
  ),
  Meal(
    id: 'salmon',
    type: 'Dinner',
    name: 'Salmon & Sweet Potato',
    kcal: 480,
    protein: 30,
    carbs: 45,
    fat: 16,
    price: 35000,
    tag: 'Healthy',
    emoji: '🐟',
  ),
];

const groceryGroupsEn = <GroceryGroup>[
  GroceryGroup(
    title: 'Protein',
    icon: '🥩',
    items: [
      ('Chicken Breast (500g)', 45000),
      ('Eggs (10 pcs)', 30000),
      ('Salmon fillet (200g)', 55000),
    ],
  ),
  GroceryGroup(
    title: 'Vegetables',
    icon: '🥦',
    items: [
      ('Baby Spinach (300g)', 15000),
      ('Fresh Broccoli (300g)', 20000),
      ('Carrots (500g)', 10000),
      ('Tomatoes (500g)', 15000),
    ],
  ),
  GroceryGroup(
    title: 'Healthy Carbs',
    icon: '🍚',
    items: [
      ('Brown Rice (1kg)', 25000),
      ('Sweet Potato (1kg)', 22000),
      ('Rolled Oats (500g)', 28000),
    ],
  ),
];

const workoutDaysEn = [
  ('Wednesday', 'Upper Body', 'Chest · Shoulders · Triceps', '🏋️'),
  ('Thursday', 'Lower Body', 'Legs · Glutes', '🦵'),
  ('Friday', 'Core & Cardio', 'Abs · Stamina', '🏃'),
  ('Saturday', 'Full Body', 'Complete Body Tone', '💪'),
  ('Sunday', 'Rest & Recovery', 'Active Muscle Care', '💚'),
];

const exercisesEn = [
  ('Bench Press', '4 sets × 8–12 reps', 'Rest 60s', '🏋️'),
  ('Incline Dumbbell Press', '3 sets × 8–12 reps', 'Rest 60s', '💪'),
  ('Shoulder Press', '3 sets × 8–12 reps', 'Rest 60s', '🏋️'),
  ('Lateral Raise', '3 sets × 12–15 reps', 'Rest 45s', '🙆'),
  ('Tricep Pushdown', '3 sets × 12–15 reps', 'Rest 45s', '🦾'),
];

List<Meal> localizedMeals(String language) =>
    language == 'en' ? mealsEn : meals;
List<GroceryGroup> localizedGroceryGroups(String language) =>
    language == 'en' ? groceryGroupsEn : groceryGroups;
List<(String, String, String, String)> localizedWorkoutDays(String language) =>
    language == 'en' ? workoutDaysEn : workoutDays;
List<(String, String, String, String)> localizedExercises(String language) =>
    language == 'en' ? exercisesEn : exercises;
