import 'package:flutter/material.dart';
import 'package:freegig_app/services/chat/gig_chat_service.dart';

class CircleNotReadGigMessages extends StatefulWidget {
  final String gigUid;

  const CircleNotReadGigMessages({Key? key, required this.gigUid})
      : super(key: key);

  @override
  State<CircleNotReadGigMessages> createState() =>
      _CircleNotReadGigMessagesState();
}

class _CircleNotReadGigMessagesState extends State<CircleNotReadGigMessages> {
  final _gigChatService = GigChatService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, DateTime?>>(
      stream: _gigChatService.getTimestampsStream(widget.gigUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); // ou qualquer indicador de carregamento
        } else if (snapshot.hasError) {
          return Container();
        } else if (!snapshot.hasData) {
          return Container(); // Sem dados disponíveis ainda, você decide o que mostrar aqui
        } else {
          DateTime? userLastSeen = snapshot.data!['userLastSeen'];
          DateTime? lastTimestamp = snapshot.data!['lastTimestamp'];

          if (lastTimestamp != null && userLastSeen != null) {
            if (lastTimestamp.isAfter(userLastSeen)) {
              return Icon(
                Icons.circle,
                color: Colors.blue,
                size: 15,
              );
            }
          }
          return Container(); // Se não atender às condições, retorna um Container vazio
        }
      },
    );
  }
}
