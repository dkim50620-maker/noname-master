import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';
import '../data/products_data.dart' as data;
import 'add_product_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String selectedCategory = 'Все';

  @override
  Widget build(BuildContext context) {
    // Получаем уникальный список категорий из актуального списка товаров
    final categories = ['Все', ...data.products.map((p) => p.category).toSet()];

    // Фильтруем список товаров
    final filteredProducts = selectedCategory == 'Все'
        ? data.products
        : data.products.where((p) => p.category == selectedCategory).toList();

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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Icon(p.icon, size: 40, color: Colors.blue),
                    title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(
                          '${p.category} • ${p.price} ₸',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    isThreeLine: true,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
          if (result == true) {
            setState(() {}); // Обновляем страницу при возврате
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
