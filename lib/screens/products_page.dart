import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  final List<Product> products = const [
    Product(name: 'Ноутбук', price: 150000, category: 'Электроника'),
    Product(name: 'Смартфон', price: 80000, category: 'Электроника'),
    Product(name: 'Компьютер', price: 300000, category: 'Электроника'),
    Product(name: 'Микрофон', price: 25000, category: 'Аксессуары'),
    Product(name: 'Игровой коврик', price: 7000, category: 'Аксессуары'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Товары')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
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
    );
  }
}


