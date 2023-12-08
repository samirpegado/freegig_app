// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:freegig_app/common/widgets/my_gigs_card_tile.dart';
import 'package:freegig_app/services/gigs/gigs_service.dart';
import 'package:freegig_app/features/feature_0/screens/gigs/gigs_participating.dart';
import 'package:iconsax/iconsax.dart';

class ParticipantGigsCard extends StatefulWidget {
  @override
  State<ParticipantGigsCard> createState() => _ParticipantGigsCardState();
}

class _ParticipantGigsCardState extends State<ParticipantGigsCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: GigsDataService().getParticipantGigsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: MediaQuery.sizeOf(context).height * 0.6,
            child: Center(
              child: CircularProgressIndicator(),
            ),
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
              return MyGigsCardTile(
                destination: ParticipatingGigInfo(gig: gig),
                gig: gig,
                leadingIcon: Icon(
                  Iconsax.share,
                  color: Colors.grey[500],
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
