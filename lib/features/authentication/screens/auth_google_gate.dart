import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/authentication/screens/google_complete_signup.dart';
import 'package:freegig_app/features/authentication/screens/login.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';

class AuthGoogleGate extends StatelessWidget {
  const AuthGoogleGate({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Enquanto os dados estão sendo carregados, exibe o CircularProgressIndicator
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Verifica se o usuário está autenticado
          if (snapshot.hasData) {
            final User user = snapshot.data!;
            // Obtém a referência para o documento do usuário na coleção 'users'
            final userDocumentReference =
                FirebaseFirestore.instance.collection('users').doc(user.uid);

            return StreamBuilder<DocumentSnapshot>(
              stream: userDocumentReference.snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Enquanto os dados estão sendo carregados, exibe o CircularProgressIndicator
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Se o documento existir, navegue para NavigationMenu()
                if (snapshot.hasData && snapshot.data!.exists) {
                  return NavigationMenu();
                } else {
                  // Se o documento não existir, navegue para GoogleCompleteSignUp()
                  return GoogleCompleteSignUp();
                }
              },
            );
          }

          // Usuário não autenticado
          return LoginScreen(); // ou outro comportamento desejado
        },
      ),
    );
  }
}
