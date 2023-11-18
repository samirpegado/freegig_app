import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/data/services/user_request.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/invitations.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/requests.dart';
import 'package:iconsax/iconsax.dart';

class GigInfo extends StatefulWidget {
  final Map<String, dynamic> gig;

  const GigInfo({super.key, required this.gig});

  @override
  State<GigInfo> createState() => _GigInfoState();
}

class _GigInfoState extends State<GigInfo> {
  late Future<List<Map<String, dynamic>>> participantsData;
  @override
  void initState() {
    super.initState();
    participantsData =
        GigsDataService().getParticipantsData(widget.gig['gigUid']);
  }

  void reloadParticipants() {
    setState(() {
      participantsData =
          GigsDataService().getParticipantsData(widget.gig['gigUid']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gig['gigDescription'],
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.0,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: backgroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Confirmar exclusão',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Iconsax.danger,
                          color: Colors.red,
                          size: 30,
                        )
                      ],
                    ),
                    content: Text('Tem certeza que deseja excluir essa GIG?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Fechar')),
                      TextButton(
                          onPressed: () {
                            GigsDataService().myGigDelete(widget.gig['gigUid']);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    NavigationMenu(navPage: 1)));
                          },
                          child: Text('Excluir'))
                    ],
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InvitationsSent(
                gigUid: widget.gig['gigUid'],
              ),
              RequestsSent(
                gigUid: widget.gig['gigUid'],
              ),
              SizedBox(height: 10),
              Text(
                "${widget.gig['gigDetails']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Para: ${widget.gig['gigCategorys'].join(', ')}",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Cachê: ${widget.gig['gigCache']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6),
              Text(
                widget.gig['gigAdress'],
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Data: ${widget.gig['gigDate']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Horário: ${widget.gig['gigInitHour']} - ${widget.gig['gigFinalHour']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Participantes: ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: participantsData,
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
                    List<Map<String, dynamic>> participantsData =
                        snapshot.data!;

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
                          trailing: participant['uid'] != widget.gig['gigOwner']
                              ? IconButton(
                                  onPressed: () {
                                    UserRequest().removeParticipant(
                                        gigUid: widget.gig['gigUid'],
                                        participantUid: participant['uid']);
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.delete),
                                )
                              : null,
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
      ),
    );
  }
}
