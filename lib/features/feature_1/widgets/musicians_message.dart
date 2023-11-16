import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:iconsax/iconsax.dart';

class MessageToMusician extends StatefulWidget {
  const MessageToMusician({
    super.key,
    required this.profile,
  });

  final Map<String, dynamic> profile;

  @override
  State<MessageToMusician> createState() => _MessageToMusicianState();
}

class _MessageToMusicianState extends State<MessageToMusician> {
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
        "Enviar mensagem",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Selecione a GIG sobre a qual gostaria de conversar:',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
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
          SizedBox(height: 15),
          TextField(
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Mensagem",
              hintText: 'Escreva aqui a sua mensagem...',
              prefixIcon: Icon(Iconsax.device_message),
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Iconsax.forbidden_2,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Mensagem enviada",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Iconsax.send_1,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 15),
            ],
          ),
        )
      ],
    );
  }
}
