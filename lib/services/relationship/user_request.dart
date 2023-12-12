import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/services/notification/notifications_service.dart';

class UserRequest extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> removeParticipant({
    required String gigUid,
    required String participantUid,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentReference<Map<String, dynamic>> requestedGigUpdate =
            _firestore.collection('gigs').doc(gigUid);

        DocumentSnapshot<Map<String, dynamic>> gigSnapshot =
            await requestedGigUpdate.get();

        List<String> gigParticipants =
            List<String>.from(gigSnapshot['gigParticipants'] ?? []);

        gigParticipants.remove(participantUid);

        await requestedGigUpdate.update({
          'gigParticipants': gigParticipants,
        });

        //NOTIFICA O PARTICIPANTE QUE ELE FOI REMOVIDO DA GIG
        // cria a instancia da colecao de notificacoes
        DocumentReference notification =
            _firestore.collection('notifications').doc();

        // pega o token do participante removido
        DocumentSnapshot recipientUserSnapshot =
            await _firestore.collection('users').doc(participantUid).get();
        String token = recipientUserSnapshot['token'];

        // Mensagem a ser enviada
        String body = 'Você não está mais associado a esta GIG';

        await notification.set(
          {
            'body': body,
            'title': gigSnapshot['gigDescription'],
            'senderId': user.uid,
            'recipientID': participantUid,
            'notificationUid': notification.id,
            'type': 'confirmation',
          },
        );

        await NotificationService().sendPushMessage(
          token: token,
          body: body,
          title: gigSnapshot['gigDescription'],
        );
      }
    } catch (e) {
      print("Erro ao aceitar a solicitação: $e");
    }
  }
}
