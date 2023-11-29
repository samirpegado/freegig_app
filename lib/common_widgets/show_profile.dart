import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/rate_builder.dart';
import 'package:iconsax/iconsax.dart';

class SimpleShowProfile extends StatelessWidget {
  final Map<String, dynamic> profile;
  SimpleShowProfile({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                            profile['publicName'],
                            style: TextStyle(
                              height: 1,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            profile['category'],
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
                                ' ' + profile['city'],
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
                                ' ' + profile['instagram'],
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                          Text(
                            profile['description'],
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    ClipOval(
                      child: Image.network(
                        profile['profileImageUrl'],
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                ///Profile numbers
                RatingStreamBuilder(profileUid: profile['uid']),
                SizedBox(height: 10),

                buildAbout(profile: profile),
                SizedBox(height: 20),
                lastReleases(profile: profile),
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
