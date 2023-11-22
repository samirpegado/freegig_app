import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/created_gigs_card.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/participating_gigs_card.dart';
import 'package:iconsax/iconsax.dart';

class ListMyGigs extends StatefulWidget {
  @override
  _ListMyGigsState createState() => _ListMyGigsState();
}

class _ListMyGigsState extends State<ListMyGigs> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Row(children: [
                    Icon(
                      Iconsax.calendar_add5,
                      size: 26,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Criadas",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.blue),
                    )
                  ]),
                  children: [MyGigsCard()],
                ),
                SizedBox(height: 15),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Row(children: [
                    Icon(
                      Iconsax.calendar_tick5,
                      size: 26,
                      color: Colors.green,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Participando",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.green),
                    )
                  ]),
                  children: [ParticipantGigsCard()],
                ),
                SizedBox(height: 15),
                ExpansionTile(
                  title: Row(children: [
                    Icon(
                      Iconsax.calendar_remove5,
                      size: 26,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Arquivadas",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  ]),
                  children: [],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
