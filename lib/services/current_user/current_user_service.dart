import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserDataService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> getCurrentUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (userSnapshot.exists) {
          return userSnapshot.data() as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
    return {};
  }

  Future<void> completeUserProfile({
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
          'userStatus': true,
        });
      }
    } catch (e) {
      print("Erro ao atualizar dados do usuário: $e");
    }
  }

  Future<void> updateProfileImage({
    required Uint8List image,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String imageUrl = await uploadImagetoStorage(user.uid, image);
        await _firestore.collection('users').doc(user.uid).update({
          'profileImageUrl': imageUrl,
        });
      }
    } catch (e) {
      print("Erro ao atualizar dados do usuário: $e");
    }
  }

  Future<void> updateProfile({
    required String publicName,
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
          'publicName': publicName,
          'description': description,
          'release': release,
          'lastReleases': lastReleases,
          'instagram': instagram,
          'category': category,
          'city': city,
          'profileComplete': true,
          'userStatus': true,
        });
      }
    } catch (e) {
      print("Erro ao atualizar dados do usuário: $e");
    }
  }

  Future<String> uploadImagetoStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
