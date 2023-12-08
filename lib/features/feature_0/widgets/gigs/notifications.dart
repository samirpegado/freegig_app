import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/feature_0/screens/gigs/gigs_created.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/invitationconfirm.dart';
import 'package:freegig_app/common/screens/user_rate.dart';
import 'package:freegig_app/services/relationship/user_invitation.dart';
import 'package:freegig_app/services/relationship/user_rate.dart';
import 'package:freegig_app/services/relationship/user_request.dart';

class GigsNotification extends StatefulWidget {
  const GigsNotification({super.key});

  @override
  State<GigsNotification> createState() => _GigsNotificationState();
}

class _GigsNotificationState extends State<GigsNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildInvitationsSection(),
            _buildRequestsSection(),
            _buildRateNotificationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInvitationsSection() {
    return FutureBuilder(
      future: UserInvitation().getReceivedInvitation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar convites: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container();
        } else {
          List<Map<String, dynamic>> invites = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: invites.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> gigInviteData =
                  invites[index]['gigInviteData'];
              Map<String, dynamic> inviteOwnerData =
                  invites[index]['inviteOwnerData'];
              Map<String, dynamic> gigData = invites[index]['gigData'];
              return ListTile(
                title: Text(gigData['gigDescription']),
                subtitle: Column(children: [
                  Text(
                    '${inviteOwnerData['publicName']} te convidou para uma GIG em ${gigData['gigLocale']}, no dia ${gigData['gigDate']}',
                  ),
                ]),
                trailing: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => InvitationConfirm(
                        gig: gigData,
                        inviteData: gigInviteData,
                      ),
                    );
                  },
                  child: Text('Ver'),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildRequestsSection() {
    return FutureBuilder(
      future: UserRequest().listRequestsByGigOwner(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar convites: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container();
        } else {
          List<Map<String, dynamic>> requests = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> allUserData = requests[index]['allUserData'];
              Map<String, dynamic> gigData = requests[index]['gigData'];

              return ListTile(
                trailing: TextButton(
                  onPressed: () {
                    navigationFadeTo(
                        context: context,
                        destination: CreatedGigInfo(gig: gigData));
                  },
                  child: Text('Ver'),
                ),
                title: Text(gigData['gigDescription']),
                subtitle: Text(
                  '${allUserData['publicName']} deseja se juntar a sua GIG em ${gigData['gigLocale']}',
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildRateNotificationsSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: UserRateService().getRateNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar notificações: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container();
        } else {
          List<Map<String, dynamic>> rateNotifications = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: rateNotifications.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> notification = rateNotifications[index];
              return ListTile(
                title: Text(notification['gigDescription']),
                subtitle: Text(
                  'Compartilhe suas avaliações e feedbacks sobre todos os participantes envolvidos nesta GIG.',
                ),
                trailing: TextButton(
                  onPressed: () {
                    navigationFadeTo(
                        context: context,
                        destination: UserRating(docData: notification));
                  },
                  child: Text('Ver'),
                ),
              );
            },
          );
        }
      },
    );
  }
}
