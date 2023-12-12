import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Icon(
                Iconsax.cloud_cross,
                size: 40,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Ops! Algo deu errado. Por favor, tente novamente mais tarde. Se o problema persistir, nos avise. Agradecemos sua compreensão!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
