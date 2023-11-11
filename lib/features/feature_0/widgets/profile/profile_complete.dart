import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/data/services/user_data_service.dart';
import 'package:iconsax/iconsax.dart';

class ProfileComplete extends StatefulWidget {
  const ProfileComplete({super.key});

  @override
  State<ProfileComplete> createState() => _ProfileCompleteState();
}

class _ProfileCompleteState extends State<ProfileComplete> {
  bool isSwitched = true;

  late String _publicName = "";
  late String _category = "";
  late String _description = "";
  late String _email = "";
  late String _release = "";
  late String _lastReleases = "";
  late String _instagram = "";
  late String _youtube = "";
  late String _profileImageUrl = "";

  @override
  void initState() {
    super.initState();
    _carregarDadosDoUsuario(); // carrega os dados
  }

  Future<void> _carregarDadosDoUsuario() async {
    try {
      Map<String, dynamic> userData = await UserDataService().getProfileData();

      setState(() {
        _publicName = userData['publicName'];
        _category = userData['category'];
        _description = userData['description'];
        _email = userData['email'];
        _release = userData['release'];
        _lastReleases = userData['lastReleases'];
        _instagram = userData['instagram'];
        _youtube = userData['youtube'];
        _profileImageUrl = userData['profileImageUrl'];
      });
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e"); // Trate erros, se houverem
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _publicName,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.0,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
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
              SizedBox(height: 20),
              _buildProfileImage(),
              SizedBox(height: 5),

              Text(
                //max 35 char
                "$_publicName (${_category})",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                //max 35 char
                _description,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                _email,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              ProfileNumbers(),
              SizedBox(height: 20),

              ///Release
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Release',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _release,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              /// last releases
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Últimos trabalhos',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _lastReleases,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Redes Sociais',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                Link("www.youtube.com/$_youtube");
                              },
                              icon: Icon(Iconsax.video5)),
                        ),
                        Text(_youtube,
                            style: TextStyle(fontSize: 16, height: 1.4)),
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
                                Link("www.instagram.com/$_instagram");
                              },
                              icon: Icon(Iconsax.instagram5)),
                        ),
                        Text(_instagram,
                            style: TextStyle(fontSize: 16, height: 1.4)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return _profileImageUrl.isNotEmpty
        ? ClipOval(
            child: Image.network(
              _profileImageUrl,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('assets/profiles/default-user-image.png'),
                );
              },
            ),
          )
        : CircleAvatar(
            radius: 50,
            backgroundImage:
                AssetImage('assets/profiles/default-user-image.png'),
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
