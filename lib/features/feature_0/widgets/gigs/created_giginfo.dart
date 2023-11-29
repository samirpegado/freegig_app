import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common_widgets/show_profile.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/data/services/user_rate.dart';
import 'package:freegig_app/data/services/user_request.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/created_invitations.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/created_requests.dart';
import 'package:iconsax/iconsax.dart';

class CreatedGigInfo extends StatefulWidget {
  final Map<String, dynamic> gig;

  const CreatedGigInfo({super.key, required this.gig});

  @override
  State<CreatedGigInfo> createState() => _CreatedGigInfoState();
}

class _CreatedGigInfoState extends State<CreatedGigInfo> {
  late Future<List<Map<String, dynamic>>> participantsData;
  bool? _gigStatus;
  @override
  void initState() {
    super.initState();
    participantsData =
        GigsDataService().getParticipantsData(widget.gig['gigUid']);
    setState(() {
      _gigStatus = widget.gig['gigCompleted'];
    });
  }

  void updateGigStatus() {
    if (_gigStatus == false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirmar status'),
          content: Text('Gostaria de marcar esta GIG como fechada?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Não',
                  style: TextStyle(color: Colors.black),
                )),
            TextButton(
                onPressed: () {
                  GigsDataService().updateGigStatus(true, widget.gig['gigUid']);
                  Navigator.of(context).pop();

                  setState(() {
                    _gigStatus = true;
                  });
                },
                child: Text(
                  'Sim',
                ))
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirmar status'),
          content: Text('Gostaria de marcar esta GIG como aberta?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Não',
                  style: TextStyle(color: Colors.black),
                )),
            TextButton(
                onPressed: () {
                  GigsDataService()
                      .updateGigStatus(false, widget.gig['gigUid']);
                  Navigator.of(context).pop();

                  setState(() {
                    _gigStatus = false;
                  });
                },
                child: Text(
                  'Sim',
                ))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NavigationMenu(
                  navPage: 1,
                )));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                updateGigStatus();
              },
              icon: _gigStatus == false
                  ? Icon(Iconsax.unlock)
                  : Icon(
                      Iconsax.lock,
                      color: Colors.green,
                    ),
            ),
          ],
          title: Text(
            'Sua GIG',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 19.0,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        backgroundColor: backgroundColor,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Confirmar exclusão',
                            style: TextStyle(color: Colors.red),
                          ),
                          Icon(
                            Iconsax.danger,
                            color: Colors.red,
                            size: 30,
                          )
                        ],
                      ),
                      content: Text('Tem certeza que deseja excluir esta GIG?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Fechar',
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton(
                            onPressed: () async {
                              await GigsDataService()
                                  .myGigDelete(widget.gig['gigUid']);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      NavigationMenu(navPage: 1)));
                            },
                            child: Text(
                              'Excluir',
                              style: TextStyle(color: Colors.red),
                            ))
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Iconsax.trash,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Arquivar GIG',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Icon(
                            Iconsax.archive,
                            color: Colors.grey,
                            size: 30,
                          )
                        ],
                      ),
                      content: Text('Gostaria de arquivar esta GIG?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Fechar',
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton(
                            onPressed: () async {
                              UserRateService()
                                  .createRateNotificationsAndArchive(
                                      widget.gig['gigUid']);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      NavigationMenu(navPage: 1)));
                            },
                            child: Text(
                              'Arquivar',
                            ))
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(100)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Iconsax.archive,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  "${widget.gig['gigDescription']}",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue),
                ),
                Text(
                  FormatDate().formatDateString(widget.gig['gigDate']),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Icon(
                      Iconsax.device_message,
                      size: 25,
                      color: Colors.blue,
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
                      color: Colors.blue,
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
                      color: Colors.blue,
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
                      color: Colors.blue,
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
                      color: Colors.blue,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        widget.gig['gigAdress'],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                InvitationsSent(
                  gigUid: widget.gig['gigUid'],
                ),
                RequestsSent(
                  gigUid: widget.gig['gigUid'],
                ),
                Text(
                  "Participantes: ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue),
                ),
                SizedBox(height: 6),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: participantsData,
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
                      List<Map<String, dynamic>> participantsData =
                          snapshot.data!;

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
                            trailing: participant['uid'] !=
                                    widget.gig['gigOwner']
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Remover participante',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                  Icon(
                                                    Iconsax.user_remove,
                                                    color: Colors.blue,
                                                    size: 30,
                                                  )
                                                ],
                                              ),
                                              content: Text(
                                                  'Deseja remover este participante da sua GIG?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'Fechar',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                                TextButton(
                                                    onPressed: () async {
                                                      await UserRequest()
                                                          .removeParticipant(
                                                              gigUid:
                                                                  widget.gig[
                                                                      'gigUid'],
                                                              participantUid:
                                                                  participant[
                                                                      'uid']);
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  NavigationMenu(
                                                                      navPage:
                                                                          1)));
                                                    },
                                                    child: Text(
                                                      'Remover',
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ))
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SimpleShowProfile(
                                                            profile:
                                                                participant)));
                                          },
                                          icon: Icon(Iconsax.arrow_right_3))
                                    ],
                                  )
                                : null,
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
        ),
      ),
    );
  }
}
