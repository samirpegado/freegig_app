import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'token': fCMToken});

      print('Token atualizado: $fCMToken');
    } else {
      print('Usuário não autenticado');
    }
  }
}

String fromServerToken = '';

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
}

Future initPushNotifications() async {
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
}
