// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:freegig_app/common/widgets/my_gigs_card_tile.dart';
import 'package:freegig_app/features/feature_0/screens/gigs/gigs_participating.dart';
import 'package:freegig_app/services/gigs/gigs_service.dart';
import 'package:freegig_app/features/feature_0/screens/gigs/gigs_created.dart';
import 'package:iconsax/iconsax.dart';

class MyGigCards extends StatefulWidget {
  @override
  State<MyGigCards> createState() => _MyGigsCardState();
}

class _MyGigsCardState extends State<MyGigCards> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: GigsDataService().getMyActiveGigsStream(),
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
              /// Mapeia os dados da funcao getMyActiveGigsStream
              List<Map<String, dynamic>> createdGigs = snapshot.data ?? [];

              //Aninha o outro StreamBuilder
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
                    /// Mapeia os dados da funcao getParticipantGigsStream
                    List<Map<String, dynamic>> participatingGigs =
                        snapshot.data ?? [];

                    if (createdGigs.isEmpty && participatingGigs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Icon(
                                  Iconsax.music_play,
                                  size: 40,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                "Aqui você encontrará as gigs que você criou e aquelas em que está participando.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        ///
                        ///Cria os cards das GIGs que o usuario criou
                        Column(
                          children: createdGigs.map((gig) {
                            return MyGigsCardTile(
                              destination: CreatedGigInfo(gig: gig),
                              gig: gig,
                              leadingIcon: Icon(
                                Iconsax.note_add,
                                color: Colors.blue,
                              ),
                            );
                          }).toList(),
                        ),

                        ///Cria os cards das GIGs que o usuario esta participando
                        Column(
                          children: participatingGigs.map((gig) {
                            return MyGigsCardTile(
                              destination: ParticipatingGigInfo(gig: gig),
                              gig: gig,
                              leadingIcon: Icon(
                                Iconsax.share,
                                color: Colors.green,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ],
    );
  }
}
