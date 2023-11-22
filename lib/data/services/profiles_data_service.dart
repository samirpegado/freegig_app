import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDataService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getAllActiveUserProfileStream() {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        return _firestore
            .collection('users')
            .where('userStatus', isEqualTo: true)
            .where('uid', isNotEqualTo: user.uid)
            .snapshots()
            .map((usersSnapshot) {
          List<Map<String, dynamic>> userDataList = [];

          for (QueryDocumentSnapshot userDocument in usersSnapshot.docs) {
            Map<String, dynamic> userData =
                userDocument.data() as Map<String, dynamic>;

            userDataList.add({
              'uid': userData['uid'],
              'publicName': userData['publicName'],
              'city': userData['city'],
              'category': userData['category'],
              'description': userData['description'],
              'release': userData['release'],
              'lastReleases': userData['lastReleases'],
              'instagram': userData['instagram'],
              'youtube': userData['youtube'],
              'profileImageUrl': userData['profileImageUrl'],
            });
          }

          return userDataList;
        });
      }
    } catch (e) {
      print("Erro ao buscar dados dos usuários: $e");
    }

    // Retorna um stream vazio em caso de erro
    return Stream.value([]);
  }

  Stream<List<Map<String, dynamic>>> getCityActiveUserProfileStream(
      String city) {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        return _firestore
            .collection('users')
            .where('userStatus', isEqualTo: true)
            .where('uid', isNotEqualTo: user.uid)
            .where('city', isEqualTo: city)
            .snapshots()
            .map((usersSnapshot) {
          List<Map<String, dynamic>> userDataList = [];

          for (QueryDocumentSnapshot userDocument in usersSnapshot.docs) {
            Map<String, dynamic> userData =
                userDocument.data() as Map<String, dynamic>;

            userDataList.add({
              'uid': userData['uid'],
              'publicName': userData['publicName'],
              'city': userData['city'],
              'category': userData['category'],
              'description': userData['description'],
              'release': userData['release'],
              'lastReleases': userData['lastReleases'],
              'instagram': userData['instagram'],
              'youtube': userData['youtube'],
              'profileImageUrl': userData['profileImageUrl'],
            });
          }

          return userDataList;
        });
      }
    } catch (e) {
      print("Erro ao buscar dados dos usuários: $e");
    }

    // Retorna um stream vazio em caso de erro
    return Stream.value([]);
  }
}
