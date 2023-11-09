import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/authentication/screens/login.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          /// user is logged in
          if (snapshot.hasData) {
            return NavigationMenu();
          }

          /// user is NOT logged in
          else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
