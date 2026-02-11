import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

final List<Product> initialProducts = [
  Product(
    name: 'Компьютер',
    price: 300000,
    category: 'Техника',
    description: 'Мощный игровой компьютер для любых задач.',
    icon: Icons.computer,
  ),
  Product(
    name: 'Микрофон',
    price: 50000,
    category: 'Техника',
    description: 'Студийный микрофон для качественной записи звука.',
    icon: Icons.mic,
  ),
  Product(
    name: 'Игровой коврик',
    price: 15000,
    category: 'Аксессуары',
    description: 'Большой коврик с отличным скольжением.',
    icon: Icons.layers,
  ),
  Product(
    name: 'Оперативная память',
    price: 45000,
    category: 'Комплектующие',
    description: '16GB DDR4 для быстрой работы системы.',
    icon: Icons.memory,
  ),
  Product(
    name: 'Клавиатура',
    price: 25000,
    category: 'Аксессуары',
    description: 'Механическая клавиатура с RGB подсветкой.',
    icon: Icons.keyboard,
  ),
  Product(
    name: 'Монитор',
    price: 80000,
    category: 'Техника',
    description: '24-дюймовый Full HD монитор с IPS матрицей.',
    icon: Icons.monitor,
  ),
];

List<Product> products = List.from(initialProducts);

Future<void> saveProducts() async {
  final prefs = await SharedPreferences.getInstance();
  final String encodedData = jsonEncode(
    products.map((product) => product.toJson()).toList(),
  );
  await prefs.setString('saved_products', encodedData);
}

Future<void> loadProducts() async {
  final prefs = await SharedPreferences.getInstance();
  final String? savedData = prefs.getString('saved_products');
  if (savedData != null) {
    final List<dynamic> decodedData = jsonDecode(savedData);
    products = decodedData.map((item) => Product.fromJson(item)).toList();
  }
}
