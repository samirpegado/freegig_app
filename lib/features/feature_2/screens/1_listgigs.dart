import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_2/widgets/gigs_usercategorybutton.dart';
import 'package:freegig_app/features/feature_2/widgets/gigs_usercitybutton.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/features/feature_2/widgets/gigs_descriptioncard.dart';
import 'package:freegig_app/common/functions/themeapp.dart';
import 'package:freegig_app/services/search/search_service.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ListGigs extends StatefulWidget {
  final Stream<List<Map<String, dynamic>>> dataListFunction;
  final String city;
  final String category;
  const ListGigs(
      {super.key,
      required this.dataListFunction,
      required this.city,
      required this.category});

  @override
  State<ListGigs> createState() => _ListGigsState();
}

class _ListGigsState extends State<ListGigs> {
  final _dateController = TextEditingController();
  final _searchService = SearchService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.dataListFunction;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NavigationMenu()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'GIGs disponíveis',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 19.0,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                openFilter(context, _dateController, widget.city,
                    widget.category, _searchService);
              },
              icon: Icon(
                Iconsax.setting_4,
                color: Colors.black,
              ),
            )
          ],
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: UserCityButtonGig(
                      city: widget.city,
                      category: widget.category,
                    ),
                  ),
                  Expanded(
                    child: UserCategoryButton(
                        city: widget.city, category: widget.category),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GigsCard(
                        dataListFunction: widget.dataListFunction,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future openFilter(context, TextEditingController dateController, String city,
        String category, SearchService searchService) =>
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Filtrar"),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  ExpansionTile(
                    title: Text('Cachê'),
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ListGigs(
                                  dataListFunction:
                                      searchService.getAvalibleGigs(
                                    cache: 'decreasing',
                                    category: category,
                                    city: city,
                                  ),
                                  city: city,
                                  category: category,
                                ),
                              ),
                            );
                          },
                          child: Text('Maior para o menor')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ListGigs(
                                  dataListFunction:
                                      searchService.getAvalibleGigs(
                                    cache: 'increasing',
                                    category: category,
                                    city: city,
                                  ),
                                  city: city,
                                  category: category,
                                ),
                              ),
                            );
                          },
                          child: Text('Menor para o maior')),
                    ],
                  ),
                  SizedBox(height: 10),
                  DateTimeField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Data',
                      prefixIcon: Icon(Iconsax.calendar),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    format: DateFormat("dd-MM-yyyy"),
                    onShowPicker: (context, currentValue) async {
                      final now = DateTime.now();
                      return await showDatePicker(
                        context: context,
                        firstDate: now,
                        initialDate: currentValue ?? now,
                        lastDate: DateTime(2100),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ListGigs(
                          dataListFunction: searchService.getAvalibleGigs(
                              category: category,
                              city: city,
                              data: dateController.text),
                          city: city,
                          category: category,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.check,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
