import 'package:flutter/material.dart';
import 'package:freegig_app/features/authentication/screens/login.dart';
import 'package:freegig_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LogoutUser {
  Future<void> signOut(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    await authService.signOut();

    // Após o logout, navegue de volta para a tela de login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}
