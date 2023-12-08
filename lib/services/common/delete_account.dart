import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/authentication/screens/login.dart';

class DeleteUserService extends ChangeNotifier {
  Future<void> deleteUserAndRelatedData(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // 1. Excluir documentos na coleção 'gigs' com campo 'gigOwner' igual ao ID do usuário
        await FirebaseFirestore.instance
            .collection('gigs')
            .where('gigOwner', isEqualTo: user.uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        // 2. Atualizar documentos na coleção 'gigs' com campo 'gigParticipants' contendo o ID do usuário
        await FirebaseFirestore.instance
            .collection('gigs')
            .where('gigParticipants', arrayContains: user.uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              'gigParticipants': FieldValue.arrayRemove([user.uid]),
            });
          });
        });

        // 3. Excluir documentos na coleção 'rateNotification' com campo 'participantUid' igual ao ID do usuário
        await FirebaseFirestore.instance
            .collection('rateNotification')
            .where('participantUid', isEqualTo: user.uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        // 4. Excluir documentos na coleção 'rating' com campo 'ratedParticipantUid' ou 'rater' igual ao ID do usuário
        await FirebaseFirestore.instance
            .collection('rating')
            .where('ratedParticipantUid', isEqualTo: user.uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        await FirebaseFirestore.instance
            .collection('rating')
            .where('rater', isEqualTo: user.uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        // 5. Excluir documentos na coleção 'userInvite' com campo 'guestUserId' ou 'inviteOwner' igual ao ID do usuário
        await FirebaseFirestore.instance
            .collection('userInvite')
            .where('guestUserId', isEqualTo: user.uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        await FirebaseFirestore.instance
            .collection('userInvite')
            .where('inviteOwner', isEqualTo: user.uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        // 6. Excluir documentos na coleção 'userRequest' com campo 'gigOwnerId' ou 'requesterUid' igual ao ID do usuário
        await FirebaseFirestore.instance
            .collection('userRequest')
            .where('gigOwnerId', isEqualTo: user.uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        await FirebaseFirestore.instance
            .collection('userRequest')
            .where('requesterUid', isEqualTo: user.uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        //Excluir o próprio usuário
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        await deleteFirebaseAuthUser();
        navigationFadeTo(context: context, destination: LoginScreen());
      }
    } catch (e) {}
  }

  Future<void> deleteFirebaseAuthUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await user.delete();
      } else {
        // Usuário não autenticado
        print('Usuário não autenticado');
      }
    } catch (e) {
      // Lidar com erros
      print('Erro ao excluir usuário: $e');
    }
  }
}
