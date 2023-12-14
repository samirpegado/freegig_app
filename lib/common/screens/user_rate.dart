import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:freegig_app/common/widgets/build_profile_image.dart';
import 'package:freegig_app/features/feature_0/screens/home/notifications.dart';
import 'package:freegig_app/services/notification/notifications_service.dart';
import 'package:freegig_app/services/relationship/user_rate.dart';
import 'package:iconsax/iconsax.dart';

class UserRating extends StatefulWidget {
  final String gigUid;
  final String notificationID;
  final String currentUserID;

  const UserRating({
    super.key,
    required this.gigUid,
    required this.notificationID,
    required this.currentUserID,
  });

  @override
  State<UserRating> createState() => _UserRatingState();
}

class _UserRatingState extends State<UserRating> {
  late Future<List<Map<String, dynamic>>> participantsData;
  List<bool> starColors = [];
  final commentController = TextEditingController();
  double starValue = 5;

  @override
  void initState() {
    super.initState();
    participantsData = UserRateService().getRateParticipantsData(widget.gigUid);
    initializeStarColors();
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
    return Scaffold(
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

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('gigs')
                    .doc(widget.gigUid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('Documento não encontrado');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['gigDescription'],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Iconsax.calendar,
                            size: 20,
                            color: Colors.green,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              FormatDate().formatDateString(data['gigDate']),
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Iconsax.clock,
                            size: 20,
                            color: Colors.green,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${data['gigInitHour']}h - ${data['gigFinalHour']}h",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Iconsax.location,
                            size: 20,
                            color: Colors.green,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              data['gigAdress'],
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
              Text(
                "Participantes: ",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
              SizedBox(height: 6),

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

                        if (participant['uid'] != widget.currentUserID) {
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
                            leading: BuildProfileImage(
                                profileImageUrl: participant['profileImageUrl'],
                                imageSize: 50),
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
              await NotificationService()
                  .removeNotification(notificationID: widget.notificationID);
              navigationFadeTo(
                  context: context, destination: GigsNotification());
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
        'Como você avalia esta pessoa?',
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
              gigUid: widget.gigUid,
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
