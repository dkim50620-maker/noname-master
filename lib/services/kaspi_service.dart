import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products_data.dart' as data;

class KaspiService {
  // Тестовый URL с JSON данными
  static const String _mockUrl = 'https://api.jsonserve.com/v1/kaspi_test_data'; 

  static Future<bool> syncProducts() async {
    try {
      debugPrint('Начало синхронизации...');
      
      // Пытаемся получить данные из сети
      final response = await http.get(Uri.parse(_mockUrl)).timeout(
        const Duration(seconds: 5),
      );

      debugPrint('Статус ответа: ${response.statusCode}');

      List<dynamic> kaspiJson;
      if (response.statusCode == 200) {
        kaspiJson = json.decode(response.body);
      } else {
        // Если сеть недоступна, используем локальный "запасной" список для теста
        debugPrint('Сервер недоступен, используем локальный мок');
        kaspiJson = _getLocalMockData();
      }
      
      return _processProducts(kaspiJson);
    } catch (e) {
      debugPrint('Ошибка сети: $e. Используем локальный мок.');
      // Если интернета нет совсем, всё равно показываем результат через мок
      return _processProducts(_getLocalMockData());
    }
  }

  static bool _processProducts(List<dynamic> jsonList) {
    try {
      List<Product> syncedProducts = jsonList.map((item) {
        return Product(
          name: item['title'] ?? 'Без названия',
          price: item['price'] ?? 0,
          category: item['category'] ?? 'Kaspi Магазин',
          description: item['description'] ?? 'Товар из Kaspi Shop',
          icon: _getIconForCategory(item['category']),
          sku: item['id']?.toString(),
        );
      }).toList();

      for (var newProduct in syncedProducts) {
        bool exists = data.products.any((p) => p.name == newProduct.name);
        if (!exists) {
          data.products.add(newProduct);
        }
      }

      data.saveProducts();
      return true;
    } catch (e) {
      debugPrint('Ошибка обработки данных: $e');
      return false;
    }
  }

  static List<dynamic> _getLocalMockData() {
    return [
      {
        "id": 101,
        "title": "iPhone 15 Pro",
        "price": 550000,
        "category": "Смартфоны",
        "description": "Новейший смартфон от Apple с титановым корпусом."
      },
      {
        "id": 102,
        "title": "MacBook Air M2",
        "price": 620000,
        "category": "Ноутбуки",
        "description": "Тонкий и мощный ноутбук для работы и учебы."
      },
      {
        "id": 103,
        "title": "Sony WH-1000XM5",
        "price": 180000,
        "category": "Гаджеты",
        "description": "Лучшие наушники с шумоподавлением."
      }
    ];
  }

  static IconData _getIconForCategory(String? category) {
    if (category == null) return Icons.shopping_bag;
    if (category.contains('Смартфоны')) return Icons.smartphone;
    if (category.contains('Ноутбуки')) return Icons.laptop;
    if (category.contains('Гаджеты')) return Icons.watch;
    return Icons.shopping_cart_checkout;
  }
}
