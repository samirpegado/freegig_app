import 'package:flutter/material.dart';
import 'package:freegig_app/classes/city_list.dart';
import 'package:freegig_app/common_widgets/musicianonlyselectionform.dart';
import 'package:freegig_app/common_widgets/searchgooglecity.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/data/services/user_data_service.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/delete_account_confirm.dart';
import 'package:iconsax/iconsax.dart';

class ProfileUpdateForm extends StatefulWidget {
  const ProfileUpdateForm({super.key});

  @override
  State<ProfileUpdateForm> createState() => _ProfileUpdateFormState();
}

class _ProfileUpdateFormState extends State<ProfileUpdateForm> {
  late String _publicName = "";
  late String _category = "";
  late String _description = "";
  late String _city = "";
  late String _release = "";
  late String _lastReleases = "";
  late String _instagram = "";
  bool cityValidator = false;
  bool categoryValidator = false;
  String selectedMusician = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    setState(() {});
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic> userData = await UserDataService().getProfileData();

      setState(() {
        _publicName = userData['publicName'];
        _category = userData['category'];
        _description = userData['description'];
        _city = userData['city'];
        _release = userData['release'];
        _lastReleases = userData['lastReleases'];
        _instagram = userData['instagram'];

        description.text = _description;
        category.text = _category;
        release.text = _release;
        _cityController.text = _city;
        lastReleases.text = _lastReleases;
        instagram.text = _instagram;
        publicName.text = _publicName;
      });
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  final description = TextEditingController();
  final publicName = TextEditingController();
  final release = TextEditingController();
  final category = TextEditingController();
  final _cityController = TextEditingController();
  final lastReleases = TextEditingController();
  final instagram = TextEditingController();

  Future<void> _updateProfile() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    await UserDataService().updateProfile(
      description: description.text.trim(),
      release: release.text.trim(),
      lastReleases: lastReleases.text.trim(),
      instagram: instagram.text.trim(),
      city: _cityController.text.trim(),
      category: category.text,
      publicName: publicName.text,
    );
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NavigationMenu(navPage: 3),
    ));
  }

  void cityValidate(String? city) {
    if (city!.isEmpty || !CityList().cityList.contains(city)) {
      setState(() {
        cityValidator = true;
      });
    } else {
      setState(() {
        cityValidator = false;
      });
    }
  }

  void categoryValidate(String? category) {
    if (category!.isEmpty) {
      setState(() {
        categoryValidator = true;
      });
    } else {
      setState(() {
        categoryValidator = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Atualizar perfil',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              cityValidate(_cityController.text);
              if (!cityValidator && !categoryValidator) {
                _updateProfile();
              }
            },
            icon: Icon(
              Iconsax.refresh_circle5,
              color: Colors.green,
              size: 35,
            ),
          ),
          SizedBox(width: 5)
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              /// photo and banner
              Column(
                children: [
                  Text(
                    "$_publicName,",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Vamos atualizar seu perfil.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),

              ///forms
              TextFormField(
                controller: publicName,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Iconsax.user),
                  labelText: "Nome artístico*",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              SizedBox(height: 26),
              SearchGoogleCity(cityController: _cityController),
              Visibility(
                visible: cityValidator,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                  child: Text(
                    'Cidade inválida.',
                    style: TextStyle(
                        color: Color.fromARGB(255, 223, 41, 28), fontSize: 12),
                  ),
                ),
              ),
              SizedBox(height: 26),

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

              MusicianOnlySelectionForm(categoryController: category),
              Visibility(
                visible: categoryValidator,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                  child: Text(
                    'Categoria inválida.',
                    style: TextStyle(
                        color: Color.fromARGB(255, 223, 41, 28), fontSize: 12),
                  ),
                ),
              ),

              SizedBox(height: 26),
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
              SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => DeleteAccountConfirm());
                },
                child: Text(
                  'Excluir conta',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
