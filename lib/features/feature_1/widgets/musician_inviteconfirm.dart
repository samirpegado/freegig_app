import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/data/services/user_invitation.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/createnewgigform.dart';
import 'package:iconsax/iconsax.dart';

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
  late Stream<List<Map<String, dynamic>>> gigsDataList;
  String selectedGigUid = '';
  late bool _isAlreadyInvited = false;
  late List _categorys = [];
  late List _participants = [];
  late bool _userProfileStatus = widget.profile['profileComplete'];

  @override
  void initState() {
    super.initState();
    gigsDataList = GigsDataService().getMyActiveGigsStream();
  }

  Future<void> isAlreadyInvited() async {
    bool alreadyInvited = await UserInvitation()
        .checkGuestInvite(selectedGigUid, widget.profile['uid']);

    setState(() {
      _isAlreadyInvited = alreadyInvited;
    });
  }

  @override
  Widget build(BuildContext context) {
    late int _gigDataCount = 0;
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
                onTap: () async {
                  await isAlreadyInvited();

                  if (selectedGigUid != '' &&
                      _isAlreadyInvited == false &&
                      _categorys.contains(widget.profile['category']) &&
                      !_participants.contains(widget.profile['uid']) &&
                      _userProfileStatus == true) {
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
                                    visible: _isAlreadyInvited ? true : false,
                                    child: Text("** Convite já enviado."),
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
