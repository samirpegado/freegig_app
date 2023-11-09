import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/authentication/controllers/signup_controller.dart';

class AuthService extends ChangeNotifier {
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // sign user in

  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      //sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    }
    // catch any erros
    on FirebaseAuthException catch (e) {
      //
      throw Exception(e.code);
    }
  }

  // create a new user
  Future<UserCredential> signUpWithEmailandPassword(
      String email, String password, SignUpController signUpController) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      createUserDocument(userCredential, signUpController);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // create a user document and collect them in firestore
  Future<void> createUserDocument(
      UserCredential? userCredential, SignUpController signUpController) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({
        'firstName': signUpController.firstName.text,
        'lastName': signUpController.lastName.text,
        'publicName': signUpController.publicName.text,
        'category': signUpController.category.text,
        'birthDate': signUpController.birthDate.text,
        'phoneNo': signUpController.phoneNo.text,
        'email': signUpController.email.text,
      });
    }
  }

  // sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
