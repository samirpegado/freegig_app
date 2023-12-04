// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/gigs_card.dart';
import 'package:freegig_app/services/gigs/gigs_service.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/participating_giginfo.dart';

class ParticipantGigsCard extends StatefulWidget {
  @override
  State<ParticipantGigsCard> createState() => _ParticipantGigsCardState();
}

class _ParticipantGigsCardState extends State<ParticipantGigsCard> {
  late Stream<List<Map<String, dynamic>>> gigsDataList;

  @override
  void initState() {
    super.initState();
    gigsDataList = GigsDataService().getParticipantGigsStream();
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
              // Seu código para construir os cards
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ParticipatingGigInfo(gig: gig)));
                  },
                  child: CommonGigsCard(
                    gig: gig,
                    moneyColor: Colors.green,
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
