import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/data/services/user_request.dart';

class ConfirmRequest extends StatefulWidget {
  final Map<String, dynamic> gig;
  const ConfirmRequest({
    super.key,
    required this.gig,
  });

  @override
  State<ConfirmRequest> createState() => _ConfirmRequestState();
}

class _ConfirmRequestState extends State<ConfirmRequest> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Entrar na GIG",
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
              "Para: ${widget.gig['gigCategorys']}",
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
        Center(child: Text('Gostaria de participar desta GIG?')),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Icons.close,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: () {
                  CircularProgressIndicator();
                  UserRequest().userRequest(
                      gigOwnerId: widget.gig['gigOwner'],
                      selectedGigUid: widget.gig['gigUid']);
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Solicitação enviada com sucesso",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Icons.check,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
