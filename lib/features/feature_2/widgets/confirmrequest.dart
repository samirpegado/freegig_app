import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freegig_app/common_widgets/formatdate.dart';
import 'package:freegig_app/common_widgets/show_profile.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/data/services/user_data_service.dart';
import 'package:freegig_app/data/services/user_request.dart';
import 'package:iconsax/iconsax.dart';

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
  late bool _gigStatus = widget.gig['gigCompleted'];
  late List _categorys = widget.gig['gigCategorys'];
  late List _participants = widget.gig['gigParticipants'];
  late String userUid = '';
  late String userCategory = '';
  late bool _isAlreadyRequested = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic> userData = await UserDataService().getUserData();

      setState(() {
        userUid = userData['uid'];
        userCategory = userData['category'];
        isAlreadyRequested();
      });
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  Future<void> isAlreadyRequested() async {
    bool alreadyRequested =
        await UserRequest().checkUserRequest(widget.gig['gigUid'], userUid);

    setState(() {
      _isAlreadyRequested = alreadyRequested;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "${widget.gig['gigDescription']}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green),
              ),
            ),
            Center(
              child: Text(
                FormatDate().formatDateString(widget.gig['gigDate']),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(
                  _gigStatus ? Iconsax.lock : Iconsax.unlock,
                  size: 20,
                  color: _gigStatus ? Colors.green : Colors.black,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _gigStatus ? 'Fechada' : 'Aberta',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Iconsax.device_message,
                  size: 20,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.gig['gigDetails'],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Iconsax.music,
                  size: 20,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${widget.gig['gigCategorys'].join(', ')}",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
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
                    widget.gig['gigLocale'],
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
                            Visibility(
                              visible:
                                  participant['uid'] == widget.gig['gigOwner']
                                      ? true
                                      : false,
                              child: TextButton(
                                  onPressed: () {},
                                  child: Text('Enviar mensagem')),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      SimpleShowProfile(profile: participant)));
                            },
                            icon: Icon(Iconsax.arrow_right_3)),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: _gigStatus
          ? []
          : [
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
                        if (_categorys.contains(userCategory) &&
                            !_participants.contains(userUid) &&
                            _isAlreadyRequested == false) {
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
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Atenção'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Fechar',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))
                                    ],
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Visibility(
                                          visible:
                                              _categorys.contains(userCategory)
                                                  ? false
                                                  : true,
                                          child: Text(
                                              "Esta GIG não está disponível para músicos na sua categoria."),
                                        ),
                                        Visibility(
                                          visible:
                                              !_participants.contains(userUid)
                                                  ? false
                                                  : true,
                                          child: Text(
                                              "Você já está participando desta GIG."),
                                        ),
                                        Visibility(
                                          visible: _isAlreadyRequested
                                              ? true
                                              : false,
                                          child:
                                              Text("Solicitação já enviada."),
                                        ),
                                      ],
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
    );
  }
}
