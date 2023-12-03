import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/build_profile_image.dart';
import 'package:freegig_app/services/chat/chat_service.dart';

class ChatPageAppBar extends StatefulWidget {
  final String receiverUid;

  const ChatPageAppBar({super.key, required this.receiverUid});

  @override
  State<ChatPageAppBar> createState() => _ChatPageAppBarState();
}

class _ChatPageAppBarState extends State<ChatPageAppBar> {
  final _chatService = ChatService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _chatService.getReceiverData(widget.receiverUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Nenhum dado encontrado');
        } else {
          String publicName = snapshot.data![0]['receiverData']['publicName'];
          String profileImageUrl =
              snapshot.data![0]['receiverData']['profileImageUrl'];

          return Row(
            children: [
              BuildProfileImage(
                  profileImageUrl: profileImageUrl, imageSize: 40),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                publicName,
                overflow: TextOverflow.ellipsis,
              )),
            ],
          );
        }
      },
    );
  }
}
