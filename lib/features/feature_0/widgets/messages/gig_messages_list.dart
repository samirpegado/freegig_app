import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/widgets/build_profile_image.dart';
import 'package:freegig_app/common/widgets/error_message.dart';
import 'package:freegig_app/features/chat/chat_page.dart';
import 'package:freegig_app/features/chat/gig_chat_page.dart';
import 'package:freegig_app/features/feature_0/widgets/messages/circle_not_read_gig_messages.dart';
import 'package:freegig_app/features/feature_0/widgets/messages/circle_not_read_messages.dart';
import 'package:freegig_app/services/chat/chat_service.dart';
import 'package:freegig_app/services/chat/gig_chat_service.dart';
import 'package:iconsax/iconsax.dart';

class ListMessages extends StatefulWidget {
  const ListMessages({Key? key}) : super(key: key);

  @override
  State<ListMessages> createState() => _ListMessagesState();
}

class _ListMessagesState extends State<ListMessages> {
  final _gigChatService = GigChatService();
  final _chatService = ChatService();
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            /// Streama os chats em grupo das Gigs
            StreamBuilder(
              stream: _gigChatService.getGigChatRoomsData(),
              builder: (context, gigSnapshot) {
                if (gigSnapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: MediaQuery.sizeOf(context).height * 0.8,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (gigSnapshot.hasError) {
                  return ErrorMessage();
                }
                List<DocumentSnapshot<Map<String, dynamic>>> gigDocuments =
                    gigSnapshot.data?.docs ?? [];

                /// Streama os chats em individuais
                return StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _chatService.getChatRoomsData(),
                  builder: (context, chatSnapshot) {
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (chatSnapshot.hasError) {
                      return ErrorMessage();
                    }

                    List<Map<String, dynamic>> dataList =
                        chatSnapshot.data ?? [];

                    // Ambos os StreamBuilder concluíram o carregamento

                    if (gigDocuments.isEmpty && dataList.isEmpty) {
                      // Se ambas as listas estiverem vazias, exibe o Text
                      return _emptyMessagesText();
                    }

                    return Column(
                      children: [
                        /// Lista os chats em grupo das gigs
                        _listGigGroupChats(gigDocuments),

                        /// Lista os chats individuais
                        _listIndividualChats(dataList)
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyMessagesText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Icon(
                Iconsax.message_question,
                size: 40,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Não há chats disponíveis no momento. Os seus chats futuros serão exibidos aqui.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listIndividualChats(List<Map<String, dynamic>> dataList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> combinedData = dataList[index];

        Map<String, dynamic> chatRoomData = combinedData['chatRoomDoc'];

        Map<String, dynamic> receiverUserData = combinedData['userSnapshot'];

        return ListTile(
          onTap: () {
            navigationFadeTo(
                context: context,
                destination: ChatPage(
                  receiverUid: receiverUserData['uid'],
                  gigSubjectUid: chatRoomData['gigSubjectUid'],
                ));
          },
          title: Text(receiverUserData['publicName']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(chatRoomData['gigDescription']),
              Text(FormatDate().formatDateString(chatRoomData['gigDate']) +
                  ', ' +
                  chatRoomData['gigInitHour']),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleNotReadMessages(
                gigUid: chatRoomData['gigSubjectUid'],
                receiverId: receiverUserData['uid'],
              ),
              Icon(Iconsax.arrow_right_3),
            ],
          ),
          leading: BuildProfileImage(
              profileImageUrl: receiverUserData['profileImageUrl'],
              imageSize: 45),
        );
      },
    );
  }

  Widget _listGigGroupChats(
      List<DocumentSnapshot<Map<String, dynamic>>> gigDocuments) {
    return Column(
      children: gigDocuments.map((document) {
        Map<String, dynamic> data = document.data()!;

        String gigUid = data['gigUid'];

        return ListTile(
          onTap: () {
            navigationFadeTo(
                context: context,
                destination: GigChatPage(gigSubjectUid: gigUid));
          },
          title: Text(data['gigDescription']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(FormatDate().formatDateString(data['gigDate']) +
                  ', ' +
                  data['gigInitHour']),
            ],
          ),
          leading: Icon(
            Iconsax.messages5,
            size: 40,
            color: Colors.blue,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleNotReadGigMessages(
                gigUid: data['gigUid'],
              ),
              Icon(Iconsax.arrow_right_3),
            ],
          ),
        );
      }).toList(),
    );
  }
}
