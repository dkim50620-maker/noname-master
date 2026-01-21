import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/* -------------------- МОДЕЛЬ ТОВАРА -------------------- */

class Product {
  final String name;
  final int price;
  final String category;

  Product(this.name, this.price, this.category);
}

/* -------------------- КОРЗИНА -------------------- */

List<Product> cart = [];

/* -------------------- ПРИЛОЖЕНИЕ -------------------- */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShopPage(),
    );
  }
}

/* -------------------- МАГАЗИН -------------------- */

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

    // НОВАЯ КАТЕГОРИЯ
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
          // КАТЕГОРИИ
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
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // ТОВАРЫ
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: Text(product.name),
                    subtitle:
                    Text('${product.price} ₸ • ${product.category}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        setState(() {
                          cart.add(product);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text('${product.name} добавлен в корзину'),
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

/* -------------------- ПРОФИЛЬ -------------------- */

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int get totalPrice {
    int sum = 0;
    for (var item in cart) {
      sum += item.price;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ким Дмитрий',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('kimdmitry@gmail.com'),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '🛒 Корзина (${cart.length})',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: cart.isEmpty
                  ? const Center(child: Text('Корзина пуста'))
                  : ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('${item.price} ₸'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            cart.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            if (cart.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Итого:',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '$totalPrice ₸',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
