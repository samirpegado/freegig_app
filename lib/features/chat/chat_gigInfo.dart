import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common/widgets/gig_more_info.dart';
import 'package:freegig_app/services/chat/chat_service.dart';
import 'package:iconsax/iconsax.dart';

class ChatGigInfo extends StatefulWidget {
  final String gigSubjectUid;

  const ChatGigInfo({super.key, required this.gigSubjectUid});

  @override
  State<ChatGigInfo> createState() => _ChatGigInfoState();
}

class _ChatGigInfoState extends State<ChatGigInfo> {
  final _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _chatService.getGigSubjectData(widget.gigSubjectUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Nenhum dado encontrado');
        } else {
          Map<String, dynamic> gigData = snapshot.data![0]['gigData'] ?? [];

          return Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              top: 5.0,
            ),
            child: ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => MoreInfo(gig: gigData));
              },
              leading: Container(
                  height: double.infinity, child: Icon(Iconsax.info_circle)),
              trailing: Icon(Iconsax.arrow_right_3),
              title: Text(gigData['gigDescription']),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(FormatDate().formatDateString(gigData['gigDate']) +
                      ', ' +
                      gigData['gigInitHour']),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
