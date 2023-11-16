import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/data/services/user_invitation.dart';

class InviteConfirm extends StatefulWidget {
  const InviteConfirm({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final Map<String, dynamic> profile;

  @override
  State<InviteConfirm> createState() => _InviteConfirmState();
}

class _InviteConfirmState extends State<InviteConfirm> {
  late Future<List<Map<String, dynamic>>> gigsDataList;
  String selectedGigUid = '';

  @override
  void initState() {
    super.initState();
    gigsDataList = GigsDataService().getMyActiveGigs();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Confirmar convite",
        textAlign: TextAlign.center,
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Escolha a GIG à qual você deseja enviar o convite para ${widget.profile['publicName']}:",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: gigsDataList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> data = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: data.map<Widget>((gig) {
                        bool isSelected = gig['gigUid'] == selectedGigUid;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGigUid = gig['gigUid'];
                              print(selectedGigUid);
                            });
                          },
                          child: Card(
                            elevation: 3,
                            color: isSelected
                                ? const Color.fromARGB(255, 188, 213, 233)
                                : null,
                            child: ListTile(
                              title: Text(gig['gigDescription'] ?? ''),
                              subtitle: Text(
                                '${gig['gigLocale']}, ${gig['gigDate']}',
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar dados');
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
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
                  if (selectedGigUid != '') {
                    CircularProgressIndicator();
                    UserInvitation().userInvitation(
                        guestUserUid: widget.profile['uid'],
                        selectedGigUid: selectedGigUid);
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: "Convite enviado com sucesso",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.close)),
                                ],
                              ),
                              content: Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Text(
                                  'Por favor, selecione uma GIG',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ));
                  }
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
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
