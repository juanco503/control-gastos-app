import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterPage extends StatelessWidget {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final auth = AuthService();

  RegisterPage({super.key});

  void _msg(BuildContext context, String txt) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Cuenta')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: userCtrl, decoration: InputDecoration(labelText: 'Usuario')),
            TextField(controller: passCtrl, decoration: InputDecoration(labelText: 'Contraseña'), obscureText: true),
            ElevatedButton(
              onPressed: () async {
                bool ok = await auth.register(userCtrl.text, passCtrl.text);
                _msg(context, ok ? 'Cuenta creada' : 'Usuario ya existe');
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
