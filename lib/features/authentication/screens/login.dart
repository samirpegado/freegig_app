// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/authentication/widgets/forgot_pwd_alert.dart';
import 'package:freegig_app/services/api/firebase_api.dart';
import 'package:freegig_app/services/auth/auth_service.dart';
import 'package:freegig_app/features/authentication/screens/signup.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuthService();
  final emailController = TextEditingController();
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

  void signIn() async {
    String email = emailController.text;
    String password = passwordController.text;
    if (formKey.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(
        context,
        email.trim(),
        password.trim(),
      );
      await FirebaseApi().updateUserToken();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
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
                          height: 200.0,
                          image: AssetImage("assets/images/freegig-login.png")),
                      Text(
                        "Bem-vindo ao FreeGIG,",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22.0,
                        ),
                      ),
                      Text(
                        "Descubra músicos, bandas, crie GIGs e faça seu som acontecer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
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
                          ///Email
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Insira um e-mail válido.';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "E-mail",
                              prefixIcon: Icon(Iconsax.direct_right),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                          SizedBox(height: 20),

                          /// Password
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
                                setState(() {
                                  isSigningUp = true;
                                });
                                signIn();
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
                                        "Login",
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

                          ///Botao criar conta
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                navigationFadeTo(
                                    context: context,
                                    destination: SignUpScreen());
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
                                  "Criar conta",
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

                  ///Divisor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                          indent: 60,
                          endIndent: 5,
                        ),
                      ),
                      Text(
                        "Ou faça login com",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 190, 190, 190),
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0,
                        ),
                      ),
                      Flexible(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                          indent: 5,
                          endIndent: 60,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  ///Footer
                  isGoogleSigningUp
                      ? CircularProgressIndicator()
                      : Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              setState(() {
                                isGoogleSigningUp = true;
                              });
                              await FirebaseAuthService().signInWithGoogle();
                              setState(() {
                                isGoogleSigningUp = false;
                              });
                              await FirebaseAuthService()
                                  .checkGoogleUser(context);
                            },
                            icon: Image(
                              width: 40,
                              height: 40,
                              image: AssetImage("assets/images/google.png"),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
