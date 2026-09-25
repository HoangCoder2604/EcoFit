class Meal {
  const Meal({
    required this.id,
    required this.type,
    required this.name,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.price,
    required this.tag,
    required this.emoji,
  });

  final String id;
  final String type;
  final String name;
  final int kcal;
  final int protein;
  final int carbs;
  final int fat;
  final int price;
  final String tag;
  final String emoji;
}
