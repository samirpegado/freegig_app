import 'package:flutter/material.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/data/services/user_invitation.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';

class InvitationConfirm extends StatefulWidget {
  final Map<String, dynamic> gig;
  final Map<String, dynamic> inviteData;
  const InvitationConfirm({
    super.key,
    required this.gig,
    required this.inviteData,
  });

  @override
  State<InvitationConfirm> createState() => _InvitationConfirmState();
}

class _InvitationConfirmState extends State<InvitationConfirm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Confirmar convite",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Text(
              "${widget.gig['gigDetails']}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Para: ${widget.gig['gigCategorys'].join(', ')}",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Cachê: ${widget.gig['gigCache']}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Cidade: ${widget.gig['gigLocale']}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Data: ${widget.gig['gigDate']}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Horário: ${widget.gig['gigInitHour']} - ${widget.gig['gigFinalHour']}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Participantes: ",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            FutureBuilder<List<Map<String, dynamic>>>(
              future:
                  GigsDataService().getParticipantsData(widget.gig['gigUid']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                    'Erro ao carregar participantes: ${snapshot.error}',
                    style: TextStyle(fontSize: 15),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(
                    'Nenhum participante encontrado.',
                    style: TextStyle(fontSize: 15),
                  );
                } else {
                  List<Map<String, dynamic>> participantsData = snapshot.data!;
                  return Column(
                    children: participantsData.map((participant) {
                      return ListTile(
                        leading: ClipOval(
                          child: Image.network(
                            participant['profileImageUrl'],
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        title: Text(
                          participant['publicName'],
                          style: TextStyle(fontSize: 15),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              participant['category'],
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        Center(child: Text('Gostaria de se juntar a esta GIG?')),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    await UserInvitation()
                        .myInvitationDelete(widget.inviteData['inviteUid']);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NavigationMenu(navPage: 1)));
                  },
                  child: Text(
                    'Recusar',
                    style: TextStyle(color: Colors.red),
                  )),
              SizedBox(width: 20),
              TextButton(
                  onPressed: () async {
                    await UserInvitation().acceptInvitation(
                        invitationId: widget.inviteData['inviteUid'],
                        selectedGigUid: widget.gig['gigUid']);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NavigationMenu(navPage: 1)));
                  },
                  child: Text('Aceitar'))
            ],
          ),
        )
      ],
    );
  }
}
