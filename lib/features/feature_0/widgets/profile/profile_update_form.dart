import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:freegig_app/common_widgets/searchgooglecity.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/data/services/user_data_service.dart';
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
  late String _youtube = "";

  String selectedMusician = '';
  Map<String, List<String>> options = {
    'Voz': ['Cantor', 'Cantora'],
    'Cordas': [
      'Violinista',
      'Violoncelista',
      'Guitarrista',
      'Baixista',
      'Violonista',
      'Harpista'
    ],
    'Teclas': ['Pianista', 'Tecladista', 'Organista', 'Sanfoneiro'],
    'Sopros': [
      'Flautista',
      'Saxofonista',
      'Trompetista',
      'Trombonista',
      'Clarinetista',
      'Oboísta'
    ],
    'Percussão': ['Baterista', 'Percussionista', 'Timpanista', 'Xilofonista'],
  };

  @override
  void initState() {
    super.initState();
    _carregarDadosDoUsuario();
    setState(() {});
  }

  Future<void> _carregarDadosDoUsuario() async {
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
        _youtube = userData['youtube'];

        description.text = _description;
        category.text = _category;
        release.text = _release;
        city.text = _city;
        lastReleases.text = _lastReleases;
        instagram.text = _instagram;
        youtube.text = _youtube;
      });
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  final description = TextEditingController();
  final release = TextEditingController();
  final category = TextEditingController();
  final city = TextEditingController();
  final lastReleases = TextEditingController();
  final instagram = TextEditingController();
  final youtube = TextEditingController();

  Future<void> _completarPerfil() async {
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
      youtube: youtube.text.trim(),
      city: city.text.trim(),
      category: category.text,
    );
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NavigationMenu(navPage: 3),
    ));
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
            backgroundColor: Color.fromARGB(255, 3, 141, 77),
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
              "Atualizar perfil",
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
              SearchGoogleCity(cityController: city),
              SizedBox(height: 26),
              TypeAheadField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: category,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Categoria',
                    prefixIcon: Icon(Iconsax.music),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return options.values.expand((e) => e).where(
                      (e) => e.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    selectedMusician = suggestion;
                    category.text = suggestion;
                  });
                },
                noItemsFoundBuilder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Categoria não encontrada",
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                },
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
              SizedBox(height: 26),
              TextFormField(
                controller: youtube,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Iconsax.video),
                  labelText: "YouTube",
                  hintText: "/@SeuCanal",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      )),
    );
  }
}
