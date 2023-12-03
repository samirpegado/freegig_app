import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common_widgets/build_profile_image.dart';
import 'package:freegig_app/services/chat/chat_service.dart';
import 'package:iconsax/iconsax.dart';

class MessageTile extends StatefulWidget {
  final String receiverUid;
  final String gigSubjectUid;
  const MessageTile(
      {super.key, required this.receiverUid, required this.gigSubjectUid});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  final _chatService = ChatService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _chatService.getReceiverAndGigData(
          widget.receiverUid, widget.gigSubjectUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Nenhum dado encontrado');
        } else {
          String gigDescription =
              snapshot.data![0]['gigData']['gigDescription'];
          String gigDate = snapshot.data![0]['gigData']['gigDate'];
          String publicName = snapshot.data![0]['receiverData']['publicName'];
          String profileImageUrl =
              snapshot.data![0]['receiverData']['profileImageUrl'];
          String gigHour = snapshot.data![0]['gigData']['gigInitHour'];

          return ListTile(
            title: Text(publicName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(gigDescription),
                Text(FormatDate().formatDateString(gigDate) + ', ' + gigHour),
              ],
            ),
            trailing: Icon(Iconsax.arrow_right_3),
            leading: BuildProfileImage(
                profileImageUrl: profileImageUrl, imageSize: 45),
          );
        }
      },
    );
  }
}
