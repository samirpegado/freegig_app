import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/widgets/profile_complete_confirm.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/my_gig_cards.dart';
import 'package:freegig_app/services/current_user/current_user_service.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/features/feature_0/screens/gigs/gigs_archived.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/createnewgigform.dart';
import 'package:iconsax/iconsax.dart';

class GIGs extends StatefulWidget {
  const GIGs({super.key});

  @override
  State<GIGs> createState() => _GIGsState();
}

class _GIGsState extends State<GIGs> {
  late bool isLoading = false;
  Future<bool> checkProfileStatus() async {
    try {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> userData =
          await UserDataService().getCurrentUserData();

      setState(() {
        isLoading = false;
      });

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
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : IconButton(
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
            ///Listar as gigs criadas e participando
            Expanded(
                child: SingleChildScrollView(
              child: MyGigCards(),
            )),

            ///Botao para as gigs arquivadas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    navigationFadeTo(
                        context: context, destination: ArchivedGigs());
                  },
                  child: Text(
                    'Gigs arquivadas  ',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                Icon(Iconsax.arrow_right_3, color: Colors.black54),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
