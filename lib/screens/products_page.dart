import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<Product> products = [
    Product(name: 'Компьютер', price: 300000, category: 'Техника'),
    Product(name: 'Микрофон', price: 50000, category: 'Техника'),
    Product(name: 'Игровой коврик', price: 15000, category: 'Аксессуары'),
    Product(
      name: 'Оперативная память',
      price: 100000000,
      category: 'Комплектующие',
    ),
    Product(name: 'Клавиатура', price: 25000, category: 'Аксессуары'),
    Product(name: 'Монитор', price: 80000, category: 'Техника'),
  ];

  String selectedCategory = 'Все';

  @override
  Widget build(BuildContext context) {
    // Получаем уникальный список категорий
    final categories = ['Все', ...products.map((p) => p.category).toSet()];
    
    // Фильтруем список товаров
    final filteredProducts = selectedCategory == 'Все'
        ? products
        : products.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Товары')),
      body: Column(
        children: [
          // Горизонтальный список категорий
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // Список товаров
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final p = filteredProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(p.name),
                    subtitle: Text('${p.category} • ${p.price} ₸'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        cart.add(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${p.name} добавлен в корзину'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
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
