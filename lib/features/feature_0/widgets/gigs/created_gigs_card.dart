// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/created_giginfo.dart';
import 'package:iconsax/iconsax.dart';

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
              // Seu código para construir os cards
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreatedGigInfo(gig: gig)));
                  },
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 240,
                                child: Text(
                                  gig['gigDescription'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.money_recive5,
                                    size: 20.0,
                                    color: Color.fromARGB(255, 55, 158, 58),
                                  ),
                                  SizedBox(width: 4),
                                  SizedBox(
                                    child: Text(
                                      gig['gigCache'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.location5,
                                    size: 14.0,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(width: 4),
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      gig['gigLocale'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Iconsax.calendar5,
                                              size: 14.0,
                                              color: Colors.black54,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              gig['gigDate'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Iconsax.clock5,
                                              size: 14.0,
                                              color: Colors.black54,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${gig['gigInitHour']} - ${gig['gigFinalHour']}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          gig['publicName'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        ClipOval(
                                          child: Image.network(
                                            gig['profileImageUrl'],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
