import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/* -------------------- МОДЕЛЬ -------------------- */

class Product {
  final String name;
  final int price;
  final IconData icon;

  const Product(this.name, this.price, this.icon);
}

/* -------------------- КОРЗИНА -------------------- */

List<Product> cart = [];

/* -------------------- APP -------------------- */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ShopPage(),
    );
  }
}

/* -------------------- МАГАЗИН -------------------- */

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  static const List<Product> products = [
    Product('Компьютер', 250000, Icons.computer),
    Product('Смартфон', 80000, Icons.smartphone),
    Product('Наушники', 15000, Icons.headphones),
    Product('Часы', 25000, Icons.watch),
    Product('Клавиатура', 8000, Icons.keyboard),
    Product('Игровая мышь', 3000, Icons.mouse),
  ];

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
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(p.icon, size: 32),
              title: Text(p.name),
              subtitle: Text('${p.price} ₸'),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  cart.add(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${p.name} добавлен в корзину')),
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

/* -------------------- ПРОФИЛЬ -------------------- */

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int get total {
    int s = 0;
    for (var i in cart) {
      s += i.price;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
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
                'Корзина (${cart.length})',
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: cart.isEmpty
                  ? const Center(child: Text('Корзина пуста'))
                  : ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final p = cart[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(p.icon),
                      title: Text(p.name),
                      subtitle: Text('${p.price} ₸'),
                      trailing: IconButton(
                        icon:
                        const Icon(Icons.delete, color: Colors.red),
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
                    const Text('Итого:',
                        style: TextStyle(color: Colors.white)),
                    Text('$total ₸',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

