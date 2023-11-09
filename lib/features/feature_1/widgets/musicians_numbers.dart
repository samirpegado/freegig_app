import 'package:flutter/material.dart';
import 'package:freegig_app/data/data.dart';
import 'package:iconsax/iconsax.dart';

class ProfileNumbers extends StatelessWidget {
  const ProfileNumbers({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Icon(
              Iconsax.star1,
              color: Colors.amber,
              size: 40,
            ),
            Text(
              profile.rate,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(width: 20),
        Container(
          height: 40,
          width: 2,
          color: Colors.grey,
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Icon(
              Iconsax.document_normal4,
              color: Colors.blue,
              size: 40,
            ),
            Text(
              profile.ncomments,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
