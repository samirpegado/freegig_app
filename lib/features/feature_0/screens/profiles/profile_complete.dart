import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/widgets/build_profile_image.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/profile_status_change.dart';
import 'package:freegig_app/services/current_user/current_user_service.dart';
import 'package:freegig_app/features/feature_0/screens/profiles/profile_settings.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/rate_builder.dart';
import 'package:iconsax/iconsax.dart';

class ProfileComplete extends StatefulWidget {
  const ProfileComplete({Key? key}) : super(key: key);

  @override
  State<ProfileComplete> createState() => _ProfileCompleteState();
}

class _ProfileCompleteState extends State<ProfileComplete> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: UserDataService().getCurrentUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        } else {
          Map<String, dynamic> userData = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: ProfileStatusChange(
                userStatus: userData['userStatus'],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    navigationFadeTo(
                        context: context,
                        destination: ProfileSettings(
                          profileImageUrl: userData['profileImageUrl'],
                          publicName: userData['publicName'],
                        ));
                  },
                  icon: Icon(Iconsax.setting_2),
                )
              ],
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            backgroundColor: backgroundColor,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      //Header
                      SizedBox(height: 20),
                      _header(userData),

                      // Profile numbers
                      SizedBox(height: 20),
                      RatingStreamBuilder(profileUid: userData['uid']),

                      // About
                      SizedBox(height: 20),
                      _aboutProfile(userData),

                      /// Last releases
                      SizedBox(height: 20),
                      _lastReleases(userData)
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _header(Map<String, dynamic> userData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData['publicName'],
                style: TextStyle(
                  height: 1,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                userData['category'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                userData['description'],
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              Row(
                children: [
                  Icon(
                    Iconsax.location5,
                    size: 18,
                    color: Colors.black54,
                  ),
                  Text(
                    ' ' + userData['city'],
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Iconsax.instagram5,
                    size: 18,
                    color: Colors.black54,
                  ),
                  Text(
                    ' ' + userData['instagram'],
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        BuildProfileImage(
          profileImageUrl: userData['profileImageUrl'],
          imageSize: 100,
        ),
      ],
    );
  }

  Widget _aboutProfile(Map<String, dynamic> userData) {
    return Container(
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
            userData['release'],
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _lastReleases(Map<String, dynamic> userData) {
    return Container(
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
            userData['lastReleases'],
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }
}
