import 'package:flutter/material.dart';
import 'package:freegig_app/common/screens/show_profile.dart';
import 'package:freegig_app/services/gigs/gigs_service.dart';
import 'package:iconsax/iconsax.dart';

class ParticipantList extends StatefulWidget {
  final String gigUid;
  const ParticipantList({super.key, required this.gigUid});

  @override
  State<ParticipantList> createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: GigsDataService().getParticipantsData(widget.gigUid),
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
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SimpleShowProfile(profile: participant)));
                },
                leading: ClipOval(
                  child: Image.network(
                    participant['profileImageUrl'],
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ),
                trailing: Icon(Iconsax.arrow_right_3),
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
    );
  }
}
