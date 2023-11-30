import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  ///Metodo para criar um novo usuário
  Future<User?> signUpWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('some error occured');
      String errorMessage = "Erro ao fazer login";
      print(errorMessage);

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'E-mail já registrado, tente recuperar sua senha.';
          break;
        case 'weak-password':
          errorMessage = 'Senha fraca, utilize pelo menos oito caracteres';
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
    return null;
  }

  ///Cria a colecao users
  Future addUserDetails(
    String firstName,
    String lastName,
    String publicName,
    String category,
    String birthDate,
    String phoneNo,
    String email,
    String city,
  ) async {
    final user = FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'firstName': firstName,
      'lastName': lastName,
      'publicName': publicName,
      'category': category,
      'birthDate': birthDate,
      'phoneNo': phoneNo,
      'email': email,
      'city': city,
      'profileComplete': false,
    });
  }

  ///Metodo para fazer login
  Future<User?> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('some error occured');
      String errorMessage = "Erro ao fazer login";

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'E-mail inválido.';
          break;
        case 'INVALID_LOGIN_CREDENTIALS':
          errorMessage = 'E-mail ou senha inválidos.';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta. Tente novamente.';
          break;
        // Adicione mais casos conforme necessário
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
    return null;
  }
}
