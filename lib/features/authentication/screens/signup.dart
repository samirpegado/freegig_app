import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/authentication/widgets/signup_form.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:intl/intl.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/features/authentication/screens/login.dart';

import 'package:iconsax/iconsax.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showPassword = false;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final publicName = TextEditingController();
  final category = TextEditingController();
  final birthDate = TextEditingController();
  final phoneNo = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
    publicName.dispose();
    category.dispose();
    birthDate.dispose();
    phoneNo.dispose();
    super.dispose();
  }

  Future signUp() async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
      //create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      // Se a conta foi criada com sucesso, navegue para a tela desejada
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationMenu(),
        ),
      );

      //add user details
      addUserDetails(
        firstName.text.trim(),
        lastName.text.trim(),
        publicName.text.trim(),
        category.text.trim(),
        birthDate.text.trim(),
        phoneNo.text.trim(),
        email.text.trim(),
      );

      ///
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

  ///
  Future addUserDetails(
    String firstName,
    String lastName,
    String publicName,
    String category,
    String birthDate,
    String phoneNo,
    String email,
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
      'profileComplete': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: 0.0, left: 24.0, right: 24.0, bottom: 18.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        },
                        icon: Icon(
                          Iconsax.arrow_left,
                          size: 32,
                        ))
                  ],
                ),
                Text(
                  "Vamos criar a sua conta!",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 15),
                SignUpForm(
                    firstName: firstName,
                    lastName: lastName,
                    publicName: publicName,
                    category: category,
                    birthDate: birthDate,
                    phoneNo: phoneNo,
                    email: email,
                    password: password),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      if (_isOver18(birthDate.text.trim())) {
                        signUp();
                      } else {
                        _showErrorSnackBar(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        "Criar conta",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isOver18(String birthDate) {
    // verifica se o usuário é maior de idade
    try {
      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(birthDate);
      int age = DateTime.now().year - parsedDate.year;

      return age >= 18;
    } catch (e) {
      return false;
    }
  }

  void _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Erro ao criar conta. Verifique se concordou com os termos e se você tem mais de 18 anos.",
        ),
      ),
    );
  }
}
