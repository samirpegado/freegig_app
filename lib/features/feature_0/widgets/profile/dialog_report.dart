import 'package:flutter/material.dart';

class ReportDialog extends StatelessWidget {
  const ReportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Reporte de inconsistência',
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
              "Estamos aqui para ajudar! Se você encontrar qualquer erro, inconsistência, abuso, ou má conduta de usuários em nossa plataforma, não hesite em nos contatar. Nossos canais de apoio estão prontos para lhe atender. Por favor, entre em contato conosco através do nosso e-mail:",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              "faleconosco@freegig.com.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 15),
            Text(
              "Agradecemos por sua colaboração em manter a comunidade Freegig segura e positiva para todos.",
              textAlign: TextAlign.center,
            ),
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
