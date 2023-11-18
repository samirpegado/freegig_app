import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRequest {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> userRequest({
    required String gigOwnerId,
    required String selectedGigUid,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentReference newUserRequestRef =
            _firestore.collection('userRequest').doc();

        await newUserRequestRef.set({
          /// definicoes da gig
          'requestUid': newUserRequestRef.id,
          'requesterUid': user.uid,
          'requestStatus': 'Pendente',

          /// formularios da gig
          'gigOwnerId': gigOwnerId,
          'gigUid': selectedGigUid,
        });
      }
    } catch (e) {
      print("Erro ao criar esta gig: $e");
    }
  }

  Future<List<Map<String, dynamic>>> listRequestsByGigAndOwner(
    String gigUid,
  ) async {
    try {
      User? user = _auth.currentUser;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('userRequest')
              .where('gigUid', isEqualTo: gigUid)
              .where('gigOwnerId', isEqualTo: user!.uid)
              .get();

      List<Map<String, dynamic>> requests = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        String requesterUid = document['requesterUid'];

        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(requesterUid)
                .get();

        Map<String, dynamic> userRequestData = document.data();
        Map<String, dynamic> userData = {
          'publicName': userSnapshot['publicName'],
          'profileImageUrl': userSnapshot['profileImageUrl'],
          'city': userSnapshot['city'],
          'category': userSnapshot['category'],
          'description': userSnapshot['description'],
          'lastReleases': userSnapshot['lastReleases'],
          'instagram': userSnapshot['instagram'],
          'youtube': userSnapshot['youtube'],
          'release': userSnapshot['release'],
        };

        requests.add({
          'userRequestData': userRequestData,
          'userData': userData,
        });
      }

      return requests;
    } catch (e) {
      print('Erro ao listar convites: $e');
      return [];
    }
  }

  Future<void> refuseRequest(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('userRequest')
          .doc(documentId)
          .delete();
      print('Documento removido com sucesso!');
    } catch (e) {
      print('Erro ao remover documento: $e');
    }
  }

  Future<void> acceptRequest({
    required String requestUid,
    required String selectedGigUid,
    required String requesterUid,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentReference<Map<String, dynamic>> requestedGigUpdate =
            _firestore.collection('gigs').doc(selectedGigUid);

        DocumentSnapshot<Map<String, dynamic>> gigSnapshot =
            await requestedGigUpdate.get();

        List<String> gigParticipants =
            List<String>.from(gigSnapshot['gigParticipants'] ?? []);

        gigParticipants.add(requesterUid);

        await requestedGigUpdate.update({
          'gigParticipants': gigParticipants,
        });
        await refuseRequest(requestUid);
      }
    } catch (e) {
      print("Erro ao aceitar a solicitação: $e");
    }
  }

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
      }
    } catch (e) {
      print("Erro ao aceitar a solicitação: $e");
    }
  }
}
