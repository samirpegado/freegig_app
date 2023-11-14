// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:iconsax/iconsax.dart';

class MyGigsCard extends StatefulWidget {
  @override
  State<MyGigsCard> createState() => _MyGigsCardState();
}

class _MyGigsCardState extends State<MyGigsCard> {
  late Future<List<Map<String, dynamic>>> gigsDataList;

  @override
  void initState() {
    super.initState();
    gigsDataList = GigsDataService().getMyActiveGigs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: gigsDataList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Se estiver esperando, você pode retornar um indicador de carregamento, por exemplo.
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Se houver um erro, você pode tratá-lo aqui
          return Text('Erro: ${snapshot.error}');
        } else {
          // Se estiver tudo bem, você pode acessar os dados em snapshot.data
          List<Map<String, dynamic>> gigs = snapshot.data!;
          // Agora você pode usar a lista de gigs normalmente no seu código
          if (gigs.isEmpty) {
            // Se a lista de gigs estiver vazia, exibe a mensagem "Nenhuma gig encontrada"
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
                    // Ação ao tocar
                    gigJoin(context, gig);
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

Future gigJoin(context, Map<String, dynamic> gig) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Entrar na GIG",
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: 400,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                Text(
                  "${gig['gigDetails']}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Para: ${gig['gigCategorys']}",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Cachê: ${gig['gigCache']}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Cidade: ${gig['gigLocale']}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Data: ${gig['gigDate']}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Horário: ${gig['gigInitHour']} - ${gig['gigFinalHour']}",
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
                    name: gig['publicName'],
                    image: gig['profileImageUrl'],
                    category: gig['category']),
              ],
            ),
          ),
        ),
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
      {Key? key,
      required this.name,
      required this.image,
      required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.network(
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
