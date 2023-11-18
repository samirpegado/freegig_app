import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/searchgooglecity.dart';
import 'package:freegig_app/data/services/profiles_data_service.dart';
import 'package:freegig_app/features/feature_1/screens/1_listmusicians.dart';
import 'package:iconsax/iconsax.dart';

class UserCityButtonProfile extends StatefulWidget {
  final String city;
  const UserCityButtonProfile({super.key, required this.city});

  @override
  State<UserCityButtonProfile> createState() => _UserCityButtonProfileState();
}

class _UserCityButtonProfileState extends State<UserCityButtonProfile> {
  final cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _city = widget.city;
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ListMusicians(
                                    profileListFunction: ProfileDataService()
                                        .getAllActiveUserProfile(),
                                    city: _city),
                              ),
                            );
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
                          onPressed: () {
                            _city = cityController.text;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ListMusicians(
                                    profileListFunction: ProfileDataService()
                                        .getCityActiveUserProfile(_city),
                                    city: _city),
                              ),
                            );
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
