import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';
import 'profile_page.dart';
import 'api_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String selectedCategory = 'Все';

  final List<Product> products = [
    Product('Ноутбук', 150000, 'Компьютеры'),
    Product('Компьютер', 220000, 'Компьютеры'),
    Product('Смартфон', 80000, 'Телефоны'),
    Product('Наушники', 15000, 'Аксессуары'),
    Product('Микрофон', 12000, 'Аксессуары'),
    Product('Игровой коврик', 7000, 'Игры'),
    Product('Клавиатура', 8000, 'Игры'),
    Product('Мышь', 3000, 'Игры'),
    Product('Оперативная память', 100000000, 'Комплектующие'),
  ];

  List<String> get categories {
    return ['Все', ...{for (var p in products) p.category}];
  }

  List<Product> get filteredProducts {
    if (selectedCategory == 'Все') return products;
    return products.where((p) => p.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Магазин'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud),
            tooltip: 'API',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ApiPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (_) {
                      setState(() => selectedCategory = category);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  child: ListTile(
                    title: Text(product.name),
                    subtitle:
                    Text('${product.price} ₸ • ${product.category}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        setState(() => cart.add(product));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
