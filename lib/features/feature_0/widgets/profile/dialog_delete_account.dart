import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/authentication/screens/auth_google_gate.dart';
import 'package:freegig_app/features/authentication/screens/reauth.dart';
import 'package:freegig_app/features/authentication/screens/reauthGoogle.dart';
import 'package:iconsax/iconsax.dart';

class DeleteAccountConfirm extends StatelessWidget {
  const DeleteAccountConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return AlertDialog(
      title: Text(
        'Excluir minha conta',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Iconsax.danger5,
            size: 40,
            color: Colors.red,
          ),
          SizedBox(height: 15),
          Text(
            "Tem certeza de que deseja excluir permanentemente sua conta? Essa ação não poderá ser desfeita.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (user != null) {
              // O usuário está autenticado, agora verificamos o provedor
              bool isGoogleUser = await user.providerData
                  .any((userInfo) => userInfo.providerId == 'google.com');
              print(isGoogleUser);

              if (isGoogleUser) {
                // O usuário está autenticado com o Google, navegue para uma página
                navigationFadeTo(
                    context: context, destination: ReAuthGoogleScreen());
              } else {
                // O usuário está autenticado, mas não com o Google, navegue para outra página
                navigationFadeTo(context: context, destination: ReAuthScreen());
              }
            } else {
              // O usuário não está autenticado, navegue para uma página de login
              navigationFadeTo(context: context, destination: AuthGoogleGate());
            }
          },
          child: Text(
            'Excluir',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

// segunda confirmacao
class DeletedAccountDetails extends StatelessWidget {
  const DeletedAccountDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Conta excluida'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '😢',
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: 15),
          Text(
            'Lamentamos saber que você está saindo. Por favor, compartilhe o que não atendeu às suas expectativas, para que possamos trabalhar para melhorar no futuro. Clique no e-mail abaixo para nos enviar uma mensagem.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "freegigbr@gmail.com",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: Text(
            'Fechar',
          ),
        ),
      ],
    );
  }
}
