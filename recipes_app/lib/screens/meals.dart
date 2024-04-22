import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/meal.dart';
import '../widgets/meal_item.dart';
import 'meal_details.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
  });

  final String? title;
  final List<Meal> meals;

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<Meal> _getMealDetails(String mealId) async {
    final url = Uri.https(
      'themealdb.com',
      '/api/json/v1/1/lookup.php',
      {
        'i': mealId,
      },
    );

    final response = await http.get(url);
    final mealDetails = json.decode(response.body);
    final meal = mealDetails['meals'][0];

    List<String> instructions;
    if (meal['strInstructions'] != null && meal['strInstructions'].isNotEmpty) {
      instructions = meal['strInstructions'].split('. ');
    } else {
      instructions = [];
    }

    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      String measure = meal["strMeasure$i"];
      String ingredient = meal["strIngredient$i"];
      if (measure != null &&
          ingredient != null &&
          measure.isNotEmpty &&
          ingredient.isNotEmpty) {
        ingredients.add("$measure $ingredient");
      } else {
        // If either measure or ingredient is null or empty, we break the loop
        break;
      }
    }

    final Meal details = Meal(
      idMeal: meal['idMeal'],
      strMeal: meal['strMeal'],
      strCategory: meal['strCategory'],
      strInstructions: instructions,
      strMealThumb: meal['strMealThumb'],
      strTags: meal['strTags'],
      strYoutube: meal['strYoutube'],
      ingredients: ingredients,
      strSource: meal['strSource'],
    );

    // print(details);

    return details;
  }

  Future<void> selectMeal(BuildContext context, Meal meal) async {
    final mealDetails = await _getMealDetails(meal.idMeal);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
          meal: mealDetails,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Uh oh ... nothing here!',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Try selecting a different category!',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          )
        ],
      ),
    );

    if (widget.meals.isNotEmpty) {
      content = ListView.builder(
        itemCount: widget.meals.length,
        itemBuilder: (ctx, index) => MealItem(
          meal: widget.meals[index],
          onSelectMeal: (meal) {
            selectMeal(context, meal);
          },
        ),
      );
    }

    if (widget.title == null) {
      return content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: content,
    );
  }
}
