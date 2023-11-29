import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:freegig_app/common_widgets/pickimage.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/data/services/user_data_service.dart';
import 'package:iconsax/iconsax.dart';

class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({super.key});

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
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
      Map<String, dynamic> userData = await UserDataService().getUserData();

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

  @override
  void dispose() {
    description.dispose();
    release.dispose();
    lastReleases.dispose();
    instagram.dispose();
    super.dispose();
  }

  Future<void> _completarPerfil() async {
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

    await UserDataService().updateUserProfile(
      description: description.text.trim(),
      release: release.text.trim(),
      lastReleases: lastReleases.text.trim(),
      instagram: instagram.text.trim(),
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
      _isImageSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            _completarPerfil();
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
                        onTap: _pickImage,
                        child: _image != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                    'assets/profiles/default-user-image.png'),
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

              TextFormField(
                controller: description,
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
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Iconsax.instagram),
                  labelText: "Instagram",
                  hintText: "@seuperfil",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
