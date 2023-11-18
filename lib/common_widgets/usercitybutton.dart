import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/searchgooglecity.dart';
import 'package:freegig_app/data/services/user_data_service.dart';
import 'package:iconsax/iconsax.dart';

class UserCityButton extends StatefulWidget {
  const UserCityButton({super.key});

  @override
  State<UserCityButton> createState() => _UserCityButtonState();
}

class _UserCityButtonState extends State<UserCityButton> {
  final cityController = TextEditingController();
  late String _city;

  @override
  void initState() {
    super.initState();
    _city = '';
    _carregarDadosDoUsuario();
  }

  Future<void> _carregarDadosDoUsuario() async {
    try {
      Map<String, dynamic> userData = await UserDataService().getProfileData();

      setState(() {
        _city = userData['city'];
      });
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 230, 230, 230),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Alterar cidade'),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _city = 'Brasil';
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('Todo o Brasil'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('Pesquisar por cidade'),
                        SizedBox(height: 10),
                        SearchGoogleCity(cityController: cityController)
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            _city = cityController.text;
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text('Selecionar'))
                    ],
                  ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.location5,
                size: 18,
                color: Colors.black,
              ),
              Flexible(
                child: Text(' ' + _city,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
