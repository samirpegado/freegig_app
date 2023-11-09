import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/widgets/messages/messages_card.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  MessageCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
