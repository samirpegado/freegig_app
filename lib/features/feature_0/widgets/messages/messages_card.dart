import 'package:flutter/material.dart';
import 'package:freegig_app/data/data.dart';
import 'package:iconsax/iconsax.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: msg.map((m) {
          return Padding(
            padding: EdgeInsets.only(top: 26, left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      width: 230,
                      child: Text(
                        "GIG em ${m.local}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 230,
                      child: Text(
                        m.ultimamsg,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        m.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 15),
                    Icon(
                      Iconsax.arrow_right_3,
                      size: 30,
                    )
                  ],
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
