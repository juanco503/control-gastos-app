import 'package:flutter/material.dart';
import 'auth_service.dart';

class DeletePage extends StatelessWidget {
  final userCtrl = TextEditingController();
  final auth = AuthService();

  DeletePage({super.key});

  void _msg(BuildContext context, String txt) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eliminar Cuenta')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: userCtrl, decoration: InputDecoration(labelText: 'Usuario')),
            ElevatedButton(
              onPressed: () async {
                bool ok = await auth.deleteUser(userCtrl.text);
                _msg(context, ok ? 'Cuenta eliminada' : 'Usuario no existe');
              },
              child: Text('Eliminar'),
            ),
          ],
        ),
      ),
    );
  }
}















