// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_1/widgets/musician_usercategorybutton.dart';
import 'package:freegig_app/features/feature_1/widgets/musician_usercitybutton.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/features/feature_1/widgets/musicians_cardsroll.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:iconsax/iconsax.dart';

class ListMusicians extends StatefulWidget {
  final Stream<List<Map<String, dynamic>>> profileListFunction;
  final String city;
  final String category;
  const ListMusicians(
      {super.key,
      required this.profileListFunction,
      required this.city,
      required this.category});

  @override
  _ListMusiciansState createState() => _ListMusiciansState();
}

class _ListMusiciansState extends State<ListMusicians> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NavigationMenu()));
        return false;
      },
      child: Scaffold(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UserCityButtonProfile(
                    city: widget.city,
                    category: widget.category,
                  ),
                  MusicianCategoryButton(
                      city: widget.city, category: widget.category)
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    HomeCardsRoll(
                      profileListFunction: widget.profileListFunction,
                    ),
                  ],
                ),
              ))
            ],
          ),
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpansionTile(
              initiallyExpanded: true,
              title: Text("Avaliação"),
              children: [
                TextButton(onPressed: () {}, child: Text('Maior para o menor')),
                TextButton(onPressed: () {}, child: Text('Menor para o maior')),
              ],
            ),
          ],
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
