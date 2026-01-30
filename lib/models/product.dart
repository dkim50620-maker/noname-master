import 'package:flutter/material.dart';

class Product {
  final String name;
  final int price;
  final String category;
  final String description;
  final IconData icon;

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.icon,
  });
}
