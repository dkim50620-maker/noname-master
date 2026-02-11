import 'package:flutter/material.dart';

class Product {
  final String name;
  final int price;
  final String category;
  final String description;
  final IconData icon;
  final String? sku; // Артикул из Каспи

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.icon,
    this.sku,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'description': description,
      'iconCode': icon.codePoint,
      'sku': sku,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      category: json['category'],
      description: json['description'],
      icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'),
      sku: json['sku'],
    );
  }
}
