import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeAgenda extends StatelessWidget {
  const HomeAgenda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 30),
              Icon(Iconsax.calendar5, color: Color.fromARGB(255, 55, 158, 58)),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Suas GIGs",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 19.0,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              padding: EdgeInsets.all(35),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 211, 211, 211).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Suas próximas GIGs aparecerão aqui",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
