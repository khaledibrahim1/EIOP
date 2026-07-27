import 'package:flutter/material.dart';

class CategoryItem {
  final String id;
  final String title;
  final String imagePath;
  final Color bgColor;
  final Color activeColor;

  const CategoryItem({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.bgColor,
    required this.activeColor,
  });
}
