import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GigsDataService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> createNewGig({
    required String gigDescription,
    required String gigCity,
    required String gigAddress,
    required String gigInitHour,
    required String gigFinalHour,
    required String gigDate,
    required String gigCache,
    required String gigCategorys,
    required String gigDetails,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentReference newGigRef = _firestore.collection('gigs').doc();

        await newGigRef.set({
          ///definicoes da gig
          'gigUid': newGigRef.id,
          'gigOwner': user.uid,
          'gigArchived': false,

          /// formularios da gig
          'gigDescription': gigDescription,
          'gigLocale': gigCity,
          'gigAdress': gigAddress,
          'gigInitHour': gigInitHour,
          'gigFinalHour': gigFinalHour,
          'gigDate': gigDate,
          'gigCache': gigCache,
          'gigCategorys': gigCategorys,
          'gigDetails': gigDetails,
        });
      }
    } catch (e) {
      print("Erro ao criar esta gig: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getActiveUserGigs() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot gigsSnapshot = await _firestore
            .collection('gigs')
            .where('gigArchived', isEqualTo: false)
            .where('gigOwner', isNotEqualTo: user.uid)
            .get();

        List<Map<String, dynamic>> gigsDataList = [];

        for (QueryDocumentSnapshot gigDocument in gigsSnapshot.docs) {
          Map<String, dynamic> gigData =
              gigDocument.data() as Map<String, dynamic>;

          // Obter informações do usuário que criou a GIG
          DocumentSnapshot userSnapshot = await _firestore
              .collection('users')
              .doc(gigData['gigOwner'])
              .get();

          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          gigsDataList.add({
            'gigUid': gigDocument.id,
            'gigDescription': gigData['gigDescription'],
            'gigLocale': gigData['gigLocale'],
            'gigAdress': gigData['gigAdress'],
            'gigInitHour': gigData['gigInitHour'],
            'gigFinalHour': gigData['gigFinalHour'],
            'gigDate': gigData['gigDate'],
            'gigCache': gigData['gigCache'],
            'gigCategorys': gigData['gigCategorys'],
            'gigDetails': gigData['gigDetails'],
            'profileImageUrl': userData['profileImageUrl'],
            'publicName': userData['publicName'],
            'category': userData['category'],
          });
        }

        return gigsDataList;
      }
    } catch (e) {
      print("Erro ao buscar dados das GIGs: $e");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getMyActiveGigs() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot gigsSnapshot = await _firestore
            .collection('gigs')
            .where('gigArchived', isEqualTo: false)
            .where('gigOwner', isEqualTo: user.uid)
            .get();

        List<Map<String, dynamic>> gigsDataList = [];

        for (QueryDocumentSnapshot gigDocument in gigsSnapshot.docs) {
          Map<String, dynamic> gigData =
              gigDocument.data() as Map<String, dynamic>;

          // Obter informações do usuário que criou a GIG
          DocumentSnapshot userSnapshot = await _firestore
              .collection('users')
              .doc(gigData['gigOwner'])
              .get();

          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          gigsDataList.add({
            'gigUid': gigDocument.id,
            'gigDescription': gigData['gigDescription'],
            'gigLocale': gigData['gigLocale'],
            'gigAdress': gigData['gigAdress'],
            'gigInitHour': gigData['gigInitHour'],
            'gigFinalHour': gigData['gigFinalHour'],
            'gigDate': gigData['gigDate'],
            'gigCache': gigData['gigCache'],
            'gigCategorys': gigData['gigCategorys'],
            'gigDetails': gigData['gigDetails'],
            'profileImageUrl': userData['profileImageUrl'],
            'publicName': userData['publicName'],
            'category': userData['category'],
          });
        }

        return gigsDataList;
      }
    } catch (e) {
      print("Erro ao buscar dados das GIGs: $e");
    }
    return [];
  }
}
