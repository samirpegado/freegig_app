import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/authentication/screens/login.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/profile_widget.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:iconsax/iconsax.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  bool isSwitched = true;

  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.0,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Iconsax.logout_1))
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ProfileWidget(
                  imagePath: "assets/profiles/default-user-image.png",
                  onClicked: () {},
                  colorCircle: Colors.green,
                ),
              ),
              Text(
                "Olá, user",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "email",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                //max 35 char
                "Aprimore a sua experiência no FreeGIG completando o seu perfil. Personalize suas informações para usufruir ao máximo dos recursos oferecidos.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              buildAbout(),
              SizedBox(height: 20),
              lastReleases(),
              SizedBox(height: 20),
              socialMedia(),
              SizedBox(height: 30),
              completeButton(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildAbout() => Container(
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
            "*Nenhum release publicado",
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );

Widget lastReleases() => Container(
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
            "*Nenhum trabalho publicado",
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
          Text(
            "*Nenhuma rede social publicada",
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );

Widget completeButton() => SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(
            "Completar perfil",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
