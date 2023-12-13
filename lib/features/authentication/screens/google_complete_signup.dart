import 'package:flutter/material.dart';
import 'package:freegig_app/classes/city_list.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/authentication/screens/login.dart';
import 'package:freegig_app/features/authentication/widgets/google_signup_form.dart';
import 'package:freegig_app/services/api/firebase_api.dart';
import 'package:freegig_app/services/auth/auth_service.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/common/themeapp.dart';

class GoogleCompleteSignUp extends StatefulWidget {
  const GoogleCompleteSignUp({Key? key}) : super(key: key);

  @override
  _GoogleCompleteSignUpState createState() => _GoogleCompleteSignUpState();
}

class _GoogleCompleteSignUpState extends State<GoogleCompleteSignUp> {
  final _auth = FirebaseAuthService();
  bool showPassword = false;
  bool isSigningUp = false;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final publicName = TextEditingController();
  final category = TextEditingController();
  final birthDate = TextEditingController();
  final phoneNo = TextEditingController();
  final city = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    publicName.dispose();
    category.dispose();
    birthDate.dispose();
    phoneNo.dispose();
    city.dispose();
    super.dispose();
  }

  bool cityValidator = false;
  void cityValidate(String? city) {
    if (city!.isEmpty || !CityList().cityList.contains(city)) {
      setState(() {
        cityValidator = true;
      });
    } else {
      setState(() {
        cityValidator = false;
      });
    }
  }

  void completeSignUp() async {
    cityValidate(city.text);
    setState(() {
      isSigningUp = true;
    });

    if (formKey.currentState!.validate() && !cityValidator) {
      setState(() {
        isSigningUp = false;
      });

      try {
        _auth.addUserDetailsGoogleSignIn(
          firstName.text.trim(),
          lastName.text.trim(),
          publicName.text.trim(),
          category.text.trim(),
          birthDate.text.trim(),
          phoneNo.text.trim(),
          city.text.trim(),
        );
        await FirebaseApi().updateUserToken();
        print('User is successfully created');
        navigationFadeTo(context: context, destination: NavigationMenu());
      } catch (e) {
        print('Some error happened, error: $e');
      }
    }
    setState(() {
      isSigningUp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigationFadeTo(context: context, destination: LoginScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Só mais alguns passos!',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 19.0,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 0.0, left: 24.0, right: 24.0, bottom: 18.0),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  GoogleSignUpForm(
                    firstName: firstName,
                    lastName: lastName,
                    publicName: publicName,
                    category: category,
                    birthDate: birthDate,
                    phoneNo: phoneNo,
                    city: city,
                    formKey: formKey,
                    cityValidator: cityValidator,
                  ),
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
                        completeSignUp();
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
                                "Concluir",
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
      ),
    );
  }
}
