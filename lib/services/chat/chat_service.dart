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
    participants.sort();
    String gigDescription = gigSnapshot['gigDescription'];
    String gigDate = gigSnapshot['gigDate'];
    String gigInitHour = gigSnapshot['gigInitHour'];

    await _firestore.collection('chat_rooms').doc(chatRoomId).set({
      'participants': participants, // Participantes do Chat
      'gigSubjectUid': gigUid,
      'gigDescription': gigDescription,
      'gigDate': gigDate,
      'gigInitHour': gigInitHour,
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
  Stream<List<Map<String, dynamic>>> getChatRoomsData() async* {
    // Obtém o ID do usuário logado
    String userId = _auth.currentUser!.uid;

    // Obtém os documentos da coleção 'chat_rooms'
    QuerySnapshot<Map<String, dynamic>> chatRoomsSnapshot =
        await FirebaseFirestore.instance
            .collection('chat_rooms')
            .where('participants', arrayContains: userId)
            .get();

    // Lista para armazenar os dados combinados de chatRoomDoc e userSnapshot
    List<Map<String, dynamic>> combinedDataList = [];

    // Itera sobre os documentos
    for (QueryDocumentSnapshot<Map<String, dynamic>> chatRoomDoc
        in chatRoomsSnapshot.docs) {
      // Obtém o valor de gigSubjectUid
      String gigSubjectUid = chatRoomDoc['gigSubjectUid'];

      //Pega a lista dos participantes do chat e decide quem vai receber a mensagem
      List<dynamic> participants = chatRoomDoc['participants'];
      String receiverUid =
          participants.firstWhere((id) => id != userId, orElse: () => '');

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(receiverUid)
              .get();

      // Verifica a coleção 'gigs' para o documento com o mesmo valor de gigSubjectUid
      DocumentSnapshot<Map<String, dynamic>> gigDoc = await FirebaseFirestore
          .instance
          .collection('gigs')
          .doc(gigSubjectUid)
          .get();

      // Verifica se gigArchived é false
      if (gigDoc.exists && gigDoc['gigArchived'] == false) {
        // Adiciona os dados combinados à lista
        combinedDataList.add({
          'chatRoomDoc': chatRoomDoc.data(),
          'userSnapshot': userSnapshot.data(),
        });
      }
      // Se gigArchived for true, não faz nada e continua para o próximo documento
    }

    // Retorna a lista completa após a iteração
    yield combinedDataList;
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

  Future<void> deleteChatRoom(String gigSubjectUid) async {
    // Cria a referência para a coleção 'chat_rooms' com base no gigSubjectUid
    CollectionReference<Map<String, dynamic>> chatRoomsRef =
        FirebaseFirestore.instance.collection('chat_rooms');

    // Consulta para obter o documento com o gigSubjectUid específico
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await chatRoomsRef
        .where('gigSubjectUid', isEqualTo: gigSubjectUid)
        .get();

    // Itera sobre os documentos encontrados (deveria ser no máximo um)
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      // Exclui a subcoleção 'messages' do documento
      await documentSnapshot.reference
          .collection('messages')
          .get()
          .then((messagesSnapshot) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> messageSnapshot
            in messagesSnapshot.docs) {
          // Exclui cada documento da subcoleção 'messages'
          messageSnapshot.reference.delete();
        }
      });

      // Exclui o documento principal da coleção 'chat_rooms'
      await documentSnapshot.reference.delete();
    }
  }
}
