import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/authentication/screens/auth_google_gate.dart';
import 'package:freegig_app/services/api/firebase_api.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

    await user.sendEmailVerification();

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

      await FirebaseApi().updateUserToken();

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
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }

    return null;
  }

  Future<void> logOut(BuildContext context) async {
    final String currentUserId = _auth.currentUser!.uid;
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    if (currentUserId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'token': ''});
    }
    await _auth.signOut();

    navigationFadeTo(context: context, destination: AuthGoogleGate());
  }

  //Sign in with google
  signInWithGoogle() async {
    await GoogleSignIn().signOut();

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      // O usuário cancelou o login, trate esse caso conforme necessário
      print('Login com Google cancelado.');
      return null; // ou retorne algo apropriado no seu caso
    }

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  ///Cria a colecao users
  Future addUserDetailsGoogleSignIn(
    String firstName,
    String lastName,
    String publicName,
    String category,
    String birthDate,
    String phoneNo,
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
      'city': city,
      'profileComplete': false,
      'googleUser': true,
    });
  }

  ///Metodo para fazer reautenticacao
  Future<User?> reAuthWithEmailAndPassword(
      BuildContext context, String password) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);
        print('USUARIO REAUTENTICADO');
      }

      return null;
    } on FirebaseAuthException catch (e) {
      print('some error occured');
      String errorMessage = "Erro ao fazer login";

      switch (e.code) {
        case 'INVALID_LOGIN_CREDENTIALS':
          errorMessage = 'Senha inválida.';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta. Tente novamente.';
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

  //Sign in with google
  reAuthWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      // O usuário cancelou o login, trate esse caso conforme necessário
      print('Login com Google cancelado.');
      return null; // ou retorne algo apropriado no seu caso
    }

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  ///
}
