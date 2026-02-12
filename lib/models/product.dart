import 'package:flutter/material.dart';

class Product {
  final String name;
  final int price;
  final String category;
  final String description;
  final IconData? icon;      // Для локально созданных товаров
  final String? imageUrl;   // Для товаров из Kaspi
  final String? sku;        // Артикул из Kaspi

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    this.icon,
    this.imageUrl,
    this.sku,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'description': description,
      'iconCode': icon?.codePoint,
      'imageUrl': imageUrl,
      'sku': sku,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      category: json['category'],
      description: json['description'],
      icon: json['iconCode'] != null 
          ? IconData(json['iconCode'], fontFamily: 'MaterialIcons') 
          : null,
      imageUrl: json['imageUrl'],
      sku: json['sku'],
    );
  }
}
