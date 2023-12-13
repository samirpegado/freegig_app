import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/screens/user_rate.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/invitate_confirmation.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/request_confirmation.dart';
import 'package:freegig_app/services/notification/notifications_service.dart';

class GigsNotification extends StatefulWidget {
  const GigsNotification({super.key});

  @override
  State<GigsNotification> createState() => _GigsNotificationState();
}

class _GigsNotificationState extends State<GigsNotification> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigationFadeTo(
            context: context, destination: NavigationMenu(navPage: 0));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Notificações'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder(
                  stream: NotificationService().getNotificationsData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    }
                    List<DocumentSnapshot<Map<String, dynamic>>>
                        notificationsDocument = snapshot.data?.docs ?? [];

                    return Column(
                      children: notificationsDocument.map((document) {
                        Map<String, dynamic> data = document.data()!;

                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                            title: Text(data['title']),
                            subtitle: Text(
                              data['body'],
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                            trailing: TextButton(
                              child: Text('Ver'),
                              onPressed: () async {
                                if (data['type'] == 'inbox') {
                                  navigationFadeTo(
                                      context: context,
                                      destination: NavigationMenu(
                                        navPage: 2,
                                      ));
                                } else if (data['type'] == 'invitation') {
                                  showDialog(
                                      context: context,
                                      builder: (context) => InvitationConfirm(
                                            gigUid: data['gigUid'],
                                            notificationID:
                                                data['notificationUid'],
                                          ));
                                } else if (data['type'] == 'request') {
                                  showDialog(
                                      context: context,
                                      builder: (context) => RequestConfirmation(
                                            gigUid: data['gigUid'],
                                            notificationID:
                                                data['notificationUid'],
                                            senderID: data['senderId'],
                                          ));
                                } else if (data['type'] == 'rate') {
                                  navigationFadeTo(
                                      context: context,
                                      destination: UserRating(
                                        gigUid: data['gigUid'],
                                        notificationID: data['notificationUid'],
                                        currentUserID: data['recipientID'],
                                      ));
                                } else if (data['type'] == 'confirmation') {
                                  navigationFadeTo(
                                      context: context,
                                      destination: NavigationMenu(navPage: 1));
                                  await NotificationService()
                                      .removeNotification(
                                          notificationID:
                                              data['notificationUid']);
                                }
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
