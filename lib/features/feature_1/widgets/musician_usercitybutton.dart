import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/widgets/search_list_city.dart';

import 'package:freegig_app/features/feature_1/screens/1_listmusicians.dart';
import 'package:freegig_app/services/search/search_service.dart';
import 'package:iconsax/iconsax.dart';

class UserCityButtonProfile extends StatefulWidget {
  final String city;
  final String category;
  const UserCityButtonProfile(
      {super.key, required this.city, required this.category});

  @override
  State<UserCityButtonProfile> createState() => _UserCityButtonProfileState();
}

class _UserCityButtonProfileState extends State<UserCityButtonProfile> {
  final _searchService = SearchService();
  final cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _city = widget.city;
    String _category = widget.category;
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
                    title: Text('Alterar cidade'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _city = 'Brasil';
                            navigationFadeTo(
                                context: context,
                                destination: ListMusicians(
                                  profileListFunction:
                                      _searchService.getAvalibleProfiles(
                                          category: _category, city: _city),
                                  city: _city,
                                  category: _category,
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Todo o Brasil',
                              style: TextStyle(color: Colors.white),
                            ),
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
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Fechar',
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () {
                            if (cityController.text.isEmpty) {
                              Navigator.of(context).pop();
                            } else {
                              _city = cityController.text;
                              navigationFadeTo(
                                  context: context,
                                  destination: ListMusicians(
                                    profileListFunction:
                                        _searchService.getAvalibleProfiles(
                                            category: _category, city: _city),
                                    city: _city,
                                    category: _category,
                                  ));
                            }
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
