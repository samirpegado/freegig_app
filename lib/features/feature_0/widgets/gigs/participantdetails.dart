import 'package:flutter/material.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';

class ParticipantDetails extends StatefulWidget {
  final Map<String, dynamic> gig;
  const ParticipantDetails({
    super.key,
    required this.gig,
  });

  @override
  State<ParticipantDetails> createState() => _ParticipantDetailsState();
}

class _ParticipantDetailsState extends State<ParticipantDetails> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Atenção!', style: TextStyle(color: Colors.red)),
                  content: Text('Tem certeza que deseja desistir da GIG?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          GigsDataService()
                              .leaveGig(gigUid: widget.gig['gigUid']);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NavigationMenu(
                                    navPage: 1,
                                  )));
                        },
                        child: Text("Confirmar",
                            style: TextStyle(color: Colors.red))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: Text("Cancelar",
                            style: TextStyle(color: Colors.black)))
                  ],
                ),
              );
            },
            child: Text("Desistir", style: TextStyle(color: Colors.red))),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Voltar", style: TextStyle(color: Colors.black)))
      ],
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
    );
  }
}
