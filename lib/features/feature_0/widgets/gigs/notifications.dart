import 'package:flutter/material.dart';
import 'package:freegig_app/data/services/user_invitation.dart';
import 'package:freegig_app/data/services/user_request.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/created_giginfo.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/invitationconfirm.dart';

class GigsNotification extends StatefulWidget {
  const GigsNotification({super.key});

  @override
  State<GigsNotification> createState() => _GigsNotificationState();
}

class _GigsNotificationState extends State<GigsNotification> {
  late Future<List<Map<String, dynamic>>> requestForMyGigs;
  late Future<List<Map<String, dynamic>>> invitationToOtherGigs;
  bool _isLoading = true;

  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      requestForMyGigs = UserRequest().listRequestsByGigOwner();
      invitationToOtherGigs = UserInvitation().getReceivedInvitation();
      await Future.wait([requestForMyGigs, invitationToOtherGigs]);
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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: SingleChildScrollView(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      FutureBuilder(
                          future: invitationToOtherGigs,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                  'Erro ao carregar convites: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Container();
                            } else {
                              List<Map<String, dynamic>> invites =
                                  snapshot.data!;
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: invites.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> gigInviteData =
                                        invites[index]['gigInviteData'];
                                    Map<String, dynamic> inviteOwnerData =
                                        invites[index]['inviteOwnerData'];
                                    Map<String, dynamic> gigData =
                                        invites[index]['gigData'];
                                    return ListTile(
                                      title: Text(gigData['gigDescription']),
                                      subtitle: Column(children: [
                                        Text(
                                            '${inviteOwnerData['publicName']} te convidou para uma GIG em ${gigData['gigLocale']}, no dia ${gigData['gigDate']}')
                                      ]),
                                      trailing: TextButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  InvitationConfirm(
                                                    gig: gigData,
                                                    inviteData: gigInviteData,
                                                  ));
                                        },
                                        child: Text('Ver'),
                                      ),
                                    );
                                  });
                            }
                          }),
                      FutureBuilder(
                        future: requestForMyGigs,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                                'Erro ao carregar convites: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Container();
                          } else {
                            List<Map<String, dynamic>> requests =
                                snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: requests.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> allUserData =
                                    requests[index]['allUserData'];
                                Map<String, dynamic> gigData =
                                    requests[index]['gigData'];

                                return ListTile(
                                  trailing: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreatedGigInfo(
                                                      gig: gigData)));
                                    },
                                    child: Text('Ver'),
                                  ),
                                  title: Text(gigData['gigDescription']),
                                  subtitle: Text(
                                      '${allUserData['publicName']} deseja se juntar a sua GIG em ${gigData['gigLocale']}'),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Fechar',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
