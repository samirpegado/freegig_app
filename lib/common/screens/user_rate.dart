import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/services/relationship/user_rate.dart';
import 'package:iconsax/iconsax.dart';

class UserRating extends StatefulWidget {
  final Map<String, dynamic> docData;

  const UserRating({
    super.key,
    required this.docData,
  });

  @override
  State<UserRating> createState() => _UserRatingState();
}

class _UserRatingState extends State<UserRating> {
  late Future<List<Map<String, dynamic>>> participantsData;
  List<bool> starColors = [];
  final commentController = TextEditingController();
  double starValue = 5;
  late String _currentUser = '';
  late String _gigDescription = '';
  late String _gigCity = '';
  late String _gigDate = '00-00-0000';

  @override
  void initState() {
    super.initState();
    _loadGigData();
    participantsData =
        UserRateService().getRateParticipantsData(widget.docData['gigUid']);
    initializeStarColors();
  }

  // Carrega os dados da GIG e do usuário logado
  Future<void> _loadGigData() async {
    try {
      Map<String, dynamic> gigData =
          await UserRateService().getGigData(widget.docData['gigUid']);

      setState(() {
        _currentUser = gigData['currentUser'];
        _gigDescription = gigData['gigDescription'];
        _gigCity = gigData['gigLocale'];
        _gigDate = gigData['gigDate'];
      });
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  // Inicializa starColors com o mesmo tamanho que a lista de participantes
  void initializeStarColors() {
    participantsData.then((participants) {
      setState(() {
        starColors = List.filled(participants.length, false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// Confirmacoes de saida da pagina
        showDialog(context: context, builder: (context) => _exitAlert());

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Avaliar participantes',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 19.0,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        backgroundColor: backgroundColor,
        bottomNavigationBar: _evaluationButton(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header com as informacoes da GIG
                SizedBox(height: 10),
                Text(
                  _gigDescription,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
                Text(
                  FormatDate().formatDateString(_gigDate),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Iconsax.location5,
                      size: 25,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _gigCity,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  "Participantes: ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
                SizedBox(height: 6),

                /// Carrega a lista de participantes a serem avaliados
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: participantsData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        'Erro ao carregar participantes: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text(
                        'Nenhum participante encontrado.',
                        style: TextStyle(fontSize: 15),
                      );
                    } else {
                      List<Map<String, dynamic>> participantsData =
                          snapshot.data!;

                      return Column(
                        children: participantsData.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> participant = entry.value;

                          if (participant['uid'] != _currentUser) {
                            return ListTile(
                              onTap: () {
                                starValue = 5;
                                commentController.clear();
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      _evaluationDialog(participant, index),
                                );
                              },
                              leading: ClipOval(
                                child: Image.network(
                                  participant['profileImageUrl'],
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              trailing: Icon(
                                Icons.star,
                                color: starColors[index]
                                    ? Colors.amber
                                    : Colors.grey,
                                size: 30,
                              ),
                              title: Text(
                                participant['publicName'],
                                style: TextStyle(fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    participant['category'],
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _exitAlert() {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('Sair da avaliação?')),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close))
        ],
      ),
      content: Text(
          "Deseja sair da avaliação antes de finalizá-la? Selecione uma das opções abaixo."),
      actions: [
        TextButton(
          onPressed: () async {
            await UserRateService()
                .rateNotificationDelete(widget.docData['rateNotificationUid']);
            navigationFadeTo(
                context: context, destination: NavigationMenu(navPage: 1));
          },
          child: Text(
            'Sair sem avaliar',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            navigationFadeTo(
                context: context, destination: NavigationMenu(navPage: 1));
          },
          child: Text(
            'Avaliar depois',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _evaluationButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () async {
              await UserRateService().rateNotificationDelete(
                  widget.docData['rateNotificationUid']);
              navigationFadeTo(
                  context: context, destination: NavigationMenu(navPage: 1));
            },
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                "Concluir",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _evaluationDialog(Map<String, dynamic> participant, int index) {
    return AlertDialog(
      title: Text(
        'Como você avalia este participante?',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              participant['publicName'],
              style: TextStyle(fontSize: 20),
            ),
            Text(
              participant['category'],
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 10),
            RatingBar(
              minRating: 1,
              maxRating: 5,
              initialRating: 5,
              ratingWidget: RatingWidget(
                full: Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                half: Icon(
                  Icons.star_half,
                  color: Colors.amber,
                ),
                empty: Icon(
                  Icons.star,
                  color: Colors.grey,
                ),
              ),
              onRatingUpdate: (value) {
                starValue = value;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: commentController,
              maxLength: 50,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Comentário",
                prefixIcon: Icon(Iconsax.device_message),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Fechar',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () async {
            await UserRateService().sendParticipantRate(
              rate: starValue,
              gigUid: widget.docData['gigUid'],
              ratedParticipantUid: participant['uid'],
              comment: commentController.text,
            );
            setState(() {
              starColors[index] = true;
            });
            Navigator.of(context).pop();
          },
          child: Text(
            'Enviar',
          ),
        ),
      ],
    );
  }
}
