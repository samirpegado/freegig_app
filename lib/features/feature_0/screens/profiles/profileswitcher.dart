import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freegig_app/common/functions/navigation.dart';

import 'package:freegig_app/features/authentication/screens/login.dart';
import 'package:freegig_app/features/feature_0/screens/profiles/profile_complete.dart';
import 'package:freegig_app/features/feature_0/screens/profiles/profile_edit.dart';

class ProfileSwitcher extends StatefulWidget {
  @override
  _ProfileSwitcherState createState() => _ProfileSwitcherState();
}

class _ProfileSwitcherState extends State<ProfileSwitcher> {
  bool? _profileComplete;

  @override
  void initState() {
    super.initState();
    _loadProfileCompleteStatus();
  }

  Future<void> _loadProfileCompleteStatus() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          _profileComplete = userSnapshot['profileComplete'];
        });
      }
    } catch (e) {
      print("Erro ao carregar status de profileComplete: $e");
    }
  }

  void _logoutAndNavigateToLogin() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pop(); // Pop the current screen
      navigationFadeTo(context: context, destination: LoginScreen());
    } catch (e) {
      print("Erro ao fazer logout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profileComplete == null) {
      return Center(
        child: InkWell(
            onLongPress: () {
              _logoutAndNavigateToLogin();
            },
            child: CircularProgressIndicator()),
      );
    } else {
      return _profileComplete! ? ProfileComplete() : ProfileEdit();
    }
  }
}
