import 'package:flutter/material.dart';
import 'package:freegig_app/services/chat/chat_service.dart';

class CircleNotReadMessages extends StatefulWidget {
  final String gigUid;
  final String receiverId;

  const CircleNotReadMessages(
      {Key? key, required this.gigUid, required this.receiverId})
      : super(key: key);

  @override
  State<CircleNotReadMessages> createState() => _CircleNotReadMessagesState();
}

class _CircleNotReadMessagesState extends State<CircleNotReadMessages> {
  final _gigChatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, DateTime?>>(
      stream:
          _gigChatService.getTimestampsStream(widget.gigUid, widget.receiverId),
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
                color: Colors.amber,
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
