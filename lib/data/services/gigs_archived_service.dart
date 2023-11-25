import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freegig_app/classes/datetime_convert.dart';
import 'package:freegig_app/data/services/data_common_task.dart';

class GigsArchived {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> processGigData(
      QuerySnapshot gigsSnapshot) async {
    List<Map<String, dynamic>> gigsDataList = [];

    for (QueryDocumentSnapshot gigDocument in gigsSnapshot.docs) {
      Map<String, dynamic> gigData = gigDocument.data() as Map<String, dynamic>;
      String ownerId = gigData['gigOwner'];

      Map<String, dynamic> userData =
          await DataCommonTask().getGigUserData(ownerId);

      gigsDataList.add({
        ...gigData,
        'profileImageUrl': userData['profileImageUrl'],
        'publicName': userData['publicName'],
        'category': userData['category'],
      });
    }

    gigsDataList.sort((b, a) {
      DateTime dateA = DateTimeConvert().parseDate(a['gigDate']);
      DateTime dateB = DateTimeConvert().parseDate(b['gigDate']);

      return dateA.compareTo(dateB);
    });

    return gigsDataList;
  }

  // Funcao para pegar as gigs que o usuario criou e esta participando
  Stream<List<Map<String, dynamic>>> getMyAllArchivedGigsStream() {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        return _firestore
            .collection('gigs')
            .where('gigArchived', isEqualTo: true)
            .where('gigParticipants', arrayContains: user.uid)
            .snapshots()
            .asyncMap((gigsSnapshot) async {
          return processGigData(gigsSnapshot);
        });
      }
    } catch (e) {
      print("Erro ao buscar dados das GIGs: $e");
    }
    // Retorna um stream vazio em caso de erro
    return Stream.value([]);
  }
}
