import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freegig_app/features/feature_1/provider/favoriteprovider.dart';
import 'package:freegig_app/features/feature_1/screens/3_musiciandetail.dart';
import 'package:freegig_app/data/data.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

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
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

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
            final isFavorited =
                favoritesProvider.favoritedIndexes.contains(index);
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Imagem do perfil
                      InkWell(
                        onTap: () {
                          openProfileDetails(index);
                        },
                        child: ClipOval(
                          child: Image.asset(
                            pr.image,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Nome do perfil
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  pr.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),

                                /// Favoritar
                                IconButton(
                                  onPressed: () {
                                    favoritesProvider.toggleFavorite(index);
                                    if (isFavorited) {
                                      Fluttertoast.showToast(
                                        msg: "Removido dos favoritos",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Adicionado aos favoritos",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  },
                                  icon: isFavorited
                                      ? Icon(
                                          Iconsax.heart5,
                                          color: Colors.red,
                                          size: 26,
                                        )
                                      : Icon(
                                          Iconsax.heart,
                                          size: 26,
                                        ),
                                ),
                              ],
                            ),

                            /// Descricao
                            Text(
                              pr.description,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
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
                                  IconButton(
                                    icon: Icon(Iconsax.arrow_right_3),
                                    onPressed: () {
                                      openProfileDetails(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
