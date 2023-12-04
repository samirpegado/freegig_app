import 'package:flutter/material.dart';
import 'package:freegig_app/common/widgets/musicianonlyselectionform.dart';
import 'package:freegig_app/common/widgets/search_list_city.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
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
  final GlobalKey formKey;
  final bool cityValidator;

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
    required this.formKey,
    required this.cityValidator,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool showPassword = false;
  bool isChecked = false;

  final formKey = GlobalKey<FormState>();

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

  bool isOver18(String birthDate) {
    try {
      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(birthDate);
      int age = DateTime.now().year - parsedDate.year;
      return age >= 18;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.firstName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo obrigatório';
                      } else {
                        return null;
                      }
                    },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo obrigatório';
                      } else {
                        return null;
                      }
                    },
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo obrigatório';
                } else {
                  return null;
                }
              },
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
            Row(
              children: [
                Visibility(
                  visible: widget.cityValidator,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                    child: Text(
                      'Cidade inválida.',
                      style: TextStyle(
                          color: Color.fromARGB(255, 223, 41, 28),
                          fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (!isOver18(value)) {
                        return 'Menor de 18 anos';
                      } else {
                        return null;
                      }
                    },
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo obrigatório';
                } else {
                  return null;
                }
              },
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo obrigatório';
                } else {
                  return null;
                }
              },
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo obrigatório';
                } else {
                  return null;
                }
              },
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Ao se cadastrar, você concorda com os ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextSpan(
                      text: 'Termos de Serviço',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' do Freegig.',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
