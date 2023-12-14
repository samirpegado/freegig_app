import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:freegig_app/common/screens/show_profile.dart';
import 'package:freegig_app/common/widgets/build_profile_image.dart';
import 'package:freegig_app/features/chat/chat_page.dart';
import 'package:freegig_app/services/current_user/current_user_service.dart';
import 'package:freegig_app/services/gigs/gigs_service.dart';
import 'package:freegig_app/services/notification/notifications_service.dart';
import 'package:iconsax/iconsax.dart';

class ConfirmRequestPage extends StatefulWidget {
  final Map<String, dynamic> gig;

  const ConfirmRequestPage({super.key, required this.gig});

  @override
  State<ConfirmRequestPage> createState() => _ConfirmRequestPageState();
}

class _ConfirmRequestPageState extends State<ConfirmRequestPage> {
  late bool _gigStatus = widget.gig['gigCompleted'];
  late List _categorys = widget.gig['gigCategorys'];
  late List _participants = widget.gig['gigParticipants'];
  late String userUid = '';
  late String userCategory = '';
  late String userProfileName = '';
  late bool userProfileStatus = false;

  late bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic> userData =
          await UserDataService().getCurrentUserData();

      setState(() {
        userUid = userData['uid'];
        userCategory = userData['category'];
        userProfileStatus = userData['profileComplete'];
      });
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.gig['gigDescription']}",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.green),
              ),
              Text(
                FormatDate().formatDateString(widget.gig['gigDate']),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Icon(
                    _gigStatus ? Iconsax.lock : Iconsax.unlock,
                    size: 25,
                    color: _gigStatus ? Colors.green : Colors.black,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      _gigStatus ? 'Fechada' : 'Aberta',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(
                    Iconsax.device_message,
                    size: 25,
                    color: Colors.green,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      widget.gig['gigDetails'],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(
                    Iconsax.music,
                    size: 25,
                    color: Colors.green,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "${widget.gig['gigCategorys'].join(', ')}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(
                    Iconsax.money,
                    size: 25,
                    color: Colors.green,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      widget.gig['gigCache'],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(
                    Iconsax.clock,
                    size: 25,
                    color: Colors.green,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "${widget.gig['gigInitHour']}h - ${widget.gig['gigFinalHour']}h",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(
                    Iconsax.location,
                    size: 25,
                    color: Colors.green,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      widget.gig['gigLocale'],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "Participantes: ",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green),
              ),
              SizedBox(height: 6),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: GigsDataService()
                    .getParticipantsDataStream(widget.gig['gigUid']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
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
                    List<Map<String, dynamic>> participantsData =
                        snapshot.data!;
                    return Column(
                      children: participantsData.map((participant) {
                        return ListTile(
                          leading: BuildProfileImage(
                              profileImageUrl: participant['profileImageUrl'],
                              imageSize: 40),
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
                                visible: participant['uid'] ==
                                    widget.gig['gigOwner'],
                                child: TextButton(
                                  onPressed: () {
                                    navigationFadeTo(
                                      context: context,
                                      destination: ChatPage(
                                        receiverUid: widget.gig['gigOwner'],
                                        gigSubjectUid: widget.gig['gigUid'],
                                      ),
                                    );
                                  },
                                  child: Text('Enviar mensagem'),
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              navigationFadeTo(
                                context: context,
                                destination:
                                    SimpleShowProfile(profile: participant),
                              );
                            },
                            icon: Icon(Iconsax.arrow_right_3),
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
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _gigStatus
              ? Container()
              : Center(child: Text('Gostaria de participar desta GIG?')),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: _gigStatus
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.cancel,
                          size: 55,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () async {
                          if (_categorys.contains(userCategory) &&
                              !_participants.contains(userUid) &&
                              userProfileStatus == true) {
                            setState(() {
                              isLoading = true;
                            });
                            await NotificationService().sendRequest(
                              recipientID: widget.gig['gigOwner'],
                              gigCity: widget.gig['gigLocale'],
                              gigDate: widget.gig['gigDate'],
                              gigDescription: widget.gig['gigDescription'],
                              gigUid: widget.gig['gigUid'],
                            );
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => _requestAlertWarnings());
                          }
                        },
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.check_circle,
                                size: 55,
                                color: Colors.green,
                              ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _requestAlertWarnings() {
    return AlertDialog(
      title: Text('Atenção'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Fechar',
              style: TextStyle(color: Colors.black),
            ))
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: _categorys.contains(userCategory) ? false : true,
            child: Text(
                "** Esta GIG não está disponível para músicos na sua categoria."),
          ),
          SizedBox(height: 10),
          Visibility(
            visible: !_participants.contains(userUid) ? false : true,
            child: Text("** Você já está participando desta GIG."),
          ),
          SizedBox(height: 10),
          Visibility(
            visible: userProfileStatus ? false : true,
            child: Text(
                "** Para participar de uma GIG, por favor, complete o seu perfil. O seu perfil ainda não está completo."),
          ),
        ],
      ),
    );
  }
}
