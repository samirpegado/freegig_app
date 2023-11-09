import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/profile_complete.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/profile_edit.dart';

class ProfileSwitcher extends StatefulWidget {
  const ProfileSwitcher({super.key});

  @override
  State<ProfileSwitcher> createState() => _ProfileSwitcherState();
}

class _ProfileSwitcherState extends State<ProfileSwitcher> {
  bool showProfileComplete = false;
  void togglePages() {
    setState(() {
      showProfileComplete = !showProfileComplete;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showProfileComplete) {
      return ProfileComplete();
    } else {
      return ProfileEdit();
    }
  }
}
