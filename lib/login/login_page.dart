import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../main.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final AuthService auth = AuthService();

  void _msg(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: userCtrl,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool ok = await auth.login(userCtrl.text, passCtrl.text);
                if (ok) {
                  _msg(context, 'Login exitoso');

                  //Redirección a pantalla principal de app
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const FinanzasHome()),
                  );
                } else {
                  _msg(context, 'Credenciales incorrectas');
                }
              },
              child: const Text('Ingresar'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Crear cuenta'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/update'),
              child: const Text('Actualizar contraseña'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/delete'),
              child: const Text('Eliminar cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}