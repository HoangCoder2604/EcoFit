typedef GroceryItem = (String name, int price);

class GroceryGroup {
  const GroceryGroup({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final String icon;
  final List<GroceryItem> items;
}
