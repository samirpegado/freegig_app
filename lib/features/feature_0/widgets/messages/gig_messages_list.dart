import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common/widgets/build_profile_image.dart';
import 'package:freegig_app/features/chat/chat_page.dart';
import 'package:freegig_app/features/chat/gig_chat_page.dart';
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
            /// Lista os chats em grupo das gigs
            StreamBuilder(
              stream: _gigChatService.getGigChatRoomsData(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                }

                // Obtenha os documentos do snapshot
                List<DocumentSnapshot<Map<String, dynamic>>> documents =
                    snapshot.data?.docs ?? [];

                // Verifique se há dados
                if (documents.isEmpty) {
                  return Container();
                }

                return Column(
                  children: documents.map((document) {
                    Map<String, dynamic> data = document.data()!;

                    String gigUid = data['gigUid'];

                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                GigChatPage(gigSubjectUid: gigUid)));
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
                      trailing: Icon(Iconsax.arrow_right_3),
                    );
                  }).toList(),
                );
              },
            ),

            /// Lista os chats individuais
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatService.getChatRoomsData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> dataList = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> combinedData = dataList[index];

                      Map<String, dynamic> chatRoomData =
                          combinedData['chatRoomDoc'];

                      Map<String, dynamic> receiverUserData =
                          combinedData['userSnapshot'];

                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatPage(
                                    receiverUid: receiverUserData['uid'],
                                    gigSubjectUid:
                                        chatRoomData['gigSubjectUid'],
                                  )));
                        },
                        title: Text(receiverUserData['publicName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(chatRoomData['gigDescription']),
                            Text(FormatDate()
                                    .formatDateString(chatRoomData['gigDate']) +
                                ', ' +
                                chatRoomData['gigInitHour']),
                          ],
                        ),
                        trailing: Icon(Iconsax.arrow_right_3),
                        leading: BuildProfileImage(
                            profileImageUrl:
                                receiverUserData['profileImageUrl'],
                            imageSize: 45),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
