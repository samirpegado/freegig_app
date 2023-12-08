import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/toast.dart';

class ProfileStatusChange extends StatefulWidget {
  final bool userStatus;
  const ProfileStatusChange({super.key, required this.userStatus});

  @override
  State<ProfileStatusChange> createState() => _ProfileStatusChangeState();
}

class _ProfileStatusChangeState extends State<ProfileStatusChange> {
  late bool _userStatus;

  @override
  void initState() {
    super.initState();
    _userStatus = widget.userStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: Colors.green,
      value: _userStatus,
      onChanged: (bool value) async {
        setState(() {
          _userStatus = !_userStatus;
        });
        await _updateUserStatus(value);
      },
    );
  }

  Future<void> _updateUserStatus(bool newStatus) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'userStatus': newStatus});

        _userStatus = newStatus;
        newStatus
            ? showToast(message: "Disponível para Free")
            : showToast(message: "Indisponível para Free");
      }
    } catch (e) {
      print("Erro ao atualizar o status do usuário: $e");
    }
  }
}
