import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products_data.dart' as data;

class KaspiService {
  static const String _globalStoreUrl = 'https://fakestoreapi.com/products/category/electronics';

  static Future<bool> syncProducts() async {
    try {
      debugPrint('Синхронизация с Kaspi (через глобальный API)...');
      
      final response = await http.get(Uri.parse(_globalStoreUrl)).timeout(
        const Duration(seconds: 10),
      );

      List<dynamic> productsJson;
      if (response.statusCode == 200) {
        productsJson = json.decode(response.body);
      } else {
        productsJson = _getReliableMockData();
      }
      
      return _processProducts(productsJson);
    } catch (e) {
      return _processProducts(_getReliableMockData());
    }
  }

  static bool _processProducts(List<dynamic> jsonList) {
    try {
      List<Product> syncedProducts = jsonList.map((item) {
        // РЕАЛИСТИЧНЫЙ РАСЧЕТ ЦЕНЫ
        double rawPrice = (item['price'] as num).toDouble();
        int priceInTenge;

        if (rawPrice < 1000) {
          // Если это цена из API ($), конвертируем по курсу с наценкой магазина
          priceInTenge = (rawPrice * 550).toInt();
          // Делаем "красивый" ценник (оканчивается на 990)
          priceInTenge = (priceInTenge ~/ 1000) * 1000 + 990;
        } else {
          // Если цена уже в тенге (из мока)
          priceInTenge = rawPrice.toInt();
        }

        return Product(
          name: item['title'] ?? 'Товар',
          price: priceInTenge,
          category: _translateCategory(item['category']),
          description: item['description'] ?? 'Описание товара из Kaspi Shop',
          imageUrl: item['image'] ?? item['image_url'],
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
      debugPrint('Ошибка обработки: $e');
      return false;
    }
  }

  static String _translateCategory(String? category) {
    if (category == null) return 'Разное';
    switch (category.toLowerCase()) {
      case 'electronics': return 'Электроника';
      case 'jewelery': return 'Аксессуары';
      default: return 'Техника';
    }
  }

  static List<dynamic> _getReliableMockData() {
    return [
      {
        "id": 201,
        "title": "Игровой монитор Samsung Odyssey G5 27\"",
        "price": 189990,
        "category": "Электроника",
        "image": "https://images.samsung.com/is/image/samsung/p6pi/ls24ag320nexxt/gallery/thailand-odyssey-g3-g32a-ls24ag320nexxt-530635422?\$650_519_PNG\$",
        "description": "Изогнутый экран 144Гц для максимального погружения."
      },
      {
        "id": 202,
        "title": "Беспроводная мышь Logitech G502 LIGHTSPEED",
        "price": 64490,
        "category": "Аксессуары",
        "image": "https://resource.logitech_g.com/w_692,c_lpad,ar_4:3,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/gaming/en/products/g502-hero/g502-hero-gallery-1.png?v=1",
        "description": "Легендарная точность и полная свобода движений."
      },
      {
        "id": 203,
        "title": "Наушники JBL Quantum 810 Wireless",
        "price": 99990,
        "category": "Электроника",
        "image": "https://kz.jbl.com/dw/image/v2/AAZE_PRD/on/demandware.static/-/Sites-masterCatalog_Harman/default/dw1062088c/JBL_T510BT_Product%20Image_Hero_Black-1605x1605px.png?sw=537&sh=537&sm=fit",
        "description": "Объемный звук для профессиональных геймеров."
      }
    ];
  }
}
