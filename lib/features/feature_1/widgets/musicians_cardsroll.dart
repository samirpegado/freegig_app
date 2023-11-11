import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_1/screens/3_musiciandetail.dart';
import 'package:freegig_app/data/data.dart';
import 'package:iconsax/iconsax.dart';

class HomeCardsRoll extends StatefulWidget {
  @override
  _HomeCardsRollState createState() => _HomeCardsRollState();
}

class _HomeCardsRollState extends State<HomeCardsRoll> {
  List<bool> isClickedList = List.filled(profiles.length, false);

  //lista para rastrear músicos favoritados

  /// Funcao para clicar no coracao
  void toggleFavorite(int index) {
    setState(() {
      isClickedList[index] = !isClickedList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    void openProfileDetails(int index) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProfileDetailsPage(profile: profiles[index]),
        ),
      );
    }

    return Column(
      children: [
        Column(
          children: profiles.asMap().entries.map((entry) {
            final index = entry.key;
            final pr = entry.value;

            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: InkWell(
                onTap: () {
                  openProfileDetails(index);
                },
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Imagem do perfil
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage(pr.image),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Nome do perfil
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    pr.name,
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
                                  Text("(Categoria)"),
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.star1,
                                        color: Colors.amber,
                                        size: 28,
                                      ),

                                      /// Avaliacao
                                      Text(
                                        pr.rate,
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 80, 78, 78),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(width: 5),

                                      /// Numero de comentarios
                                      Text(
                                        '(${pr.ncomments})',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 134, 133, 133),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),

                              /// Descricao
                              Text(
                                pr.description,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
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
}
