import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products_data.dart' as data;
import '../widgets/gradient_background.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  IconData _selectedIcon = Icons.computer;

  final List<IconData> _availableIcons = [
    Icons.computer,
    Icons.mic,
    Icons.layers,
    Icons.memory,
    Icons.keyboard,
    Icons.monitor,
    Icons.mouse,
    Icons.headphones,
    Icons.speaker,
    Icons.print,
    Icons.smartphone,
    Icons.tv,
    Icons.videogame_asset,
    Icons.watch,
  ];

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        name: _nameController.text,
        price: int.parse(_priceController.text),
        category: _categoryController.text,
        description: _descriptionController.text,
        icon: _selectedIcon,
      );

      setState(() {
        data.products.add(newProduct);
      });

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('Добавить товар')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Название товара'),
                  validator: (value) => value == null || value.isEmpty ? 'Введите название' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _priceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Цена (₸)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Введите цену';
                    if (int.tryParse(value) == null) return 'Введите корректное число';
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _categoryController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Категория'),
                  validator: (value) => value == null || value.isEmpty ? 'Введите категорию' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Описание'),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty ? 'Введите описание' : null,
                ),
                const SizedBox(height: 25),
                const Text(
                  'Выберите иконку:', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                ),
                const SizedBox(height: 10),
                // Горизонтальный выбор иконок как на скриншоте
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _availableIcons.length,
                    itemBuilder: (context, index) {
                      final icon = _availableIcons[index];
                      final isSelected = _selectedIcon == icon;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Icon(
                            icon, 
                            color: isSelected ? Colors.white : Colors.blueAccent,
                            size: 28,
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedIcon = icon;
                            });
                          },
                          selectedColor: Colors.blueAccent.withOpacity(0.5),
                          backgroundColor: Colors.white.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected ? Colors.blueAccent : Colors.white12,
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveProduct,
                    child: const Text('СОХРАНИТЬ ТОВАР', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
