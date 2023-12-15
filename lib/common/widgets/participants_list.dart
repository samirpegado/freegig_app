import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/screens/show_profile.dart';
import 'package:freegig_app/common/widgets/build_profile_image.dart';
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
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: GigsDataService().getParticipantsDataStream(widget.gigUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(heightFactor: 2, child: CircularProgressIndicator());
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
                  participant['category'] == 'Desativado'
                      ? null
                      : navigationFadeTo(
                          context: context,
                          destination: SimpleShowProfile(profile: participant));
                },
                leading: BuildProfileImage(
                    profileImageUrl: participant['profileImageUrl'],
                    imageSize: 40),
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
