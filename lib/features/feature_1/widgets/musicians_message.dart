import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freegig_app/data/data.dart';
import 'package:iconsax/iconsax.dart';

class MessageToMusician extends StatelessWidget {
  const MessageToMusician({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Enviar mensagem",
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 160,
        child: Column(
          children: [
            Text(
              "Para: ${profile.name}",
            ),
            SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Mensagem",
                hintText: 'Escreva aqui a sua mensagem...',
                prefixIcon: Icon(Iconsax.device_message),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Iconsax.forbidden_2,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Mensagem enviada",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Iconsax.send_1,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: 15),
            ],
          ),
        )
      ],
    );
  }
}
