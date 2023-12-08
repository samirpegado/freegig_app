/*import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/widgets/profile_complete_confirm.dart';
import 'package:freegig_app/services/current_user/current_user_service.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/features/feature_0/screens/gigs/gigs_archived.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/created_gigs_card.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/createnewgigform.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/participating_gigs_card.dart';
import 'package:iconsax/iconsax.dart';

class GIGs extends StatefulWidget {
  const GIGs({super.key});

  @override
  State<GIGs> createState() => _GIGsState();
}

class _GIGsState extends State<GIGs> {
  Future<bool> checkProfileStatus() async {
    try {
      Map<String, dynamic> userData =
          await UserDataService().getCurrentUserData();

      // Retorna o valor de _profileStatus como um Future<bool>
      return userData['profileComplete'] ?? true;
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigationFadeTo(context: context, destination: NavigationMenu());

        return false;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () async {
                  if (await checkProfileStatus() == true) {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog.fullscreen(
                        backgroundColor: backgroundColor,
                        child: CreateNewGig(),
                      ),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => ProfileCompleteConfirm());
                  }
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
              'Minhas GIGs',
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
                  navigationFadeTo(
                      context: context, destination: ArchivedGigs());
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
*/