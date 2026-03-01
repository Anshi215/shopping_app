import 'package:flutter/material.dart';

enum Category {
  fruit,
  meat,
  dairy,
  sweets,
  carbs,
  vegetables,
  spices,
  convenience,
  hygiene,
  other,
}

class CategoryModel {
  String title;
  final Color color;

  CategoryModel({required this.title, required this.color});
}
