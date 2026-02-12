import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';
import '../data/products_data.dart' as data;
import '../widgets/gradient_background.dart';
import '../services/notification_service.dart';
import '../services/kaspi_service.dart';
import 'add_product_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String selectedCategory = 'Все';
  bool _isSyncing = false;

  Future<void> _syncWithKaspi() async {
    setState(() => _isSyncing = true);
    final success = await KaspiService.syncProducts();
    if (mounted) {
      setState(() => _isSyncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Синхронизация с Kaspi завершена!' : 'Ошибка синхронизации'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) setState(() {});
    }
  }

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
          actions: [
            _isSyncing 
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                )
              : IconButton(
                  icon: const Icon(Icons.sync),
                  onPressed: _syncWithKaspi,
                ),
          ],
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
                      onSelected: (selected) => setState(() => selectedCategory = category),
                      backgroundColor: Colors.white,
                      selectedColor: Colors.blueAccent,
                      showCheckmark: false,
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
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // ОТОБРАЖЕНИЕ КАРТИНКИ ИЛИ ИКОНКИ
                        child: p.imageUrl != null 
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                p.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white30),
                              ),
                            )
                          : Icon(p.icon ?? Icons.shopping_bag, color: Colors.greenAccent, size: 30),
                      ),
                      title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70)),
                          const SizedBox(height: 4),
                          Text('${p.category} • ${p.price} ₸', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
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
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () {
                              setState(() => data.products.remove(p));
                              data.saveProducts();
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
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductPage())),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
