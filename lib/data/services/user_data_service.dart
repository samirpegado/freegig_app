import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
            // Adicione outros campos conforme necessário
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
    required String youtube,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'description': description,
          'release': release,
          'lastReleases': lastReleases,
          'instagram': instagram,
          'youtube': youtube,
          'profileComplete': true,
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
            'email': userSnapshot['email'],
            'release': userSnapshot['release'],
            'lastReleases': userSnapshot['lastReleases'],
            'instagram': userSnapshot['instagram'],
            'youtube': userSnapshot['youtube'],
          };
        }
      }
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
    return {};
  }
}
