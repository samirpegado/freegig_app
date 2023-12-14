import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/authentication/screens/confirm_email_page.dart';
import 'package:freegig_app/features/authentication/screens/google_complete_signup.dart';
import 'package:freegig_app/features/authentication/screens/login.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/services/api/firebase_api.dart';

class AuthGoogleGate extends StatelessWidget {
  const AuthGoogleGate({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            final User user = snapshot.data!;

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData && snapshot.data!.exists) {
                  final bool isEmailVerified =
                      FirebaseAuth.instance.currentUser!.emailVerified;
                  print(isEmailVerified);

                  if (isEmailVerified) {
                    // Atualize o estado do usuário após a verificação do e-mail
                    FirebaseApi().updateUserToken();
                  }

                  return isEmailVerified
                      ? NavigationMenu()
                      : ConfirmEmailPage();
                } else {
                  // O documento não existe, o usuário ainda não completou o registro
                  return GoogleCompleteSignUp();
                }
              },
            );
          }

          return LoginScreen();
        },
      ),
    );
  }
}
