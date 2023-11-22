import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/musicianonlyselectionform.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/features/feature_2/screens/1_listgigs.dart';
import 'package:iconsax/iconsax.dart';

class UserCategoryButton extends StatefulWidget {
  final String city;
  final String category;
  const UserCategoryButton(
      {super.key, required this.city, required this.category});

  @override
  State<UserCategoryButton> createState() => _UserCategoryButtonState();
}

class _UserCategoryButtonState extends State<UserCategoryButton> {
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
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Alterar categoria'),
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
                            _category = 'Todos';
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ListGigs(
                                  dataListFunction: GigsDataService()
                                      .getCityActiveUserGigsStream(
                                          city: _city, category: _category),
                                  city: _city,
                                  category: _category,
                                ),
                              ),
                            );
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
                            if (categoryController.text.isEmpty) {
                              Navigator.of(context).pop();
                            } else {
                              _category = categoryController.text;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ListGigs(
                                    dataListFunction: GigsDataService()
                                        .getCityActiveUserGigsStream(
                                            city: _city, category: _category),
                                    city: _city,
                                    category: _category,
                                  ),
                                ),
                              );
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
