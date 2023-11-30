import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/build_profile_image.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/common_widgets/toast.dart';
import 'package:freegig_app/data/services/user_data_service.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/profile_settings.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/rate_builder.dart';
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
  late String _city = "";
  late String _release = "";
  late String _lastReleases = "";
  late String _instagram = "";
  late String _profileImageUrl = "";
  late String _uid = '';
  bool? _userStatus;

  late Widget ratingStreamBuilder = Container();

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
        _city = userData['city'];
        _release = userData['release'];
        _lastReleases = userData['lastReleases'];
        _instagram = userData['instagram'];
        _profileImageUrl = userData['profileImageUrl'];
        _uid = userData['uid'];

        ratingStreamBuilder = RatingStreamBuilder(profileUid: _uid);
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
              ? showToast(message: "Disponível para Free")
              : showToast(message: "Indisponível para Free");
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
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileSettings(
                          profileImageUrl: _profileImageUrl,
                          publicName: _publicName,
                        )));
              },
              icon: Icon(Iconsax.setting_2))
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
                          Row(
                            children: [
                              Icon(
                                Iconsax.location5,
                                size: 18,
                                color: Colors.black54,
                              ),
                              Text(
                                ' ' + _city,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black54),
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
                                ' ' + _instagram,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    BuildProfileImage(
                      profileImageUrl: _profileImageUrl,
                      imageSize: 100,
                    ),
                  ],
                ),

                SizedBox(height: 20),

                ///Profile numbers
                ratingStreamBuilder,

                SizedBox(height: 20),

                ///Release
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sobre',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
