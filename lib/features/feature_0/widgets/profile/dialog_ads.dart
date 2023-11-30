import 'package:flutter/material.dart';

class AdsDialog extends StatelessWidget {
  const AdsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Anuncie sua marca',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blue),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '😊',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 15),
            Text(
              "Gostaria de destacar a sua marca? Anuncie conosco! Entre em contato através do e-mail abaixo para descobrir as incríveis oportunidades que temos para promover o seu negócio.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              "comercial@freegig.com",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 15),
            SizedBox(height: 15),
            Text(
              'Equipe FreeGIG',
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.center,
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
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
