import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  // pega as instancias do auth e firestore
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //ENVIA MENSAGEM
  Future<void> sendMessage(
      String receiverId, String message, String gigUid) async {
    // pega informacao do usuario logado
    final String currentUserId = _auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    // cria uma nova mensagem

    //constroi uma sala de chat com os ids do usuario e do receptor
    List<String> ids = [
      currentUserId.substring(0, 10),
      receiverId.substring(0, 10),
      gigUid.substring(0, 10),
    ];
    ids.sort();
    String chatRoomId = ids.join('_');

    //adiciona a mensagem a base de dados
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'message': message,
      'timestamp': timestamp,
      'senderId': currentUserId,
    });

    DocumentSnapshot<Map<String, dynamic>> gigSnapshot =
        await _firestore.collection('gigs').doc(gigUid).get();

    List<String> participants = [currentUserId, receiverId];
    String gigDescription = gigSnapshot['gigDescription'];
    String gigDate = gigSnapshot['gigDate'];
    String gigInitHour = gigSnapshot['gigInitHour'];
    bool gigArchived = gigSnapshot['gigArchived'];

    await _firestore.collection('chat_rooms').doc(chatRoomId).set({
      'participants': participants, // Participantes do Chat
      'gigSubjectUid': gigUid,
      'gigDescription': gigDescription,
      'gigDate': gigDate,
      'gigInitHour': gigInitHour,
      'gigArchived': gigArchived,
    });
  }

  //RECEBE MENSAGEM
  Stream<QuerySnapshot> getMessages(
      String userId, String otherUserID, String gigUid) {
    List<String> ids = [
      userId.substring(0, 10),
      otherUserID.substring(0, 10),
      gigUid.substring(0, 10),
    ];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  //RECEBE DADOS DOS CHATS
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRoomsData() {
    // Obtém o ID do usuário logado
    String userId = _auth.currentUser!.uid;

    // Cria a consulta
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('chat_rooms')
        //.where('receiverId', isEqualTo: userId)
        .where('participants', arrayContains: userId);

    // Retorna o stream da consulta
    return query.snapshots();
  }

  Future<List<Map<String, dynamic>>> getReceiverAndGigData(
      String receiverUid, String gigSubjectUid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(receiverUid)
              .get();

      DocumentSnapshot<Map<String, dynamic>> gigSnapshot =
          await FirebaseFirestore.instance
              .collection('gigs')
              .doc(gigSubjectUid)
              .get();

      Map<String, dynamic> gigData = gigSnapshot.data() ?? {};
      Map<String, dynamic> receiverData = userSnapshot.data() ?? {};
      List<Map<String, dynamic>> gigAndReceiverData = [];

      gigAndReceiverData.add({
        'receiverData': receiverData,
        'gigData': gigData,
      });

      return gigAndReceiverData;
    } catch (e) {
      print('Erro ao listar convites: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getReceiverData(String receiverUid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(receiverUid)
              .get();

      Map<String, dynamic> receiverData = userSnapshot.data() ?? {};
      List<Map<String, dynamic>> ReceiverDataList = [];

      ReceiverDataList.add({
        'receiverData': receiverData,
      });

      return ReceiverDataList;
    } catch (e) {
      print('Erro ao listar convites: $e');
      return [];
    }
  }

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
      print('Erro ao listar convites: $e');
      return [];
    }
  }
}
