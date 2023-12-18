// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/authentication/widgets/forgot_pwd_alert.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/services/auth/auth_service.dart';
import 'package:freegig_app/services/common/delete_account.dart';
import 'package:iconsax/iconsax.dart';

class ReAuthScreen extends StatefulWidget {
  @override
  _ReAuthScreenState createState() => _ReAuthScreenState();
}

class _ReAuthScreenState extends State<ReAuthScreen> {
  final _auth = FirebaseAuthService();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isSigningUp = false;
  bool isGoogleSigningUp = false;
  bool showPassword = false;

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  Future<void> reAuth() async {
    String password = passwordController.text;
    if (formKey.currentState!.validate()) {
      setState(() {
        isSigningUp = true;
      });

      await _auth.reAuthWithEmailAndPassword(context, password.trim());
      setState(() {
        isSigningUp = false;
      });
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 24.0, left: 24.0, right: 24.0, bottom: 18.0),
              child: Column(
                children: [
                  /// Logo, title, subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                          height: 130.0,
                          image: AssetImage("assets/images/freegig-login.png")),
                      Text(
                        "Lamentamos que queira ir,",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        '😢',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Por favor, reinsira suas credenciais para continuar.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),

                  ///Form
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text(FirebaseAuth.instance.currentUser?.email ??
                              'Usuário não autenticado'),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Insira uma senha válida.';
                              } else {
                                return null;
                              }
                            },
                            obscureText:
                                !showPassword, // Use !showPassword here
                            decoration: InputDecoration(
                              prefixIcon: Icon(Iconsax.password_check),
                              labelText: "Senha",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  toggleShowPassword(); // Use toggleShowPassword() to toggle the password visibility
                                },
                                icon: Icon(showPassword
                                    ? Iconsax.eye
                                    : Iconsax
                                        .eye_slash), // Change the icon based on showPassword
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),

                          /// Forgot Password
                          TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => ForgotPasswordAlert());
                            },
                            child: Text("Esqueceu sua senha?"),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF274b99),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () async {
                                await reAuth();
                                await DeleteUserService()
                                    .deleteUserAndRelatedData(context);
                              },
                              child: isSigningUp
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Text(
                                        "Continuar",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                navigationFadeTo(
                                    context: context,
                                    destination: NavigationMenu());
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
