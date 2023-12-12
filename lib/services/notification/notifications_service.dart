import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common/functions/toast.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NotificationService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // CRIA CONVITE E ENVIA NOTIFICACAO
  Future<void> sendInvitation({
    required String recipientID,
    required String gigCity,
    required String gigDate,
    required String gigDescription,
    required String gigUid,
  }) async {
    // Obter o ID do usuário logado
    final String currentUserId = _auth.currentUser!.uid;

    // Obter o campo 'publicName' do usuário logado na coleção 'users'
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(currentUserId).get();
    String userPublicName = userSnapshot['publicName'];

    // Obter o 'token' do usuário destinatário'
    DocumentSnapshot recipientUserSnapshot =
        await _firestore.collection('users').doc(recipientID).get();
    String token = recipientUserSnapshot['token'];

    // Formata a data
    String dateFormated = FormatDate().formatDateString(gigDate);

    // Mensagem de aviso para exibir
    String body =
        '$userPublicName te convidou para uma GIG em $gigCity, dia $dateFormated';

    // Controi o id da notificacao
    List<String> ids = [
      currentUserId.substring(0, 10),
      recipientID.substring(0, 10),
      gigUid.substring(0, 10),
    ];
    ids.sort();
    String notificationID = 'invite_' + ids.join('_');

    // Adicionar a mensagem à base de dados
    DocumentReference notification =
        _firestore.collection('notifications').doc(notificationID);

    // Verificar se a notificação já existe
    DocumentSnapshot notificationSnapshot = await notification.get();

    if (!notificationSnapshot.exists) {
      await notification.set(
        {
          'body': body,
          'title': gigDescription,
          'senderId': currentUserId,
          'recipientID': recipientID,
          'gigUid': gigUid,
          'notificationUid': notificationID,
          'type': 'invitation',
        },
      );

      await sendPushMessage(
        token: token,
        body: body,
        title: gigDescription,
      );

      showToast(message: 'Convite enviado com sucesso');
    } else {
      showToast(message: 'Convite já enviado');
    }
  }

  // CRIA SOLICITACAO E ENVIA NOTIFICACAO
  Future<void> sendRequest({
    required String recipientID,
    required String gigCity,
    required String gigDate,
    required String gigDescription,
    required String gigUid,
  }) async {
    // Obter o ID do usuário logado
    final String currentUserId = _auth.currentUser!.uid;

    // Obter o campo 'publicName' do usuário logado na coleção 'users'
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(currentUserId).get();
    String userPublicName = userSnapshot['publicName'];

    // Obter o 'token' do usuário destinatário'
    DocumentSnapshot recipientUserSnapshot =
        await _firestore.collection('users').doc(recipientID).get();
    String token = recipientUserSnapshot['token'];

    // Formata a data
    String dateFormated = FormatDate().formatDateString(gigDate);

    // Mensagem de aviso para exibir
    String body =
        '$userPublicName deseja se juntar a sua GIG em $gigCity, dia $dateFormated';

    // Controi o id da notificacao
    List<String> ids = [
      currentUserId.substring(0, 10),
      recipientID.substring(0, 10),
      gigUid.substring(0, 10),
    ];
    ids.sort();
    String notificationID = 'request_' + ids.join('_');

    // Adicionar a mensagem à base de dados
    DocumentReference notification =
        _firestore.collection('notifications').doc(notificationID);

    // Verificar se a notificação já existe
    DocumentSnapshot notificationSnapshot = await notification.get();

    if (!notificationSnapshot.exists) {
      await notification.set(
        {
          'body': body,
          'title': gigDescription,
          'senderId': currentUserId,
          'recipientID': recipientID,
          'gigUid': gigUid,
          'notificationUid': notificationID,
          'type': 'request',
        },
      );

      await sendPushMessage(
        token: token,
        body: body,
        title: gigDescription,
      );

      showToast(message: 'Solicitação enviada com sucesso');
    } else {
      showToast(message: 'Solicitação já enviada');
    }
  }

  Future<void> newMessageNotification({
    required String recipientID,
  }) async {
    // Obter o ID do usuário logado
    final String currentUserId = _auth.currentUser!.uid;

    // Obter o 'token' do usuário destinatário'
    DocumentSnapshot recipientUserSnapshot =
        await _firestore.collection('users').doc(recipientID).get();
    String token = recipientUserSnapshot['token'];

    String notificationID = 'inbox_' + recipientID;

    // Adicionar a mensagem à base de dados
    DocumentReference notification =
        _firestore.collection('notifications').doc(notificationID);

    // Verificar se a notificação já existe
    DocumentSnapshot notificationSnapshot = await notification.get();

    String body = 'Você tem novas mensagens não lidas';

    if (!notificationSnapshot.exists) {
      await notification.set(
        {
          'body': body,
          'title': 'Mensagem',
          'senderId': currentUserId,
          'recipientID': recipientID,
          'notificationUid': notificationID,
          'type': 'inbox',
        },
      );

      sendPushMessage(
        token: token,
        body: body,
        title: 'Mensagem',
      );
    }
  }

  //RECEBE DADOS DAS NOTIFICACOES
  Stream<QuerySnapshot<Map<String, dynamic>>> getNotificationsData() {
    // Obter o ID do usuário logado
    final String currentUserId = _auth.currentUser!.uid;

    // Cria a consulta
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('notifications')
        .where('recipientID', isEqualTo: currentUserId);

    // Retorna o stream da consulta
    return query.snapshots();
  }

  Future<void> removeMessageNotification() async {
    // Obter o ID do usuário logado
    final String currentUserId = _auth.currentUser!.uid;
    String notificationID = 'inbox_' + currentUserId;
    await _firestore.collection('notifications').doc(notificationID).delete();
  }

  Future<void> removeNotification({required String notificationID}) async {
    await _firestore.collection('notifications').doc(notificationID).delete();
  }

  Future<void> sendPushMessage(
      {required String token,
      required String body,
      required String title}) async {
    String cloudMessagingKey = dotenv.env['CLOUD_MENSSAGING_KEY'].toString();
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$cloudMessagingKey'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'andoid_channel_id': 'dbfood'
            },
            'to': token,
          }));
    } catch (e) {
      print('error to send push notification: $e');
    }
  }

  Future<void> acceptInvite({
    required String gigUid,
    required String notificationID,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentReference<Map<String, dynamic>> invitedGigUpdate =
            _firestore.collection('gigs').doc(gigUid);

        DocumentSnapshot<Map<String, dynamic>> gigSnapshot =
            await invitedGigUpdate.get();

        List<String> gigParticipants =
            List<String>.from(gigSnapshot['gigParticipants'] ?? []);

        //Adiciona o usuario a GIG a qual foi convidado
        gigParticipants.add(user.uid);

        //Pega o nome do usuário logado
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();
        String userPublicName = userSnapshot['publicName'];

        await invitedGigUpdate.update({
          'gigParticipants': gigParticipants,
        });
        //Notifica o dono da GIG que o convite foi aceito
        DocumentReference notification =
            _firestore.collection('notifications').doc();
        // pega o token do gigOwner
        DocumentSnapshot recipientUserSnapshot = await _firestore
            .collection('users')
            .doc(gigSnapshot['gigOwner'])
            .get();
        String token = recipientUserSnapshot['token'];

        // Mensagem a ser enviada
        String body =
            '$userPublicName aceitou o seu convite para participar desta GIG';

        await notification.set(
          {
            'body': body,
            'title': gigSnapshot['gigDescription'],
            'senderId': user.uid,
            'recipientID': gigSnapshot['gigOwner'],
            'notificationUid': notification.id,
            'type': 'confirmation',
          },
        );

        await sendPushMessage(
          token: token,
          body: body,
          title: gigSnapshot['gigDescription'],
        );

        //remove essa notificacao
        await removeNotification(notificationID: notificationID);
      }
    } catch (e) {
      print("Erro ao aceitar a solicitação: $e");
    }
  }

  Future<void> confirmRequest({
    required String gigUid,
    required String notificationID,
    required String senderId,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentReference<Map<String, dynamic>> invitedGigUpdate =
            _firestore.collection('gigs').doc(gigUid);

        DocumentSnapshot<Map<String, dynamic>> gigSnapshot =
            await invitedGigUpdate.get();

        List<String> gigParticipants =
            List<String>.from(gigSnapshot['gigParticipants'] ?? []);

        gigParticipants.add(senderId);

        await invitedGigUpdate.update({
          'gigParticipants': gigParticipants,
        });

        //Notifica o participante que o dono da gig aceitou a solicitacao
        DocumentReference notification =
            _firestore.collection('notifications').doc();
        // pega o token do gigOwner
        DocumentSnapshot recipientUserSnapshot =
            await _firestore.collection('users').doc(senderId).get();
        String token = recipientUserSnapshot['token'];

        // Mensagem a ser enviada
        String body = 'Sua solicitação para participar desta GIG foi aceita';

        await notification.set(
          {
            'body': body,
            'title': gigSnapshot['gigDescription'],
            'senderId': user.uid,
            'recipientID': senderId,
            'notificationUid': notification.id,
            'type': 'confirmation',
          },
        );

        await sendPushMessage(
          token: token,
          body: body,
          title: gigSnapshot['gigDescription'],
        );

        await removeNotification(notificationID: notificationID);
      }
    } catch (e) {
      print("Erro ao aceitar a solicitação: $e");
    }
  }
}
