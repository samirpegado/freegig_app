import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freegig_app/main.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    updateUserToken();
    print('Token: $fCMToken');
    initPushNotifications();
  }

  Future<void> updateUserToken() async {
    final User? currentUser = _auth.currentUser;
    final fCMToken = await _firebaseMessaging.getToken();

    if (currentUser != null) {
      final String currentUserId = currentUser.uid;
      final userDocumentReference =
          FirebaseFirestore.instance.collection('users').doc(currentUserId);

      try {
        final userDocumentSnapshot = await userDocumentReference.get();

        if (userDocumentSnapshot.exists) {
          // O documento existe, então podemos atualizar o token
          await userDocumentReference.update({'token': fCMToken});
          print('Token atualizado: $fCMToken');
        } else {
          print('Documento não encontrado para o usuário $currentUserId');
        }
      } catch (e) {
        print('Erro ao verificar o documento: $e');
      }
    } else {
      print('Usuário não autenticado');
    }
  }
}

String fromServerToken = '';

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
  navigatorKey.currentState?.pushNamed('/notification_screen');
}

Future initPushNotifications() async {
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
}
