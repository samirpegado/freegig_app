// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/services/auth/auth_service.dart';
import 'package:freegig_app/services/common/delete_account.dart';

class ReAuthGoogleScreen extends StatefulWidget {
  @override
  _ReAuthGoogleScreenState createState() => _ReAuthGoogleScreenState();
}

class _ReAuthGoogleScreenState extends State<ReAuthGoogleScreen> {
  bool isGoogleSigningUp = false;

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
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
                                  isGoogleSigningUp = true;
                                });
                                await FirebaseAuthService().reAuthWithGoogle();
                                await DeleteUserService()
                                    .deleteUserAndRelatedData(context);
                              },
                              child: isGoogleSigningUp
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image(
                                              width: 20,
                                              height: 20,
                                              image: AssetImage(
                                                  "assets/images/google.png")),
                                          SizedBox(width: 20),
                                          Text(
                                            "Continuar",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
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
