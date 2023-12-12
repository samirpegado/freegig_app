import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPasswordAlert extends StatefulWidget {
  const ForgotPasswordAlert({super.key});

  @override
  State<ForgotPasswordAlert> createState() => _ForgotPasswordAlertState();
}

class _ForgotPasswordAlertState extends State<ForgotPasswordAlert> {
  final emailToResetController = TextEditingController();
  late bool isloading = false;

  @override
  void dispose() {
    emailToResetController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailToResetController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      String errorMessage = "Erro ao resetar senha";

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'E-mail inválido.';
          break;
        case 'INVALID_LOGIN_CREDENTIALS':
          errorMessage = 'E-mail inválido.';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta. Tente novamente.';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Esqueceu sua senha?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Esqueceu sua senha? Não se preocupe. Basta inserir o seu endereço de e-mail abaixo, e enviaremos um link seguro para você redefinir sua senha.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailToResetController,
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Fechar',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        isloading
            ? CircularProgressIndicator()
            : TextButton(
                onPressed: () async {
                  setState(() {
                    isloading = true;
                  });
                  await passwordReset();
                  setState(() {
                    isloading = false;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Enviar'),
              )
      ],
    );
  }
}
