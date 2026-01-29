import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';

class ProductsPage extends StatelessWidget {
  ProductsPage({super.key});

  final List<Product> products = [
    Product(name: 'Компьютер', price: 300000, category: 'Техника'),
    Product(name: 'Микрофон', price: 50000, category: 'Техника'),
    Product(name: 'Игровой коврик', price: 15000, category: 'Аксессуары'),
    Product(
      name: 'Оперативная память',
      price: 100000000,
      category: 'Комплектующие',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Товары')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Card(
            margin: const EdgeInsets.all(10),
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
                    ),
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
