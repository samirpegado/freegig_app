import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/musicianonlyselectionform.dart';
import 'package:freegig_app/common_widgets/searchgooglecity.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignUpForm extends StatefulWidget {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController publicName;
  final TextEditingController category;
  final TextEditingController city;
  final TextEditingController birthDate;
  final TextEditingController phoneNo;
  final TextEditingController email;
  final TextEditingController password;

  const SignUpForm({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.publicName,
    required this.category,
    required this.birthDate,
    required this.phoneNo,
    required this.email,
    required this.password,
    required this.city,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.firstName,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Iconsax.user),
                      labelText: "Nome",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    controller: widget.lastName,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Iconsax.user),
                      labelText: "Sobrenome",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: widget.publicName,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: "Nome artístico",
                prefixIcon: Icon(Iconsax.magic_star),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            SizedBox(height: 15),
            SearchGoogleCity(cityController: widget.city),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: MusicianOnlySelectionForm(
                    categoryController: widget.category,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    controller: widget.birthDate,
                    inputFormatters: [
                      MaskTextInputFormatter(mask: '##-##-####')
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
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
              controller: widget.phoneNo,
              inputFormatters: [
                MaskTextInputFormatter(
                    mask: "(XX) XXXXX-XXXX", filter: {"X": RegExp(r'[0-9]')})
              ],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
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
              controller: widget.email,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Iconsax.direct),
                labelText: "E-mail",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: widget.password,
              obscureText: !showPassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Iconsax.password_check),
                labelText: "Senha",
                suffixIcon: IconButton(
                  onPressed: () {
                    toggleShowPassword();
                  },
                  icon: Icon(showPassword ? Iconsax.eye : Iconsax.eye_slash),
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
    );
  }
}
