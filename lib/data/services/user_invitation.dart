import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInvitation {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> userInvitation({
    required String guestUserUid,
    required String selectedGigUid,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentReference newUserInviteRef =
            _firestore.collection('userInvite').doc();

        await newUserInviteRef.set({
          /// definicoes da gig
          'inviteUid': newUserInviteRef.id,
          'inviteOwner': user.uid,
          'inviteStatus': 'Pendente',

          /// formularios da gig
          'guestUserId': guestUserUid,
          'gigUid': selectedGigUid,
        });
      }
    } catch (e) {
      print("Erro ao criar esta gig: $e");
    }
  }

  Future<List<Map<String, dynamic>>> listInvitesByGigAndOwner(
    String gigUid,
  ) async {
    try {
      User? user = _auth.currentUser;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('userInvite')
              .where('gigUid', isEqualTo: gigUid)
              .where('inviteOwner', isEqualTo: user!.uid)
              .get();

      List<Map<String, dynamic>> invites = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        String guestUserId = document['guestUserId'];

        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(guestUserId)
                .get();

        Map<String, dynamic> userInviteData = document.data();
        Map<String, dynamic> userData = {
          'publicName': userSnapshot['publicName'],
          'profileImageUrl': userSnapshot['profileImageUrl'],
          'category': userSnapshot['category'],
        };

        invites.add({
          'userInviteData': userInviteData,
          'userData': userData,
        });
      }

      return invites;
    } catch (e) {
      print('Erro ao listar convites: $e');
      return [];
    }
  }

  Future<void> myInvitationDelete(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('userInvite')
          .doc(documentId)
          .delete();
      print('Documento removido com sucesso!');
    } catch (e) {
      print('Erro ao remover documento: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getReceivedInvitation() async {
    try {
      User? user = _auth.currentUser;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('userInvite')
              .where('guestUserId', isEqualTo: user!.uid)
              .get();

      List<Map<String, dynamic>> receivedInvitation = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        String inviteOwner = document['inviteOwner'];
        String gigUid = document['gigUid'];

        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(inviteOwner)
                .get();

        DocumentSnapshot<Map<String, dynamic>> gigSnapshot =
            await FirebaseFirestore.instance
                .collection('gigs')
                .doc(gigUid)
                .get();

        Map<String, dynamic> gigInviteData = document.data();
        Map<String, dynamic> inviteOwnerData = {
          'publicName': userSnapshot['publicName'],
          'profileImageUrl': userSnapshot['profileImageUrl'],
          'category': userSnapshot['category'],
        };

        Map<String, dynamic> gigData = gigSnapshot.data() ?? {};

        receivedInvitation.add({
          'gigInviteData': gigInviteData,
          'inviteOwnerData': inviteOwnerData,
          'gigData': gigData,
        });
      }

      return receivedInvitation;
    } catch (e) {
      print('Erro ao listar convites: $e');
      return [];
    }
  }

  Future<void> acceptInvitation({
    required String invitationId,
    required String selectedGigUid,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentReference<Map<String, dynamic>> invitedGigUpdate =
            _firestore.collection('gigs').doc(selectedGigUid);

        DocumentSnapshot<Map<String, dynamic>> gigSnapshot =
            await invitedGigUpdate.get();

        List<String> gigParticipants =
            List<String>.from(gigSnapshot['gigParticipants'] ?? []);

        gigParticipants.add(user.uid);

        await invitedGigUpdate.update({
          'gigParticipants': gigParticipants,
        });
        await myInvitationDelete(invitationId);
      }
    } catch (e) {
      print("Erro ao aceitar a solicitação: $e");
    }
  }

  Future<bool> checkGuestInvite(String gigUid, String guestUid) async {
    CollectionReference userRequestCollection =
        FirebaseFirestore.instance.collection('userInvite');

    try {
      QuerySnapshot querySnapshot = await userRequestCollection
          .where('gigUid', isEqualTo: gigUid)
          .where('guestUserId', isEqualTo: guestUid)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar a solicitação do usuário: $e');
      return false;
    }
  }
}
