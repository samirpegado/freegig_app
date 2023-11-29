import 'package:flutter/material.dart';
import 'package:freegig_app/data/services/user_invitation.dart';
import 'package:freegig_app/data/services/user_rate.dart';
import 'package:freegig_app/data/services/user_request.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/created_giginfo.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/invitationconfirm.dart';
import 'package:freegig_app/features/feature_3/screens/user_rate.dart';

class GigsNotification extends StatefulWidget {
  const GigsNotification({super.key});

  @override
  State<GigsNotification> createState() => _GigsNotificationState();
}

class _GigsNotificationState extends State<GigsNotification> {
  late Future<List<Map<String, dynamic>>> requestForMyGigs;
  late Future<List<Map<String, dynamic>>> invitationToOtherGigs;
  late Future<List<Map<String, dynamic>>> getRateNotifications;
  bool _isLoading = true;

  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      requestForMyGigs = UserRequest().listRequestsByGigOwner();
      invitationToOtherGigs = UserInvitation().getReceivedInvitation();
      getRateNotifications = UserRateService().getRateNotifications();
      await Future.wait(
          [requestForMyGigs, invitationToOtherGigs, getRateNotifications]);
    } catch (error) {
      print('Erro ao carregar dados: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Notificações'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
      future: invitationToOtherGigs,
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
      future: requestForMyGigs,
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreatedGigInfo(gig: gigData),
                      ),
                    );
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
      future: getRateNotifications,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar notificações: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Nenhuma notificação encontrada.');
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserRating(
                          docData: notification,
                        ),
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
}
