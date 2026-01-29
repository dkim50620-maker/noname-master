import 'package:flutter/material.dart';
import '../services/support_service.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Техподдержка')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: 'Сообщение'),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                setState(() => loading = true);

                final ok = await SupportService.sendMessage(
                  email: emailController.text,
                  message: messageController.text,
                );

                setState(() => loading = false);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok
                          ? 'Сообщение отправлено ✅'
                          : 'Ошибка отправки ❌',
                    ),
                  ),
                );
              },
              child: Text(loading ? 'Отправка...' : 'Отправить'),
            ),
          ],
        ),
      ),
    );
  }
}
