import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_1/widgets/musicians_message.dart';
import 'package:freegig_app/features/feature_1/widgets/musicians_numbers.dart';
import 'package:freegig_app/features/feature_1/widgets/musician_inviteconfirm.dart';
import 'package:freegig_app/data/data.dart';
import 'package:iconsax/iconsax.dart';

class ProfileDetailsPage extends StatelessWidget {
  final Profile profile;
  ProfileDetailsPage({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        title: Text(
          profile.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.0,
          ),
        ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  openMessage(context);
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Iconsax.message,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {
                  openDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Iconsax.add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: 15),
            ],
          )
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipOval(
                    child: Image.asset(
                      profile.image,
                      height: 128,
                      width: 128,
                      fit: BoxFit.cover,
                    ),
                  )),
              Text(
                profile.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                //max 35 char
                profile.description,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              ProfileNumbers(profile: profile),
              SizedBox(height: 20),
              buildAbout(profile: profile),
              SizedBox(height: 20),
              lastReleases(profile: profile),
              SizedBox(height: 20),
              socialMedia(),
              SizedBox(height: 20),
            ],
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

Widget buildAbout({required Profile profile}) => Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Release',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            profile.release,
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );

Widget lastReleases({required Profile profile}) => Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Últimos trabalhos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            profile.lastJobs,
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );

Widget socialMedia() => Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Redes Sociais',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          ///redes icones
          Row(
            children: [
              Image.asset(
                "assets/icons/youtube.png",
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
              SizedBox(width: 15),
              Image.asset(
                "assets/icons/instagram.png",
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ],
          ),
        ],
      ),
    );
