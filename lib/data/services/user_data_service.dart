import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/authentication/screens/login.dart';

class UserDataService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (userSnapshot.exists) {
          return {
            'publicName': userSnapshot['publicName'],
            'category': userSnapshot['category'],
            'uid': userSnapshot['uid'],
          };
        }
      }
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
    return {};
  }

  Future<void> updateUserProfile({
    required String description,
    required String release,
    required String lastReleases,
    required String instagram,
    required Uint8List image,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String imageUrl = await uploadImagetoStorage(user.uid, image);
        await _firestore.collection('users').doc(user.uid).update({
          'description': description,
          'release': release,
          'lastReleases': lastReleases,
          'instagram': instagram,
          'profileComplete': true,
          'profileImageUrl': imageUrl,
          'userStatus': false,
        });
      }
    } catch (e) {
      print("Erro ao atualizar dados do usuário: $e");
    }
  }

  Future<void> updateProfile({
    required String description,
    required String release,
    required String lastReleases,
    required String instagram,
    required String city,
    required String category,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'description': description,
          'release': release,
          'lastReleases': lastReleases,
          'instagram': instagram,
          'category': category,
          'city': city,
          'profileComplete': true,
          'userStatus': false,
        });
      }
    } catch (e) {
      print("Erro ao atualizar dados do usuário: $e");
    }
  }

  Future<Map<String, dynamic>> getProfileData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (userSnapshot.exists) {
          return {
            'publicName': userSnapshot['publicName'],
            'category': userSnapshot['category'],
            'description': userSnapshot['description'],
            'city': userSnapshot['city'],
            'email': userSnapshot['email'],
            'release': userSnapshot['release'],
            'lastReleases': userSnapshot['lastReleases'],
            'instagram': userSnapshot['instagram'],
            'profileImageUrl': userSnapshot['profileImageUrl'],
          };
        }
      }
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
    return {};
  }

  Future<Map<String, dynamic>> getCityProfileData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (userSnapshot.exists) {
          return {
            'city': userSnapshot['city'],
          };
        }
      }
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
    return {};
  }

  void logOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<String> uploadImagetoStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
