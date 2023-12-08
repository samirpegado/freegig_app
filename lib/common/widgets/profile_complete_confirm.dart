import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';

class ProfileCompleteConfirm extends StatelessWidget {
  const ProfileCompleteConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Complete seu perfil!'),
      content: Text(
        'Você ainda não pode realizar esta ação! Para aproveitar ao máximo nossos recursos, complete seu perfil.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Fechar',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {
            navigationFadeTo(
                context: context, destination: NavigationMenu(navPage: 3));
          },
          child: Text(
            'Completar',
            style: TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
  }
}
