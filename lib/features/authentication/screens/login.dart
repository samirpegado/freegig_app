// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:freegig_app/features/authentication/controllers/login_controller.dart';
import 'package:freegig_app/features/authentication/screens/signup.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;
  bool isChecked = false;
  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void toggleIsChecked() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  final LoginController loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0, bottom: 18.0),
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
                    "Descubra músicos, crie GIGs e faça seu som acontecer",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      //fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),

              ///Form
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      ///Email
                      TextFormField(
                        controller: loginController.emailController,
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
                        controller: loginController.passwordController,
                        obscureText: !showPassword, // Use !showPassword here
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
                      SizedBox(height: 10),

                      ///Remember and Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  value: isChecked,
                                  onChanged: (value) {
                                    toggleIsChecked();
                                  }),
                              Text("Lembrar senha")
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text("Esqueceu sua senha?"),
                          ),
                        ],
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
                          onPressed: () {
                            loginController.signIn(context);
                          },
                          child: Padding(
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: BorderSide(width: 1.5, color: Colors.grey)),
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

              ///Dividor
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Image(
                        width: 40,
                        height: 40,
                        image: AssetImage("assets/images/google.png"),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Image(
                        width: 40,
                        height: 40,
                        image: AssetImage("assets/images/facebook.png"),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
