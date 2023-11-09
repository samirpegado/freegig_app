import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class SignUpController {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final publicName = TextEditingController();
  final category = TextEditingController();
  final birthDate = TextEditingController();
  final phoneNo = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailandPassword(
          email.text, password.text, this);
      // Se a conta foi criada com sucesso, navegue para a tela desejada
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationMenu(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }
}
