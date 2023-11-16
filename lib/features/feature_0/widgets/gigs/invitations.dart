import 'package:flutter/material.dart';
import 'package:freegig_app/data/services/user_invitation.dart';

class InvitationsSent extends StatefulWidget {
  final String gigUid;

  const InvitationsSent({super.key, required this.gigUid});

  @override
  State<InvitationsSent> createState() => _InvitationsSentState();
}

class _InvitationsSentState extends State<InvitationsSent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: UserInvitation().listInvitesByGigAndOwner(widget.gigUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Erro ao carregar convites: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return ExpansionTile(title: Text('Nenhum convite enviado'));
          } else {
            List<Map<String, dynamic>> invites = snapshot.data!;
            return ExpansionTile(
              title: Text('Convites enviados (${invites.length})'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: invites.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> inviteData =
                        invites[index]['userInviteData'];
                    Map<String, dynamic> userData = invites[index]['userData'];

                    return ListTile(
                      leading: ClipOval(
                        child: Image.network(
                          userData['profileImageUrl'],
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          await UserInvitation()
                              .myInvitationDelete(inviteData['inviteUid']);
                          setState(() {});
                        },
                        icon: Icon(Icons.delete),
                      ),
                      title: Text(userData['publicName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userData['category']),
                          Text(
                            inviteData['inviteStatus'],
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
