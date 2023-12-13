import 'dart:typed_data';
import 'dart:io';

import 'package:freegig_app/common/functions/navigation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:freegig_app/services/current_user/current_user_service.dart';
import 'package:iconsax/iconsax.dart';

class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({super.key});

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
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

  final description = TextEditingController();
  final release = TextEditingController();
  final lastReleases = TextEditingController();
  final instagram = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    description.dispose();
    release.dispose();
    lastReleases.dispose();
    instagram.dispose();
    super.dispose();
  }

  Future<void> _completeProfile() async {
    if (!_isImageSelected || _image == null) {
      // Check if an image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecione uma foto para o perfil.'),
        ),
      );
      return;
    } else if (formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await UserDataService().completeUserProfile(
        description: description.text.trim(),
        release: release.text.trim(),
        lastReleases: lastReleases.text.trim(),
        instagram: instagram.text.trim(),
        image: _image!,
      );
      navigationFadeTo(
          context: context, destination: NavigationMenu(navPage: 3));
    }
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
          'Complete seu perfil',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
        ],
        automaticallyImplyLeading: false,
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
                _completeProfile();
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  "Completar perfil",
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
              /// photo and banner
              Row(
                children: [
                  Stack(
                    children: [
                      InkWell(
                        onTap: _pickAndCropImage,
                        child: _image != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: FileImage(_image!),
                                backgroundColor: Colors.grey[200],
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                    'assets/profiles/default-user-image.png'),
                                backgroundColor: Colors.grey[200],
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 60,
                        child: Icon(Icons.add_a_photo),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "$_publicName,",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Nos conte um pouco mais sobre você.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),

              ///forms
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: description,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obrigatório';
                          } else {
                            return null;
                          }
                        },
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 30,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(Iconsax.message_minus),
                          labelText: "Descrição*",
                          hintText: "Ex: Versátil, criativo e pontual",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      TextFormField(
                        controller: release,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obrigatório';
                          } else {
                            return null;
                          }
                        },
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 200,
                        maxLines: 2,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(Iconsax.edit),
                          labelText: "Sobre*",
                          hintText: "Um breve resumo sobre você e sua carreira",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      TextFormField(
                        controller: lastReleases,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obrigatório';
                          } else {
                            return null;
                          }
                        },
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 200,
                        maxLines: 2,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(Iconsax.medal_star),
                          labelText: "Últimos trabalhos",
                          hintText:
                              "Com quem tocou recentemente, os trabalhos que gravou...",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      TextFormField(
                        controller: instagram,
                        onChanged: (value) {
                          if (value.startsWith('@')) {
                            // Remove o "@" se já estiver no início do texto
                            instagram.value = TextEditingValue(
                              text: value.substring(1),
                              selection: TextSelection.collapsed(
                                  offset: value.length - 1),
                            );
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return null; // Campo não é obrigatório, então retorna null se estiver vazio
                          } else {
                            // Verifica se o valor corresponde ao formato desejado
                            bool isValid = RegExp(r'^[\w.]+$').hasMatch(value);
                            if (!isValid) {
                              return 'Formato inválido. Use apenas caracteres alfanuméricos.';
                            }
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(Iconsax.instagram),
                          prefix:
                              Text('@'), // Exibe o "@" dentro da caixa de texto
                          labelText: "Instagram",
                          hintText: "seuperfil",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
