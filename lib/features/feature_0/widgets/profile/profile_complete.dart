import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/data/services/user_data_service.dart';
import 'package:iconsax/iconsax.dart';

class ProfileComplete extends StatefulWidget {
  const ProfileComplete({super.key});

  @override
  State<ProfileComplete> createState() => _ProfileCompleteState();
}

class _ProfileCompleteState extends State<ProfileComplete> {
  late String _publicName = "";
  late String _category = "";
  late String _description = "";
  late String _email = "";
  late String _release = "";
  late String _lastReleases = "";
  late String _instagram = "";
  late String _youtube = "";
  late String _profileImageUrl = "";
  bool? _userStatus;

  @override
  void initState() {
    super.initState();
    _carregarDadosDoUsuario();
    _loadProfilStatus();
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
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  Future<void> _loadProfilStatus() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          _userStatus = userSnapshot['userStatus'];
        });
      }
    } catch (e) {
      print("Erro ao carregar status de profileComplete: $e");
    }
  }

  Future<void> _updateUserStatus(bool newStatus) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'userStatus': newStatus});

        setState(() {
          _userStatus = newStatus;
          newStatus
              ? Fluttertoast.showToast(
                  msg: "Disponível para Free",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0,
                )
              : Fluttertoast.showToast(
                  msg: "Indisponível para Free",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
        });
      }
    } catch (e) {
      print("Erro ao atualizar o status do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Switch(
          activeColor: Colors.green,
          value: _userStatus ?? false,
          onChanged: (bool value) {
            _updateUserStatus(value);
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Iconsax.user_edit)),
          IconButton(
              onPressed: () {
                UserDataService().logOut(context);
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
                            _publicName,
                            style: TextStyle(
                              height: 1,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _category,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            _description,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(
                            _email,
                            style:
                                TextStyle(fontSize: 15, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    _buildProfileImage(),
                  ],
                ),

                SizedBox(height: 20),
                //Profile numbers
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
                          '* Nenhuma avaliação',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Icon(
                      Iconsax.arrow_right_3,
                    ),
                  ],
                ),
                SizedBox(height: 20),

                ///Release
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Release',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _release,
                        style: TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                /// last releases
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Últimos trabalhos',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _lastReleases,
                        style: TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ],
                  ),
                ),

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
                                  Link("www.youtube.com/$_youtube");
                                },
                                icon: Icon(Iconsax.video5)),
                          ),
                          Text(_youtube,
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
                                  Link("www.instagram.com/$_instagram");
                                },
                                icon: Icon(Iconsax.instagram5)),
                          ),
                          Text(_instagram,
                              style: TextStyle(fontSize: 15, height: 1.4)),
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
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
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
