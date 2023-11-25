// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/gigs_card.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/created_giginfo.dart';

class MyGigsCard extends StatefulWidget {
  @override
  State<MyGigsCard> createState() => _MyGigsCardState();
}

class _MyGigsCardState extends State<MyGigsCard> {
  late Stream<List<Map<String, dynamic>>> gigsDataList;

  @override
  void initState() {
    super.initState();
    gigsDataList = GigsDataService().getMyActiveGigsStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: gigsDataList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> gigs = snapshot.data ?? [];

          if (gigs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                  'Nenhuma gig encontrada',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }
          return Column(
            children: gigs.map((gig) {
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreatedGigInfo(gig: gig)));
                    },
                    child: CommonGigsCard(
                      gig: gig,
                      moneyColor: Colors.blue,
                    )),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
