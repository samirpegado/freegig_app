import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/chat/chat_page.dart';
import 'package:freegig_app/features/feature_0/widgets/messages/message_tile.dart';
import 'package:freegig_app/services/chat/chat_service.dart';

class ListMessages extends StatefulWidget {
  const ListMessages({Key? key}) : super(key: key);

  @override
  State<ListMessages> createState() => _ListMessagesState();
}

class _ListMessagesState extends State<ListMessages> {
  final _chatService = ChatService();
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.getChatRoomsData(),
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

              List<dynamic> participants = data['participants'];
              String receiverUid = participants
                  .firstWhere((id) => id != userUid, orElse: () => '');
              String gigSubjectUid = data['gigSubjectUid'];

              return ListTile(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                receiverUid: receiverUid,
                                gigSubjectUid: gigSubjectUid)));
                      },
                      child: MessageTile(
                          receiverUid: receiverUid,
                          gigSubjectUid: gigSubjectUid),
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
