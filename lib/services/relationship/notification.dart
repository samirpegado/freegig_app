import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // CRIA A NOTIFICAÇAO
  Future<void> sendNotification(
      String recipientID, String message, String type, String gigUid) async {
    // pega informacao do usuario logado
    final String currentUserId = _auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    //adiciona a mensagem a base de dados
    DocumentReference notification =
        _firestore.collection('notifications').doc();

    await notification.set(
      {
        'message': message,
        'timestamp': timestamp,
        'senderId': currentUserId,
        'recipientID': recipientID,
        'gigUid': gigUid,
        'notificationUid': notification.id,
        'type': type,
      },
    );
  }
}
