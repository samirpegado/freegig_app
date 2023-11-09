import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_2/widgets/gigs_descriptioncard.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:iconsax/iconsax.dart';

class ListGigs extends StatelessWidget {
  const ListGigs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GIGs para o seu Free',
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
                    //SizedBox(height: 20),
                    GigsCard(),
                  ],
                ),
              ),
            )
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
                  title: Text("Cache"),
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
                  title: Text("Data"),
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
