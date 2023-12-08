import 'package:freegig_app/services/api/firebase_api.dart';

class NotificationService {
  notificationFormat(String userDeviceToken, String receiverID,
      String featureType, String senderNae) {
    Map<String, String> headerNotification = {
      'Content-Type': 'aplication/json',
      'Authorization': fromServerToken,
    };
    Map bodyNotification = {
      'body': 'Mensagem da notificacao aqui',
      'title': 'Novo Titulo da notificacao'
    };
    Map dataMap = {};
  }
}
