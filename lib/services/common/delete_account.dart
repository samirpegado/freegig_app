import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/dialog_delete_account.dart';
import 'package:freegig_app/services/auth/auth_service.dart';

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
    User? user = _auth.currentUser!;

    try {
      // 1. ARQUIVA TODAS AS GIGS ATIVAS DO USUARIO
      await FirebaseFirestore.instance
          .collection('gigs')
          .where('gigOwner', isEqualTo: user.uid)
          .where('gigArchived', isEqualTo: false)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.exists) {
            doc.reference.update({'gigArchived': true});
          } else {
            print(
                'O usuario nao tem nenhuma gig para arquivar: ${doc.reference.id}');
          }
        });
      });
    } catch (e) {
      print('ERRO AO ARQUIVAR AS GIGS DO USUARIO A SER DELETADO: $e');
    }

    try {
      //2. REMOVE O USUARIO DE TODAS AS GIGS ATIVAS
      await FirebaseFirestore.instance
          .collection('gigs')
          .where('gigParticipants', arrayContains: user.uid)
          .where('gigArchived', isEqualTo: false)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.exists) {
            doc.reference.update({
              'gigParticipants': FieldValue.arrayRemove([user.uid]),
            });
          } else {
            print('O usuario nao participa de nenhuma GIG ativa');
          }
        });
      });
    } catch (e) {
      print('ERRO AO REMOVER O USUARIO DAS GIGS EM QUE PARTICIPA: $e');
    }

    try {
      // 3. Excluir as notificacoes enviadas e recebidas por esse usuario
      await FirebaseFirestore.instance
          .collection('notifications')
          .where('senderId', isEqualTo: user.uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      await FirebaseFirestore.instance
          .collection('notifications')
          .where('recipientID', isEqualTo: user.uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    } catch (e) {
      print('ERRO AO REMOVER AS NOTIFICACOES ENVIADAS E RECEBIDAS: $e');
    }

    try {
      // 4. REMOVE OS CHATS DIRETOS ATIVOS DO USUARIO
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .where('participants', arrayContains: user.uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    } catch (e) {
      print('ERRO AO REMOVER OS CHATS DIRETOS COM ESSE USUARIO: $e');
    }

    // 5. REMOVE O USUARIO O AUTHENTICATION
    try {
      // Remover autenticação do Google (se o usuário fez login pelo Google)
      if (user.providerData
          .any((userInfo) => userInfo.providerId == 'google.com')) {
        await user.unlink('google.com');
      }
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      print('ERRO AO REMOVER O USUARIO DO AUTHENTICATION: $e');
    }

    //6. MARCA O USUARIO COM DESATIVADO
    try {
      Timestamp currentDate = Timestamp.now();
      //MUDA O DOCUMENTO DA COLECAO USERS PARA USUARIO DESATIVADO
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'publicName': 'Usuário desativado',
        'profileImageUrl':
            'https://firebasestorage.googleapis.com/v0/b/freegig-fac8e.appspot.com/o/desativated-user.png?alt=media&token=f30971ea-4e5b-458d-bffd-29b90bd9b052',
        'category': 'Desativado',
        'deletedDate': currentDate,
      });
    } catch (e) {
      print(
          'ERRO AO MUDAR O DOCUMENTO DA COLECAO USERS PARA USUARIO DESATIVADO: $e');
    }

    // 7. FAZ O LOGOUT E VOLTA PRO AUTHGATE
    try {
      await FirebaseAuthService().logOut(context);
    } catch (e) {
      print('ERRO AO FAZER LOGOUT E VOLTAR PRA O AUTHGATE: $e');
    }

    showDialog(context: context, builder: (context) => DeletedAccountDetails());
  }
}
