// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freegig_app/data/data.dart';
import 'package:iconsax/iconsax.dart';

class GigsCard extends StatelessWidget {
  GigsCard({super.key});

  //Funcao para criar as estrelas de avaliacao

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: gigs.map((g) {
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: InkWell(
                onTap: () {
                  gigJoin(context, g);
                },
                child: Card(
                  elevation: 2,

                  ///Description GIG
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
                                g.gigdescription,
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
                                  //color: Colors.white,
                                ),
                                SizedBox(width: 4),

                                ///Cache
                                SizedBox(
                                  child: Text(
                                    g.cache,
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
                            /// Local
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
                                    g.cidade,
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
                                      ///Data
                                      Row(
                                        children: [
                                          Icon(
                                            Iconsax.calendar5,
                                            size: 14.0,
                                            color: Colors.black54,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            g.date,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),

                                      ///Hora
                                      Row(
                                        children: [
                                          Icon(
                                            Iconsax.clock5,
                                            size: 14.0,
                                            color: Colors.black54,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            g.hour,
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

                                  ///Profile
                                  Row(
                                    children: [
                                      Text(
                                        g.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      ClipOval(
                                        child: Image.asset(
                                          g.image,
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

                            /// Data e hora
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 30)
      ],
    );
  }
}

Future gigJoin(context, Gig gig) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Entrar na GIG",
          textAlign: TextAlign.center,
        ),
        content:

            ///
            Container(
          height: 400,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                Text(
                  "${gig.gigdetails}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Para: ${gig.musicianCategory}",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Cachê: ${gig.cache}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Cidade: ${gig.cidade}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Data: ${gig.date}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Horário: ${gig.hour}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Participantes: ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Participante(
                    name: gig.name, image: gig.image, category: gig.instrument),
                Participante(
                    name: "Samir Pegado",
                    image: "assets/profiles/samir.png",
                    category: "Baterista"),
              ],
            ),
          ),
        ),

        ///
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.close,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: "Solicitação enviada com sucesso",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.check,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

class Participante extends StatelessWidget {
  final String name;
  final String image;
  final String category;
  const Participante(
      {super.key,
      required this.name,
      required this.image,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8),
            Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            SizedBox(width: 4),
            Text(
              "(${category})",
              style: TextStyle(
                fontSize: 14.0,
              ),
            )
          ],
        ),
        SizedBox(height: 6),
      ],
    );
  }
}
