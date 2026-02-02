import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products_data.dart' as data;

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
  
  IconData _selectedIcon = Icons.help_outline;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить товар')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Название товара'),
                validator: (value) => value == null || value.isEmpty ? 'Введите название' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Цена (₸)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите цену';
                  if (int.tryParse(value) == null) return 'Введите корректное число';
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Категория'),
                validator: (value) => value == null || value.isEmpty ? 'Введите категорию' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Введите описание' : null,
              ),
              const SizedBox(height: 20),
              const Text('Выберите иконку:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: _availableIcons.map((icon) {
                  return ChoiceChip(
                    label: Icon(icon, color: _selectedIcon == icon ? Colors.white : Colors.blue),
                    selected: _selectedIcon == icon,
                    onSelected: (selected) {
                      setState(() {
                        _selectedIcon = icon;
                      });
                    },
                    selectedColor: Colors.blue,
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                  child: const Text('Сохранить товар', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
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
