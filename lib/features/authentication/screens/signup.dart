import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/classes/city_list.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/authentication/screens/confirm_email_page.dart';
import 'package:freegig_app/services/api/firebase_api.dart';
import 'package:freegig_app/services/auth/auth_service.dart';
import 'package:freegig_app/features/authentication/widgets/signup_form.dart';
import 'package:freegig_app/common/themeapp.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuthService();
  bool showPassword = false;
  bool isSigningUp = false;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final publicName = TextEditingController();
  final category = TextEditingController();
  final birthDate = TextEditingController();
  final phoneNo = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final city = TextEditingController();

  final formKey = GlobalKey<FormState>();

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

  void signUp() async {
    cityValidate(city.text);
    setState(() {
      isSigningUp = true;
    });
    String _email = email.text;
    String _password = password.text;
    if (formKey.currentState!.validate() && !cityValidator) {
      // create user
      User? user = await _auth.signUpWithEmailAndPassword(
        context,
        _email.trim(),
        _password.trim(),
      );
      setState(() {
        isSigningUp = false;
      });

      if (user != null) {
        _auth.addUserDetails(
          firstName.text.trim(),
          lastName.text.trim(),
          publicName.text.trim(),
          category.text.trim(),
          birthDate.text.trim(),
          phoneNo.text.trim(),
          email.text.trim(),
          city.text.trim(),
        );
        await FirebaseApi().updateUserToken();
        print('User is successfully created');
        ;

        navigationFadeTo(context: context, destination: ConfirmEmailPage());
      } else {
        print('Some error happened');
      }
    }
    setState(() {
      isSigningUp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Vamos criar a sua conta!',
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
                SignUpForm(
                  firstName: firstName,
                  lastName: lastName,
                  publicName: publicName,
                  category: category,
                  birthDate: birthDate,
                  phoneNo: phoneNo,
                  email: email,
                  password: password,
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
                      signUp();
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
}
