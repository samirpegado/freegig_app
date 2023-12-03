import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/features/chat/gig_chat_page.dart';
import 'package:freegig_app/services/chat/gig_chat_service.dart';
import 'package:iconsax/iconsax.dart';

class GigListMessages extends StatefulWidget {
  const GigListMessages({Key? key}) : super(key: key);

  @override
  State<GigListMessages> createState() => _GigListMessagesState();
}

class _GigListMessagesState extends State<GigListMessages> {
  final _chatService = GigChatService();
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.getGigChatRoomsData(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }

        // Obtenha os documentos do snapshot
        List<DocumentSnapshot<Map<String, dynamic>>> documents =
            snapshot.data?.docs ?? [];

        // Verifique se há dados
        if (documents.isEmpty) {
          return Container();
        }

        // Construa a UI com base nos dados
        return SingleChildScrollView(
          child: Column(
            children: documents.map((document) {
              Map<String, dynamic> data = document.data()!;

              String gigSubjectUid = data['gigSubjectUid'];

              return ListTile(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                GigChatPage(gigSubjectUid: gigSubjectUid)));
                      },
                      child: ListTile(
                        title: Text(data['gigDescription']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                FormatDate().formatDateString(data['gigDate']) +
                                    ', ' +
                                    data['gigInitHour']),
                          ],
                        ),
                        leading: Icon(
                          Iconsax.messages5,
                          size: 40,
                          color: Colors.blue,
                        ),
                        trailing: Icon(Iconsax.arrow_right_3),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
