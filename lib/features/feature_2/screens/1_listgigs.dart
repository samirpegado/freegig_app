import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/usercitybutton_gig.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/features/feature_2/widgets/gigs_descriptioncard.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:iconsax/iconsax.dart';

class ListGigs extends StatefulWidget {
  final Stream<List<Map<String, dynamic>>> dataListFunction;
  final String city;
  const ListGigs(
      {super.key, required this.dataListFunction, required this.city});

  @override
  State<ListGigs> createState() => _ListGigsState();
}

class _ListGigsState extends State<ListGigs> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.dataListFunction;
  }

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
              UserCityButtonGig(
                city: widget.city,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GigsCard(
                        dataListFunction: widget.dataListFunction,
                      ),
                    ],
                  ),
                ),
              )
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
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Categoria",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
