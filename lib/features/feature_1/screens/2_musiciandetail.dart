import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/build_profile_image.dart';
import 'package:freegig_app/common_widgets/profile_complete_confirm.dart';
import 'package:freegig_app/services/current_user/current_user_service.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/rate_builder.dart';
import 'package:freegig_app/features/feature_1/widgets/musician_inviteconfirm.dart';
import 'package:iconsax/iconsax.dart';

class ProfileDetailsPage extends StatefulWidget {
  final Map<String, dynamic> profile;
  ProfileDetailsPage({required this.profile});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  late bool _profileStatus = true;

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
        _profileStatus = userData['profileComplete'];
      });
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            if (_profileStatus == true) {
              showDialog(
                  context: context,
                  builder: (context) => InviteConfirm(profile: widget.profile));
            } else {
              showDialog(
                  context: context,
                  builder: (context) => ProfileCompleteConfirm());
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              "Convidar músico",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                SizedBox(height: 20),

                /// Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.profile['publicName'],
                            style: TextStyle(
                              height: 1,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.profile['category'],
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              Icon(
                                Iconsax.location5,
                                size: 18,
                              ),
                              Text(
                                ' ' + widget.profile['city'],
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Iconsax.instagram5,
                                size: 18,
                              ),
                              Text(
                                ' ' + widget.profile['instagram'],
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                          Text(
                            widget.profile['description'],
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    BuildProfileImage(
                        profileImageUrl: widget.profile['profileImageUrl'],
                        imageSize: 100)
                  ],
                ),
                SizedBox(height: 20),

                ///Profile numbers
                RatingStreamBuilder(profileUid: widget.profile['uid']),
                SizedBox(height: 10),

                buildAbout(profile: widget.profile),
                SizedBox(height: 20),
                lastReleases(profile: widget.profile),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildAbout({required Map<String, dynamic> profile}) => Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sobre',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            profile['release'],
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );

Widget lastReleases({required Map<String, dynamic> profile}) => Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Últimos trabalhos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            profile['lastReleases'],
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
