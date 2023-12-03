import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common_widgets/build_profile_image.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:iconsax/iconsax.dart';

class MoreInfo extends StatefulWidget {
  final Map<String, dynamic> gig;
  const MoreInfo({
    super.key,
    required this.gig,
  });

  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  late bool gigStatus = widget.gig['gigCompleted'];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Fechar", style: TextStyle(color: Colors.black)))
      ],
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  gigStatus ? Iconsax.lock : Iconsax.unlock,
                  size: 20,
                  color: gigStatus ? Colors.green : Colors.black,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    gigStatus ? 'Fechada' : 'Aberta',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Iconsax.money,
                  size: 20,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.gig['gigCache'],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Iconsax.calendar,
                  size: 20,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    FormatDate().formatDateString(widget.gig['gigDate']),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Iconsax.clock,
                  size: 20,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${widget.gig['gigInitHour']}h - ${widget.gig['gigFinalHour']}h",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Iconsax.location,
                  size: 20,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.gig['gigAdress'],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
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
                        leading: BuildProfileImage(
                            profileImageUrl: participant['profileImageUrl'],
                            imageSize: 50),
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
