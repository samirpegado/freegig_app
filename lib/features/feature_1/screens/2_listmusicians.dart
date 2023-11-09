// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:freegig_app/data/data.dart';
import 'package:freegig_app/features/feature_1/widgets/musicians_cardsroll.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:iconsax/iconsax.dart';

class ListMusicians extends StatefulWidget {
  const ListMusicians({super.key});

  @override
  _ListMusiciansState createState() => _ListMusiciansState();
}

class _ListMusiciansState extends State<ListMusicians> {
  List<bool> isClickedList = List.filled(profiles.length, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Músicos para sua GIG',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              openFilter(context);
            },
            icon: Icon(
              Iconsax.setting_4,
              color: Colors.black,
            ),
          )
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  HomeCardsRoll(),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

Future openFilter(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Filtrar"),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                )),
          ],
        ),
        content: Container(
          height: 250,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ExpansionTile(
                  title: Text("Avaliação"),
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "De",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text("-"),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Até",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                ExpansionTile(
                  title: Text("Categoria"),
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Categoria",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.check,
              )),
        ],
      ),
    );
