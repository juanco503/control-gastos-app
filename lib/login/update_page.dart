import 'package:flutter/material.dart';
import 'auth_service.dart';

class UpdatePage extends StatelessWidget {
  final userCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final auth = AuthService();

  UpdatePage({super.key});

  void _msg(BuildContext context, String txt) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actualizar Contraseña')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: userCtrl, decoration: InputDecoration(labelText: 'Usuario')),
            TextField(controller: newPassCtrl, decoration: InputDecoration(labelText: 'Nueva Contraseña'), obscureText: true),
            ElevatedButton(
              onPressed: () async {
                bool ok = await auth.updateUser(userCtrl.text, newPassCtrl.text);
                _msg(context, ok ? 'Contraseña actualizada' : 'Usuario no encontrado');
              },
              child: Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
