import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/widgets/musicianonlyselectionform.dart';
import 'package:freegig_app/features/feature_1/screens/1_listmusicians.dart';
import 'package:freegig_app/services/search/search_service.dart';
import 'package:iconsax/iconsax.dart';

class MusicianCategoryButton extends StatefulWidget {
  final String city;
  final String category;
  const MusicianCategoryButton(
      {super.key, required this.city, required this.category});

  @override
  State<MusicianCategoryButton> createState() => _MusicianCategoryButtonState();
}

class _MusicianCategoryButtonState extends State<MusicianCategoryButton> {
  final _searchService = SearchService();
  final categoryController = TextEditingController();

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
                    title: Text('Alterar categoria'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _category = 'Todos';
                            navigationFadeTo(
                                context: context,
                                destination: ListMusicians(
                                    profileListFunction:
                                        _searchService.getAvalibleProfiles(
                                            city: _city, category: _category),
                                    city: _city,
                                    category: _category));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('Todas as Categorias'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('Pesquisar por categoria'),
                        SizedBox(height: 10),
                        MusicianOnlySelectionForm(
                            categoryController: categoryController)
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
                            if (categoryController.text.isEmpty) {
                              Navigator.of(context).pop();
                            } else {
                              _category = categoryController.text;

                              navigationFadeTo(
                                  context: context,
                                  destination: ListMusicians(
                                      profileListFunction:
                                          _searchService.getAvalibleProfiles(
                                              city: _city, category: _category),
                                      city: _city,
                                      category: _category));
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
                Iconsax.music5,
                size: 18,
                color: Colors.black,
              ),
              Flexible(
                child: Text(' ' + _category,
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
