import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';
import '../widgets/category_grid_item.dart';
import 'meals.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  final List<Meal> availableMeals;
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // once property is used it will have a value
  late AnimationController _animationController;
  List<Category> availableCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        microseconds: 300,
      ),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _getCategories();
      setState(() {
        availableCategories = categories;
      });
    } catch (error) {
      // Handle error
      print('Error fetching categories: $error');
    }
  }

  Future<List<Category>> _getCategories() async {
    final url = Uri.https('themealdb.com', '/api/json/v1/1/categories.php');
    final response = await http.get(url);
    final listData = json.decode(response.body);

    final List<Category> categories = [];
    for (final item in listData['categories']) {
      categories.add(
        Category(
          idCategory: item['idCategory'],
          strCategory: item['strCategory'],
          strCategoryThumb: item['strCategoryThumb'],
          strCategoryDescription: item['strCategoryDescription'],
        ),
      );
    }

    return categories;
  }

  Future<List<Meal>> _getItems(String mealType) async {
    const appId = 'd414be06';
    const appKey = 'c29462a45fd31a59c4a4f5f167305059';

    final url = Uri.https('api.edamam.com', '/api/recipes/v2', {
      'type': 'public',
      'app_id': appId,
      'app_key': appKey,
      'mealType': mealType,
      'field': [
        'label',
        'image',
        'source',
        'url',
        'dietLabels',
        'healthLabels',
        'ingredientLines',
        'calories',
        'totalTime',
        'cuisineType',
        'mealType',
        'dishType',
        'tags',
      ]
    });

    print(url);

    final response = await http.get(url);

    // throw Exception();

    final listData = json.decode(response.body);

    // print(listData['hits'][1]);

    final List<Meal> loadedItems = [];
    // print(listData['hits'][0]);

    for (final item in listData['hits']) {
      final recipe = item['recipe'];
      // print(recipe._links);
      loadedItems.add(
        Meal(
            label: recipe['label'],
            image: recipe['image'],
            source: recipe['source'],
            url: recipe['url'],
            dietLabels: (recipe['dietLabels'] as List<dynamic>).cast<String>(),
            healthLabels:
                (recipe['healthLabels'] as List<dynamic>).cast<String>(),
            ingredientLines:
                (recipe['ingredientLines'] as List<dynamic>).cast<String>(),
            calories: recipe['calories'],
            totalTime: recipe['totalTime'],
            cuisineType:
                (recipe['cuisineType'] as List<dynamic>).cast<String>(),
            mealType: (recipe['mealType'] as List<dynamic>).cast<String>(),
            dishType: (recipe['dishType'] as List<dynamic>).cast<String>(),
            instructions: (recipe['instructions'] != null)
                ? (recipe['instructions'] as List<dynamic>).cast<String>()
                : null,
            tags: (recipe['tags'] != null)
                ? (recipe['tags'] as List<dynamic>).cast<String>()
                : null,
            link: recipe['_links']),
      );
    }
    return loadedItems;
  }

  void _selectCategory(BuildContext context, Category category) async {
    // final filteredMeals = widget.availableMeals
    //     .where((meal) => meal.categories.contains(category.id))
    //     .toList();

    final filteredMeals = await _getItems(category.idCategory);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.strCategory,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(availableCategories);
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
        ],
      ),
      builder: (context, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      ),
    );
  }
}
