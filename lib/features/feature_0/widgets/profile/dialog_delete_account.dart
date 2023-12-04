import 'package:flutter/material.dart';
import 'package:freegig_app/services/common/delete_account.dart';
import 'package:iconsax/iconsax.dart';

class DeleteAccountConfirm extends StatelessWidget {
  const DeleteAccountConfirm({super.key});

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            Navigator.of(context).pop(context);
            showDialog(
                context: context, builder: (context) => DeleteAccountDetails());
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
class DeleteAccountDetails extends StatelessWidget {
  const DeleteAccountDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Conte-nos mais detalhes',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '😢',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 15),
            Text(
              "Lamentamos saber que você está considerando sair. Por favor, compartilhe o que não atendeu às suas expectativas, para que possamos trabalhar para melhorar no futuro. Clique no e-mail abaixo para nos enviar uma mensagem.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "faleconosco@freegig.com.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 20),
          ],
        ),
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
          onPressed: () {
            DeleteUserService().deleteUserAndRelatedData(context);
          },
          child: Text(
            'Excluir conta',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
