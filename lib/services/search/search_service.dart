import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freegig_app/classes/datetime_convert.dart';

class SearchService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  ///Pega os usuários disponiveis de acordo com os filtros
  Stream<List<Map<String, dynamic>>> getAvalibleProfiles({
    String? city,
    String? category,
    String? rate,
  }) {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        Query query = _firestore
            .collection('users')
            .where('userStatus', isEqualTo: true)
            .where('uid', isNotEqualTo: user.uid);

        if (city != null && city != 'Brasil') {
          query = query.where('city', isEqualTo: city);
        }

        if (category != null && category != 'Todos') {
          query = query.where('category', isEqualTo: category);
        }

        return query.snapshots().map((usersSnapshot) {
          List<Map<String, dynamic>> userDataList = [];

          for (QueryDocumentSnapshot userDocument in usersSnapshot.docs) {
            Map<String, dynamic> userData =
                userDocument.data() as Map<String, dynamic>;

            userDataList.add({...userData});
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

  ///Pega as gigs disponiveis de acordo com os filtros
  Stream<List<Map<String, dynamic>>> getAvalibleGigs({
    String? city,
    String? category,
    String? cache,
    String? data,
  }) {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        Query query = _firestore
            .collection('gigs')
            .where('gigArchived', isEqualTo: false)
            .where('gigOwner', isNotEqualTo: user.uid);

        if (city != null && city != 'Brasil') {
          query = query.where('gigLocale', isEqualTo: city);
        }

        if (category != null && category != 'Todos') {
          query = query.where('gigCategorys', arrayContains: category);
        }

        return query.snapshots().asyncExpand((gigsSnapshot) async* {
          List<Map<String, dynamic>> gigsDataList = [];

          //Adiciona os dados da gigs e do usuário que criou a gig
          for (QueryDocumentSnapshot gigDocument in gigsSnapshot.docs) {
            Map<String, dynamic> gigData =
                gigDocument.data() as Map<String, dynamic>;

            DocumentSnapshot userSnapshot = await _firestore
                .collection('users')
                .doc(gigData['gigOwner'])
                .get();

            Map<String, dynamic> userData =
                userSnapshot.data() as Map<String, dynamic>;

            bool dataCondition =
                data != null ? gigData['gigDate'] == data : true;

            if (dataCondition) {
              gigsDataList.add({
                ...gigData,
                'profileImageUrl': userData['profileImageUrl'],
                'publicName': userData['publicName'],
                'category': userData['category'],
              });
            }
          }
          double convertToNumber(String value) {
            return double.parse(value.replaceAll(',', '.'));
          }

          if (cache == 'decreasing') {
            gigsDataList.sort((b, a) => convertToNumber(a['gigCache'])
                .compareTo(convertToNumber(b['gigCache'])));
          } else if (cache == 'increasing') {
            gigsDataList.sort((a, b) => convertToNumber(a['gigCache'])
                .compareTo(convertToNumber(b['gigCache'])));
          } else {
            gigsDataList.sort((a, b) {
              DateTime dateA = DateTimeConvert().parseDate(a['gigDate']);
              DateTime dateB = DateTimeConvert().parseDate(b['gigDate']);

              return dateA.compareTo(dateB);
            });
          }

          yield gigsDataList;
        });
      }
    } catch (e) {
      print("Erro ao buscar dados das GIGs: $e");
    }
    // Retorna um stream vazio em caso de erro
    return Stream.value([]);
  }
}
