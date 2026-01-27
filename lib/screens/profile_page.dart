import 'package:flutter/material.dart';
import '../data/cart.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String token;
  const ProfilePage({super.key, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int get total => cart.fold(0, (sum, item) => sum + item.price);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool changingEmail = false;
  bool changingPassword = false;

  @override
  void initState() {
    super.initState();
    emailController.text = AuthService.currentEmail;
    passwordController.text = AuthService.currentPassword;
  }

  void changeEmail() async {
    final newEmail = emailController.text.trim();
    if (newEmail.isEmpty) return;

    setState(() => changingEmail = true);
    final success = await AuthService.changeEmail(widget.token, newEmail);
    setState(() => changingEmail = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(success
              ? 'Email успешно изменён на $newEmail'
              : 'Ошибка при смене email')),
    );
  }

  void changePassword() async {
    final newPassword = passwordController.text.trim();
    if (newPassword.isEmpty) return;

    setState(() => changingPassword = true);
    final success =
    await AuthService.changePassword(widget.token, newPassword);
    setState(() => changingPassword = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(success
              ? 'Пароль успешно изменён'
              : 'Ошибка при смене пароля')),
    );
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(radius: 40, child: Icon(Icons.person)),
            const SizedBox(height: 10),
            const Text('Ким Дмитрий', style: TextStyle(fontSize: 18)),
            const Divider(),

            // Смена email
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Новый Email'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  changingEmail
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                      onPressed: changeEmail, child: const Text('Сменить')),
                ],
              ),
            ),

            // Смена пароля
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: passwordController,
                      decoration:
                      const InputDecoration(labelText: 'Новый пароль'),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  changingPassword
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                      onPressed: changePassword,
                      child: const Text('Сменить')),
                ],
              ),
            ),

            // Кнопка выхода
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Выйти'),
              ),
            ),

            const Divider(),

            // Корзина
            cart.isEmpty
                ? const Center(child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Корзина пуста'),
            ))
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cart.length,
              itemBuilder: (_, i) {
                return ListTile(
                  title: Text(cart[i].name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => cart.removeAt(i));
                    },
                  ),
                );
              },
            ),

            if (cart.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Итого: $total ₸'),
              ),
          ],
        ),
      ),
    );
  }
}
