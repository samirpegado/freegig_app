import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/createnewgigform.dart';
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
  late Stream<List<Map<String, dynamic>>> gigsDataList;
  String selectedGigUid = '';
  late List _categorys = [];
  late List _participants = [];
  late bool _userProfileStatus = widget.profile['profileComplete'];

  @override
  void initState() {
    super.initState();
    gigsDataList = GigsDataService().getMyActiveGigsStream();
  }

  @override
  Widget build(BuildContext context) {
    late int _gigDataCount = 0;
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
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: gigsDataList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> data = snapshot.data!;
                _gigDataCount = data.length;
                return SingleChildScrollView(
                  child: Column(
                    children: data.map<Widget>((gig) {
                      bool isSelected = gig['gigUid'] == selectedGigUid;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGigUid = gig['gigUid'];
                            _categorys = gig['gigCategorys'];
                            _participants = gig['gigParticipants'];
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
                  if (_categorys.contains(widget.profile['category']) &&
                      !_participants.contains(widget.profile['uid']) &&
                      _userProfileStatus == true) {
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
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Atenção!',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Icon(
                                    Iconsax.warning_2,
                                    color: Colors.red,
                                    size: 30,
                                  )
                                ],
                              ),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: _categorys.contains(
                                            widget.profile['category'])
                                        ? false
                                        : _categorys.isEmpty
                                            ? false
                                            : true,
                                    child: Text(
                                        "** A categoria deste músico não corresponde à GIG selecionada."),
                                  ),
                                  SizedBox(height: 10),
                                  Visibility(
                                    visible: !_participants
                                            .contains(widget.profile['uid'])
                                        ? false
                                        : true,
                                    child: Text(
                                        "** Este músico já está participando da GIG selecionada."),
                                  ),
                                  SizedBox(height: 10),
                                  Visibility(
                                    visible:
                                        selectedGigUid == '' ? true : false,
                                    child: Text(
                                      "** Por favor, selecione uma GIG para a qual deseja enviar o convite.",
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Visibility(
                                    visible: _gigDataCount > 0 ? false : true,
                                    child: Text(
                                      "** Antes de enviar o convite, é necessário criar uma GIG.",
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                Visibility(
                                  visible: _gigDataCount > 0 ? false : true,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog.fullscreen(
                                          backgroundColor: backgroundColor,
                                          child: CreateNewGig(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Criar GIG',
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Fechar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ));
                  }
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
