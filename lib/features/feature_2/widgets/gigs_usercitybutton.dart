import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/widgets/search_list_city.dart';
import 'package:freegig_app/features/feature_2/screens/1_listgigs.dart';
import 'package:freegig_app/services/search/search_service.dart';
import 'package:iconsax/iconsax.dart';

class UserCityButtonGig extends StatefulWidget {
  final String city;
  final String category;
  const UserCityButtonGig(
      {super.key, required this.city, required this.category});

  @override
  State<UserCityButtonGig> createState() => _UserCityButtonGigState();
}

class _UserCityButtonGigState extends State<UserCityButtonGig> {
  final cityController = TextEditingController();
  final _searchService = SearchService();

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
                                destination: ListGigs(
                                  dataListFunction:
                                      _searchService.getAvalibleGigs(
                                          category: _category, city: _city),
                                  city: _city,
                                  category: _category,
                                ));
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
                                  destination: ListGigs(
                                    dataListFunction:
                                        _searchService.getAvalibleGigs(
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
