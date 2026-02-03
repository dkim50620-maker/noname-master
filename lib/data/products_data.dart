import 'package:flutter/material.dart';
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
    price: 1000000000000,
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

// Глобальный список товаров (в реальном приложении это был бы State Management или БД)
List<Product> products = List.from(initialProducts);
