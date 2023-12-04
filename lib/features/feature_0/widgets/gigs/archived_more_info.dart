import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/services/gigs/gigs_service.dart';
import 'package:iconsax/iconsax.dart';

class ArchivedMoreInfo extends StatefulWidget {
  final Map<String, dynamic> gig;
  const ArchivedMoreInfo({
    super.key,
    required this.gig,
  });

  @override
  State<ArchivedMoreInfo> createState() => _ArchivedMoreInfoState();
}

class _ArchivedMoreInfoState extends State<ArchivedMoreInfo> {
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
                  Iconsax.archive,
                  size: 20,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Arquivada',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
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
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.gig['gigCache'],
                    style: TextStyle(
                      color: Colors.black,
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
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    FormatDate().formatDateString(widget.gig['gigDate']),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
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
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${widget.gig['gigInitHour']}h - ${widget.gig['gigFinalHour']}h",
                    style: TextStyle(
                      color: Colors.black,
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
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.gig['gigAdress'],
                    style: TextStyle(
                      color: Colors.black,
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
