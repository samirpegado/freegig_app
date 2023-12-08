import 'dart:io';
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
    required File image,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String imageUrl = await uploadImageToStorage(user.uid, image);
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
    required File image,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String imageUrl = await uploadImageToStorage(user.uid, image);
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

  Future<String> uploadImageToStorage(String userUid, File file) async {
    // Adiciona o timestamp ao nome do child
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String userUidWithTimestamp = '$userUid-$timestamp';

    // Cria a referência no Firebase Storage para o novo arquivo dentro da pasta userUid
    Reference newRef =
        _storage.ref().child(userUid).child(userUidWithTimestamp);

    // Inicia o upload do novo arquivo
    UploadTask uploadTask = newRef.putFile(file);

    // Aguarda a conclusão do upload
    TaskSnapshot snapshot = await uploadTask;

    // Obtém a URL de download do novo arquivo enviado
    String downloadUrl = await snapshot.ref.getDownloadURL();

    // Cria a referência no Firebase Storage para a pasta userUid
    Reference userDirectoryRef = _storage.ref().child(userUid);

    try {
      // Lista os itens na pasta userUid
      ListResult listResult = await userDirectoryRef.listAll();

      // Exclui todos os itens na pasta userUid, exceto o mais recente
      for (Reference ref in listResult.items) {
        if (ref.name != newRef.name) {
          await ref.delete();
        }
      }
    } catch (e) {
      // Lida com erros ao excluir itens antigos
      print('Erro ao excluir itens antigos: $e');
    }

    return downloadUrl;
  }
}
