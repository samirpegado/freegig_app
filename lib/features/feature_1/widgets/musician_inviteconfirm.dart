import 'package:flutter/material.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:freegig_app/services/gigs/gigs_service.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/createnewgigform.dart';
import 'package:freegig_app/services/notification/notifications_service.dart';
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
  late List _categorys = [];
  late List _participants = [];
  late String _gigDate = '';
  late String _gigDescription = '';
  late String _gigCity = '';
  late bool isLoading = false;
  late bool _userProfileStatus = widget.profile['profileComplete'];
  late int _gigDataCount = 0;

  @override
  void initState() {
    super.initState();
    gigsDataList = GigsDataService().getMyActiveGigsStream();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Confirmar convite",
        textAlign: TextAlign.center,
      ),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: gigsDataList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Map<String, dynamic>> data = snapshot.data!;

                    _gigDataCount = data.length;

                    return Column(
                      children: [
                        _gigDataCount != 0
                            ? Text(
                                "Escolha a GIG à qual você deseja enviar o convite para ${widget.profile['publicName']}:",
                                textAlign: TextAlign.center,
                              )
                            : Column(
                                children: [
                                  Text(
                                    "Você ainda não criou nenhuma GIG para convidar este usuário.",
                                    textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                    onPressed: () {
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
                                      'Criar Nova GIG',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 10),
                        Column(
                          children: data.map<Widget>((gig) {
                            bool isSelected = gig['gigUid'] == selectedGigUid;

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedGigUid = gig['gigUid'];
                                      _categorys = gig['gigCategorys'];
                                      _participants = gig['gigParticipants'];
                                      _gigDescription = gig['gigDescription'];
                                      _gigCity = gig['gigLocale'];
                                      _gigDate = gig['gigDate'];
                                    });
                                  },
                                  child: Card(
                                    elevation: 3,
                                    color: isSelected
                                        ? const Color.fromARGB(
                                            255, 188, 213, 233)
                                        : null,
                                    child: ListTile(
                                      title: Text(gig['gigDescription'] ?? ''),
                                      subtitle: Text(
                                        '${gig['gigLocale']}, ${gig['gigDate']}',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
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
                    if (selectedGigUid != '' &&
                        _categorys.contains(widget.profile['category']) &&
                        !_participants.contains(widget.profile['uid']) &&
                        _userProfileStatus == true) {
                      setState(() {
                        isLoading = true;
                      });
                      await NotificationService().sendInvitation(
                        recipientID: widget.profile['uid'],
                        gigCity: _gigCity,
                        gigDate: _gigDate,
                        gigDescription: _gigDescription,
                        gigUid: selectedGigUid,
                      );
                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => _alertInviteWarnings());
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100)),
                    child: isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.check,
                            size: 50,
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            ))
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  Widget _alertInviteWarnings() {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            visible: _categorys.contains(widget.profile['category'])
                ? false
                : _categorys.isEmpty
                    ? false
                    : true,
            child: Text(
                "** A categoria deste músico não corresponde à GIG selecionada."),
          ),
          SizedBox(height: 10),
          Visibility(
            visible:
                !_participants.contains(widget.profile['uid']) ? false : true,
            child:
                Text("** Este músico já está participando da GIG selecionada."),
          ),
          SizedBox(height: 10),
          Visibility(
            visible: selectedGigUid == '' ? true : false,
            child: Text(
              "** Por favor, selecione uma GIG para a qual deseja enviar o convite.",
            ),
          ),
        ],
      ),
      actions: [
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
    );
  }
}
