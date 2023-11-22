import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
    'Teclas': ['Pianista', 'Tecladista', 'Organista', 'Sanfoneiro'],
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
                  child: TypeAheadField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: widget.category,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Categoria',
                        prefixIcon: Icon(Iconsax.music),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      return options.values.expand((e) => e).where((e) =>
                          e.toLowerCase().contains(pattern.toLowerCase()));
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        selectedMusician = suggestion;
                        widget.category.text = suggestion;
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
