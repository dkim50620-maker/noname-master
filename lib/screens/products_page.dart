import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';
import '../data/products_data.dart' as data;
import '../widgets/gradient_background.dart';
import '../services/notification_service.dart';
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
    final categories = ['Все', ...data.products.map((p) => p.category).toSet()];

    final filteredProducts = selectedCategory == 'Все'
        ? data.products
        : data.products.where((p) => p.category == selectedCategory).toList();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Товары'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
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
                      // Исправленные цвета для видимости текста
                      backgroundColor: Colors.white,
                      selectedColor: Colors.blueAccent,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final p = filteredProducts[index];
                  return Card(
                    color: Colors.white.withOpacity(0.1),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(p.icon, size: 40, color: Colors.greenAccent),
                      title: Text(
                        p.name, 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.description, 
                            maxLines: 2, 
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${p.category} • ${p.price} ₸',
                            style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                            onPressed: () {
                              cart.add(p);
                              NotificationService.showNotification(
                                id: p.hashCode,
                                title: 'Товар в корзине!',
                                body: 'Вы добавили "${p.name}" в корзину.',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${p.name} добавлен в корзину'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () {
                              _showDeleteDialog(p);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddProductPage()),
            );
            if (result == true) {
              setState(() {});
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showDeleteDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text('Удаление', style: TextStyle(color: Colors.white)),
        content: Text(
          'Вы уверены, что хотите удалить "${product.name}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                data.products.remove(product);
              });
              NotificationService.showNotification(
                id: product.hashCode,
                title: 'Товар удален',
                body: 'Вы удалили "${product.name}" из списка товаров.',
              );
              Navigator.pop(context);
            },
            child: const Text('УДАЛИТЬ', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
