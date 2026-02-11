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
  String? _selectedExistingCategory;

  final List<IconData> _availableIcons = [
    Icons.computer, Icons.mic, Icons.layers, Icons.memory, Icons.keyboard,
    Icons.monitor, Icons.mouse, Icons.headphones, Icons.speaker, Icons.print,
    Icons.smartphone, Icons.tv, Icons.videogame_asset, Icons.watch,
  ];

  late List<String> _existingCategories;

  @override
  void initState() {
    super.initState();
    // Получаем список текущих категорий
    _existingCategories = data.products.map((p) => p.category).toSet().toList();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      // Приоритет выбранной существующей категории, если новая не введена
      String finalCategory = _categoryController.text.isNotEmpty 
          ? _categoryController.text 
          : (_selectedExistingCategory ?? 'Общее');

      final newProduct = Product(
        name: _nameController.text,
        price: int.parse(_priceController.text),
        category: finalCategory,
        description: _descriptionController.text,
        icon: _selectedIcon,
      );

      data.products.add(newProduct);
      await data.saveProducts(); // СОХРАНЯЕМ В ПАМЯТЬ

      if (mounted) Navigator.pop(context, true);
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
                  validator: (value) => value == null || value.isEmpty ? 'Введите цену' : null,
                ),
                const SizedBox(height: 15),
                
                // ВЫБОР СУЩЕСТВУЮЩЕЙ КАТЕГОРИИ
                const Text('Выберите категорию:', style: TextStyle(color: Colors.white70)),
                DropdownButtonFormField<String>(
                  value: _selectedExistingCategory,
                  dropdownColor: const Color(0xFF1A237E),
                  style: const TextStyle(color: Colors.white),
                  items: _existingCategories.map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  )).toList(),
                  onChanged: (val) => setState(() => _selectedExistingCategory = val),
                  decoration: InputDecoration(
                    hintText: 'Выбрать из списка',
                    hintStyle: const TextStyle(color: Colors.white38),
                  ),
                ),
                const Center(child: Text('ИЛИ', style: TextStyle(color: Colors.white38, fontSize: 10))),
                
                // ВВОД НОВОЙ КАТЕГОРИИ
                TextFormField(
                  controller: _categoryController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Новая категория'),
                ),
                
                const SizedBox(height: 15),
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Описание'),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                const Text('Иконка:', style: TextStyle(color: Colors.white)),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _availableIcons.length,
                    itemBuilder: (context, index) {
                      final icon = _availableIcons[index];
                      return ChoiceChip(
                        label: Icon(icon, color: _selectedIcon == icon ? Colors.white : Colors.blueAccent),
                        selected: _selectedIcon == icon,
                        onSelected: (_) => setState(() => _selectedIcon = icon),
                        selectedColor: Colors.blueAccent,
                        backgroundColor: Colors.white12,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveProduct,
                    child: const Text('СОХРАНИТЬ'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
