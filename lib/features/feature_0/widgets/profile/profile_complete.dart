import 'package:flutter/material.dart';
import 'package:freegig_app/features/authentication/controllers/logout_controller.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/profile_widget.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:iconsax/iconsax.dart';

class ProfileComplete extends StatefulWidget {
  const ProfileComplete({super.key});

  @override
  State<ProfileComplete> createState() => _ProfileCompleteState();
}

class _ProfileCompleteState extends State<ProfileComplete> {
  bool isSwitched = true;

  final LogoutUser logoutUser = LogoutUser();

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
                logoutUser.signOut(context);
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
                  imagePath: "assets/profiles/samir.png",
                  onClicked: () {},
                  colorCircle: Colors.blue,
                ),
              ),
              Text(
                "Samir Pegado",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                //max 35 char
                "Baterista, produtor e desenvolvedor",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                "samirpegado@gmail.com",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              ProfileNumbers(),
              SizedBox(height: 20),
              buildAbout(),
              SizedBox(height: 20),
              lastReleases(),
              SizedBox(height: 20),
              socialMedia(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileNumbers extends StatelessWidget {
  const ProfileNumbers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Icon(
              Iconsax.star1,
              color: Colors.amber,
              size: 40,
            ),
            Text(
              "5.0",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(width: 20),
        Container(
          height: 40,
          width: 2,
          color: Colors.grey,
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Icon(
              Iconsax.document_normal4,
              color: Colors.blue,
              size: 40,
            ),
            Text(
              "225",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class NumbersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, '5.0', 'Avaliação'),
          SizedBox(width: 10),
          Container(
            height: 50,
            width: 2,
            color: Colors.grey,
          ),
          SizedBox(width: 10),
          buildButton(context, '255', 'Comentátios'),
        ],
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
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
            "Nam quis nulla. Integer malesuada. In in enim a arcu imperdiet malesuada. Sed vel lectus. Donec odio urna, tempus molestie, porttitor ut, iaculis quis, sem. Phasellus rhoncus. Aenean id metus id velit ullamcorper pulvinar. Vestibulum fermentum tortor id m",
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
            "Nam quis nulla. Integer malesuada. In in enim a arcu imperdiet malesuada. Sed vel lectus. Donec odio urna, tempus molestie, porttitor ut, iaculis quis, sem. Phasellus rhoncus. Aenean id metus id velit ullamcorper pulvinar. Vestibulum fermentum tortor id m",
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
