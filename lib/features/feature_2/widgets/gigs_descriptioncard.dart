// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/gigs_card.dart';
import 'package:freegig_app/features/feature_2/widgets/confirmrequest.dart';

class GigsCard extends StatefulWidget {
  final Stream<List<Map<String, dynamic>>> dataListFunction;
  const GigsCard({super.key, required this.dataListFunction});
  @override
  State<GigsCard> createState() => _GigsCardState();
}

class _GigsCardState extends State<GigsCard> {
  late Stream<List<Map<String, dynamic>>> gigsDataList;

  @override
  void initState() {
    super.initState();
    gigsDataList = widget.dataListFunction;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: gigsDataList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
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
            children: gigs.map(
              (gig) {
                // Seu código para construir os cards
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      // Ação ao tocar
                      gigJoin(context, gig);
                    },
                    child: CommonGigsCard(
                      gig: gig,
                      moneyColor: Colors.green,
                    ),
                  ),
                );
              },
            ).toList(),
          );
        }
      },
    );
  }
}

Future gigJoin(context, Map<String, dynamic> gig) => showDialog(
      context: context,
      builder: (context) => ConfirmRequest(
        gig: gig,
      ),
    );
