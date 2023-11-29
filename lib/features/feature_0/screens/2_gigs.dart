import 'package:flutter/material.dart';
import 'package:freegig_app/data/services/user_invitation.dart';
import 'package:freegig_app/data/services/user_rate.dart';
import 'package:freegig_app/data/services/user_request.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/archived_gigs.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/created_gigs_card.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/createnewgigform.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/notifications.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/participating_gigs_card.dart';
import 'package:iconsax/iconsax.dart';

class GIGs extends StatefulWidget {
  const GIGs({super.key});

  @override
  State<GIGs> createState() => _GIGsState();
}

class _GIGsState extends State<GIGs> {
  int notification = 0;
  late Future<List<Map<String, dynamic>>> requestForMyGigs;
  late Future<List<Map<String, dynamic>>> invitationToOtherGigs;
  late Future<List<Map<String, dynamic>>> getRateNotifications;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    requestForMyGigs = UserRequest().listRequestsByGigOwner();
    invitationToOtherGigs = UserInvitation().getReceivedInvitation();
    getRateNotifications = UserRateService().getRateNotifications();

    List<Map<String, dynamic>> requests =
        await UserRequest().listRequestsByGigOwner();
    List<Map<String, dynamic>> invitations =
        await UserInvitation().getReceivedInvitation();
    List<Map<String, dynamic>> rateNotifications =
        await UserRateService().getRateNotifications();

    setState(() {
      notification =
          requests.length + invitations.length + rateNotifications.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NavigationMenu()));
        return false;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Stack(
                children: [
                  Center(
                    child: IconButton(
                      onPressed: () {
                        notification != 0
                            ? showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: GigsNotification(),
                                ),
                              )
                            : showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Fechar',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ))
                                      ],
                                      content: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Text(
                                          'Nenhuma notificação recebida',
                                        ),
                                      ),
                                    ));
                      },
                      icon: Icon(Iconsax.notification),
                    ),
                  ),
                  Visibility(
                    visible: notification != 0 ? true : false,
                    child: Positioned(
                      bottom: 12,
                      left: 30,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            notification < 10 ? '$notification' : '9+',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 7.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog.fullscreen(
                      backgroundColor: backgroundColor,
                      child: CreateNewGig(),
                    ),
                  );
                },
                icon: Icon(
                  Iconsax.add_circle5,
                  color: Colors.blue,
                  size: 35,
                ),
              ),
              SizedBox(width: 5)
            ],
            title: Text(
              'GIGs',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19.0,
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.note_add,
                          size: 26,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Criadas",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.blue),
                        )
                      ],
                    ),
                  ),
                  Tab(
                    height: 70,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.share,
                            size: 26,
                            color: Colors.green,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Participando",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          )
                        ]),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [MyGigsCard()],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [ParticipantGigsCard()],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ArchivedGigs()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Gigs arquivadas  ',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Icon(Iconsax.arrow_right_3, color: Colors.black54),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
