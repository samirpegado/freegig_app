import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:intl/intl.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/features/authentication/screens/login.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  String selectedMusician = '';

  Map<String, List<String>> options = {
    'Voz': ['Cantor', 'Cantora'],
    'Cordas': [
      'Violinista',
      'Violoncelista',
      'Guitarrista',
      'Baixista',
      'Violonista',
      'Harpista'
    ],
    'Teclas': ['Pianista', 'Tecladista', 'Organista'],
    'Sopros': [
      'Flautista',
      'Saxofonista',
      'Trompetista',
      'Trombonista',
      'Clarinetista',
      'Oboísta'
    ],
    'Percussão': ['Baterista', 'Percussionista', 'Timpanista', 'Xilofonista'],
  };

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
                Form(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: firstName,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Iconsax.user),
                                  labelText: "Nome",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: TextFormField(
                                controller: lastName,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Iconsax.user),
                                  labelText: "Sobrenome",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: publicName,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: "Nome artístico",
                            prefixIcon: Icon(Iconsax.magic_star),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: TypeAheadField<String>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: category,
                                  decoration: InputDecoration(
                                    labelText: 'Categoria',
                                    prefixIcon: Icon(Iconsax.music),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                ),
                                suggestionsCallback: (pattern) {
                                  return options.values.expand((e) => e).where(
                                      (e) => e
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  setState(() {
                                    selectedMusician = suggestion;
                                    category.text = suggestion;
                                  });
                                },
                                noItemsFoundBuilder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Categoria não encontrada",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: TextFormField(
                                controller: birthDate,
                                inputFormatters: [
                                  MaskTextInputFormatter(mask: '##-##-####')
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Iconsax.calendar),
                                  labelText: "Nascimento",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: phoneNo,
                          inputFormatters: [
                            MaskTextInputFormatter(
                                mask: "(XX) XXXXX-XXXX",
                                filter: {"X": RegExp(r'[0-9]')})
                          ],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.call),
                            labelText: "Celular",
                            hintText: "(DDD) + Número",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.direct),
                            labelText: "E-mail",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: password,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.password_check),
                            labelText: "Senha",
                            suffixIcon: IconButton(
                              onPressed: () {
                                toggleShowPassword();
                              },
                              icon: Icon(showPassword
                                  ? Iconsax.eye
                                  : Iconsax.eye_slash),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  toggleIsChecked();
                                }),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Concordo com a ",
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      "Política de privacidade",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "e com os ",
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      "Termos de uso",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
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
    try {
      // Converta a data de nascimento para um objeto DateTime
      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(birthDate);

      // Calcule a idade com base na data atual
      int age = DateTime.now().year - parsedDate.year;

      // Verifique se a pessoa tem mais de 18 anos
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
