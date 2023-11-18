import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDataService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllActiveUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot usersSnapshot = await _firestore
            .collection('users')
            .where('userStatus', isEqualTo: true)
            .where('uid', isNotEqualTo: user.uid)
            .get();

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
      }
    } catch (e) {
      print("Erro ao buscar dados dos usuários: $e");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getCityActiveUserProfile(
      String city) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot usersSnapshot = await _firestore
            .collection('users')
            .where('userStatus', isEqualTo: true)
            .where('uid', isNotEqualTo: user.uid)
            .where('city', isEqualTo: city)
            .get();

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
      }
    } catch (e) {
      print("Erro ao buscar dados dos usuários: $e");
    }
    return [];
  }
}
