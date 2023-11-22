import 'package:flutter/material.dart';
import 'package:freegig_app/data/services/user_invitation.dart';
import 'package:freegig_app/data/services/user_request.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/list_my_gigs.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/createnewgigform.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/notifications.dart';
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

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    requestForMyGigs = UserRequest().listRequestsByGigOwner();
    invitationToOtherGigs = UserInvitation().getReceivedInvitation();

    List<Map<String, dynamic>> requests =
        await UserRequest().listRequestsByGigOwner();
    List<Map<String, dynamic>> invitations =
        await UserInvitation().getReceivedInvitation();

    setState(() {
      notification = requests.length + invitations.length;
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
                                            style:
                                                TextStyle(color: Colors.black),
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
                Iconsax.add_circle,
                color: Colors.blue,
              ),
            ),
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
        body: ListMyGigs(),
      ),
    );
  }
}
