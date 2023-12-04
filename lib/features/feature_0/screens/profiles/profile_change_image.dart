import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:freegig_app/common/functions/pickimage.dart';
import 'package:freegig_app/common/functions/themeapp.dart';
import 'package:freegig_app/services/current_user/current_user_service.dart';

class ChangeProfileImage extends StatefulWidget {
  const ChangeProfileImage({super.key});

  @override
  State<ChangeProfileImage> createState() => _ChangeProfileImageState();
}

class _ChangeProfileImageState extends State<ChangeProfileImage> {
  late String _publicName = "";
  Uint8List? _image;
  bool _isImageSelected = false;

  @override
  void initState() {
    super.initState();
    _carregarDadosDoUsuario();
  }

  Future<void> _carregarDadosDoUsuario() async {
    try {
      Map<String, dynamic> userData =
          await UserDataService().getCurrentUserData();

      setState(() {
        _publicName = userData['publicName'];
      });
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  Future<void> _changeImage() async {
    if (!_isImageSelected || _image == null) {
      // Check if an image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecione uma foto para o perfil.'),
        ),
      );
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    await UserDataService().updateProfileImage(
      image: _image!,
    );
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NavigationMenu(navPage: 3),
    ));
  }

  void _pickImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
      _isImageSelected = true; // Set the flag when an image is selected
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Alterar foto do perfil',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.0,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: backgroundColor,
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                _changeImage();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Alterar foto",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Stack(
                children: [
                  InkWell(
                    onTap: _pickImage,
                    child: _image != null
                        ? CircleAvatar(
                            radius: 100,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage(
                                'assets/profiles/default-user-image.png'),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 120,
                    child: Icon(Icons.add_a_photo, size: 40),
                  )
                ],
              ),
              SizedBox(height: 20),
              Text(
                "$_publicName,",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                "Por favor, clique na imagem acima para selecionar uma nova foto para o seu perfil.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
