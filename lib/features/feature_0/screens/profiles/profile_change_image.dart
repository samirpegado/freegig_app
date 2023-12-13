import 'dart:io';
import 'dart:typed_data';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:freegig_app/services/current_user/current_user_service.dart';

class ChangeProfileImage extends StatefulWidget {
  const ChangeProfileImage({super.key});

  @override
  State<ChangeProfileImage> createState() => _ChangeProfileImageState();
}

class _ChangeProfileImageState extends State<ChangeProfileImage> {
  late String _publicName = "";
  File? _image;
  bool _isImageSelected = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
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
    navigationFadeTo(context: context, destination: NavigationMenu(navPage: 3));
  }

  void _pickAndCropImage() async {
    final picker = ImagePicker();

    // Passo 1: Obter imagem da galeria
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Passo 2: Abrir o ImageCropper
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cortar',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Cortar',
          ),
        ],
      );

      if (croppedFile != null) {
        // Passo 3: Redimensionar a imagem
        File resizedImage = await resizeImage(croppedFile.path, 600, 600);

        // Passo 4: Atualizar o estado com a imagem redimensionada
        setState(() {
          _image = resizedImage;
          _isImageSelected = true;
        });
      }
    }
  }

// Função para redimensionar a imagem
  Future<File> resizeImage(String imagePath, int width, int height) async {
    File imageFile = File(imagePath);
    Uint8List imageBytes = await imageFile.readAsBytes();

    img.Image? image = img.decodeImage(imageBytes);
    img.Image resizedImage =
        img.copyResize(image!, width: width, height: height);

    File resizedFile = File(imagePath)
      ..writeAsBytesSync(
          img.encodeJpg(resizedImage, quality: 50)); // Ajusta a qualidade

    return resizedFile;
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
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  "Alterar",
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
                    onTap: _pickAndCropImage,
                    child: _image != null
                        ? CircleAvatar(
                            radius: 80,
                            backgroundImage: FileImage(_image!),
                            backgroundColor: Colors.grey[200],
                          )
                        : CircleAvatar(
                            radius: 80,
                            backgroundImage: AssetImage(
                                'assets/profiles/default-user-image.png'),
                            backgroundColor: Colors.grey[200],
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
