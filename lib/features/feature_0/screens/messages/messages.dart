import 'package:flutter/material.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:freegig_app/features/feature_0/widgets/messages/gig_messages_list.dart';
import 'package:freegig_app/services/notification/notifications_service.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Mensagens',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.0,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ListMessages(),
      ),
    );
  }

  @override
  void dispose() {
    NotificationService().removeMessageNotification();
    super.dispose();
  }
}
