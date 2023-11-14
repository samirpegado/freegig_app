import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_1/widgets/musicians_message.dart';
import 'package:freegig_app/features/feature_1/widgets/musician_inviteconfirm.dart';
import 'package:iconsax/iconsax.dart';

class ProfileDetailsPage extends StatelessWidget {
  final Map<String, dynamic> profile;
  ProfileDetailsPage({required this.profile});

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
            openDialog(context);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 15),
                        Text(
                          '*Nenhuma avaliação',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Icon(
                      Iconsax.arrow_right_3,
                    ),
                  ],
                ),
                SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    openMessage(context);
                  },
                  child: Text(
                    "Enviar uma mensagem",
                    style: TextStyle(fontSize: 15),
                  ),
                ),

                buildAbout(profile: profile),
                SizedBox(height: 20),
                lastReleases(profile: profile),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Redes Sociais',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      ///redes icones
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(100)),
                            child: IconButton(
                                onPressed: () {
                                  Link("www.youtube.com/_youtube");
                                },
                                icon: Icon(Iconsax.video5)),
                          ),
                          Text(profile['youtube'],
                              style: TextStyle(fontSize: 15, height: 1.4)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(100)),
                            child: IconButton(
                                onPressed: () {
                                  Link("www.instagram.com/_instagram");
                                },
                                icon: Icon(Iconsax.instagram5)),
                          ),
                          Text(profile['instagram'],
                              style: TextStyle(fontSize: 15, height: 1.4)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future openDialog(context) => showDialog(
      context: context, builder: (context) => InviteConfirm(profile: profile));

  Future openMessage(context) => showDialog(
      context: context,
      builder: (context) => MessageToMusician(profile: profile));
}

Widget buildAbout({required Map<String, dynamic> profile}) => Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Release',
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
