import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/createnewgigform.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:iconsax/iconsax.dart';

class CreateGigs extends StatefulWidget {
  @override
  _CreateGigsState createState() => _CreateGigsState();
}

class _CreateGigsState extends State<CreateGigs> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ExpansionTile(
                  title: Row(children: [
                    Icon(
                      Iconsax.calendar_add5,
                      size: 26,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Criadas",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  ]),
                  children: [],
                ),
                SizedBox(height: 15),
                ExpansionTile(
                  title: Row(children: [
                    Icon(
                      Iconsax.calendar_tick5,
                      size: 26,
                      color: Colors.green,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Participando",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  ]),
                  children: [],
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

        ///Add gig buton
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                openGigCreator(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Iconsax.add,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

Future openGigCreator(context) => showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: backgroundColor,
        child: CreateNewGig(),
      ),
    );
