import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/functions/toast.dart';
import 'package:freegig_app/common/screens/show_profile.dart';
import 'package:freegig_app/common/widgets/build_profile_image.dart';
import 'package:freegig_app/common/widgets/participants_list.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/services/notification/notifications_service.dart';
import 'package:iconsax/iconsax.dart';

class RequestConfirmation extends StatefulWidget {
  final String gigUid;
  final String notificationID;
  final String senderID;

  const RequestConfirmation({
    super.key,
    required this.gigUid,
    required this.notificationID,
    required this.senderID,
  });

  @override
  State<RequestConfirmation> createState() => _RequestConfirmationState();
}

class _RequestConfirmationState extends State<RequestConfirmation> {
  late bool gigStatus = false;
  late bool gigArchived = false;
  late bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Gerir solicitação",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

                gigStatus = data['gigCompleted'];
                gigArchived = data['gigArchived'];

                return Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          gigStatus ? Iconsax.lock : Iconsax.unlock,
                          size: 20,
                          color: gigStatus ? Colors.green : Colors.black,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            gigStatus ? 'Fechada' : 'Aberta',
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
                          Iconsax.money,
                          size: 20,
                          color: Colors.green,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            data['gigCache'],
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
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            ParticipantList(gigUid: widget.gigUid),
            SizedBox(height: 20),
            Visibility(
              visible: isLoading ? false : true,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.senderID)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text('Solicitante não encontrado');
                    }
                    Map<String, dynamic> senderData =
                        snapshot.data!.data() as Map<String, dynamic>;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Solicitante: ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue),
                        ),
                        ListTile(
                          onTap: () {
                            navigationFadeTo(
                                context: context,
                                destination:
                                    SimpleShowProfile(profile: senderData));
                          },
                          leading: BuildProfileImage(
                              profileImageUrl: senderData['profileImageUrl'],
                              imageSize: 40),
                          trailing: Icon(Iconsax.arrow_right_3),
                          title: Text(
                            senderData['publicName'],
                            style: TextStyle(fontSize: 15),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                senderData['category'],
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
            ),
            SizedBox(height: 10),
            Center(
                child: Text(
              'Gostaria de adicionar este solicitante a esta GIG?',
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        isLoading
            ? CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        await NotificationService().removeNotification(
                            notificationID: widget.notificationID);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Recusar',
                        style: TextStyle(color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () async {
                        if (gigStatus == false && gigArchived == false) {
                          setState(() {
                            isLoading = true;
                          });
                          await NotificationService().confirmRequest(
                            gigUid: widget.gigUid,
                            notificationID: widget.notificationID,
                            senderId: widget.senderID,
                          );
                          navigationFadeTo(
                              context: context,
                              destination: NavigationMenu(navPage: 1));
                        } else {
                          Navigator.of(context).pop();
                          showToast(
                              message:
                                  "Esta GIG se encontra fechada ou arquivada.");
                        }
                      },
                      child: Text('Adicionar')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Fechar',
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              )
      ],
    );
  }
}
