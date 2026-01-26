import 'package:flutter/material.dart';
import '../data/cart.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int get totalPrice => cart.fold(0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text('Корзина пуста'))
                : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cart[index].name),
                  trailing: IconButton(
                    icon:
                    const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => cart.removeAt(index));
                    },
                  ),
                );
              },
            ),
          ),
          if (cart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Итого: $totalPrice ₸',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
