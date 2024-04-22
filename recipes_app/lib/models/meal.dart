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
    required this.idMeal,
    required this.strMeal,
    this.strCategory,
    this.strInstructions,
    required this.strMealThumb,
    this.strTags,
    this.strYoutube,
    this.ingredients,
    this.strSource,
  });

  final String idMeal;
  final String strMeal;
  final String? strCategory;
  final String? strInstructions;
  final String strMealThumb;
  final String? strTags;
  final String? strYoutube;
  final List<String>? ingredients;
  final String? strSource;
}
