import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.id,
    required this.mealType,
    this.color = Colors.orange,
  });

  final String id;
  final String mealType;
  final Color color;
}
