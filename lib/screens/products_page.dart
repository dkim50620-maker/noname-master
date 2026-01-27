import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<Product> products = const [
    Product(name: 'Ноутбук', price: 150000, category: 'Техника'),
    Product(name: 'Компьютер', price: 300000, category: 'Техника'),
    Product(name: 'Микрофон', price: 20000, category: 'Аксессуары'),
    Product(name: 'Игровой коврик', price: 10000, category: 'Аксессуары'),
    Product(name: 'Оперативная память DDR4', price: 1000000000, category: 'Комплектующие'),
  ];

  String selectedCategory = 'Все';

  List<String> get categories {
    final cats = products.map((p) => p.category).toSet().toList();
    cats.sort();
    cats.insert(0, 'Все');
    return cats;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategory == 'Все'
        ? products
        : products.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Товары')),
      body: Column(
        children: [
          // Фильтр по категориям
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final cat = categories[i];
                final selected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => selectedCategory = cat);
                    },
                  ),
                );
              },
            ),
          ),

          // Список товаров
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final p = filtered[i];
                return Card(
                  child: ListTile(
                    title: Text(p.name),
                    subtitle: Text('${p.category} • ${p.price} ₸'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        cart.add(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${p.name} добавлен')),
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
