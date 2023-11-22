import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_1/screens/2_musiciandetail.dart';
import 'package:iconsax/iconsax.dart';

class HomeCardsRoll extends StatefulWidget {
  final Stream<List<Map<String, dynamic>>> profileListFunction;

  const HomeCardsRoll({super.key, required this.profileListFunction});
  @override
  _HomeCardsRollState createState() => _HomeCardsRollState();
}

class _HomeCardsRollState extends State<HomeCardsRoll> {
  late Stream<List<Map<String, dynamic>>> userDataList;

  @override
  void initState() {
    super.initState();
    userDataList = widget.profileListFunction;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: userDataList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> profiles = snapshot.data ?? [];

            if (profiles.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Text(
                    'Nenhuma músico encontrado',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }
            return Column(
              children: [
                Column(
                  children: profiles.asMap().entries.map((entry) {
                    final index = entry.key;
                    final profile = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileDetailsPage(profile: profiles[index]),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// Imagem do perfil
                                ClipOval(
                                  child: Image.network(
                                    profile['profileImageUrl'],
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// Nome do perfil
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            profile['publicName'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Icon(Iconsax.arrow_right_3)
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(profile['category']),
                                          Row(
                                            children: [
                                              /// Avaliacao
                                              Text(
                                                "N/A",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 80, 78, 78),
                                                    fontSize: 14.0),
                                              ),
                                              SizedBox(width: 3),
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Iconsax.location5,
                                            size: 18,
                                          ),
                                          Text(' ' + profile['city'],
                                              style: TextStyle(fontSize: 14.0)),
                                        ],
                                      ),
                                      SizedBox(height: 6),

                                      /// Descricao
                                      Text(
                                        profile['description'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                )
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
        });
  }
}
