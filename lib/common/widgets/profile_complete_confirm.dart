import 'package:flutter/material.dart';
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NavigationMenu(navPage: 3)));
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
