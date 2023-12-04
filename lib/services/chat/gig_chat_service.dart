import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GigChatService extends ChangeNotifier {
  // pega as instancias do auth e firestore
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //ENVIA MENSAGEM
  Future<void> sendGigMessage(String message, String gigUid) async {
    // pega informacao do usuario logado
    final String currentUserId = _auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    //pegar a lista de participantes da GIG
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await _firestore.collection('users').doc(currentUserId).get();

    String senderPublicName = userSnapshot['publicName'];

    //adiciona a mensagem a base de dados
    await _firestore
        .collection('gigs')
        .doc(gigUid)
        .collection('group_messages')
        .add({
      'message': message,
      'timestamp': timestamp,
      'senderId': currentUserId,
      'senderPublicName': senderPublicName,
    });
    //adiciona a mensagem a base de dados
    await _firestore.collection('gigs').doc(gigUid).update({
      'gigChat': true,
    });
  }

  //RECEBE MENSAGEM
  Stream<QuerySnapshot> getGigMessages(String gigUid) {
    return _firestore
        .collection('gigs')
        .doc(gigUid)
        .collection('group_messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  //RECEBE DADOS DOS CHATS
  Stream<QuerySnapshot<Map<String, dynamic>>> getGigChatRoomsData() {
    // Obtém o ID do usuário logado
    String userId = _auth.currentUser!.uid;

    // Cria a consulta
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('gigs')
        .where('gigArchived', isEqualTo: false)
        .where('gigParticipants', arrayContains: userId)
        .where('gigChat', isEqualTo: true);

    // Retorna o stream da consulta
    return query.snapshots();
  }

  /// pegar os dados da gig

  Future<List<Map<String, dynamic>>> getGigSubjectData(
      String gigSubjectUid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> gigSnapshot =
          await FirebaseFirestore.instance
              .collection('gigs')
              .doc(gigSubjectUid)
              .get();

      Map<String, dynamic> gigData = gigSnapshot.data() ?? {};
      List<Map<String, dynamic>> gigDataList = [];

      gigDataList.add({
        'gigData': gigData,
      });

      return gigDataList;
    } catch (e) {
      print('Erro ao listar: $e');
      return [];
    }
  }
}
