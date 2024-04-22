enum Complexity {
  simple,
  challenging,
  hard,
}

enum Affordability {
  affordable,
  pricey,
  luxurious,
}

class Meal {
  const Meal({
    required this.label,
    required this.image,
    required this.source,
    required this.url,
    required this.dietLabels,
    required this.healthLabels,
    required this.ingredientLines,
    required this.calories,
    required this.totalTime,
    required this.cuisineType,
    required this.mealType,
    required this.dishType,
    this.instructions,
    this.tags,
    this.link,
  });

  final String label;
  final String image;
  final String source;
  final String url;
  final List<String> dietLabels;
  final List<String> healthLabels;
  final List<String> ingredientLines;
  final double calories;
  final double totalTime;
  final List<String> cuisineType;
  final List<String> mealType;
  final List<String> dishType;
  final List<String>? instructions;
  final List<String>? tags;
  final List<String>? link;
}
