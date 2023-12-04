import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:freegig_app/classes/city_list.dart';
import 'package:iconsax/iconsax.dart';

class SearchGoogleCity extends StatefulWidget {
  final TextEditingController cityController;

  const SearchGoogleCity({Key? key, required this.cityController})
      : super(key: key);

  @override
  State<SearchGoogleCity> createState() => _SearchGoogleCityState();
}

class _SearchGoogleCityState extends State<SearchGoogleCity> {
  List<String> cityList = CityList().cityList;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.cityController,
        decoration: InputDecoration(
          labelText: "Cidade",
          prefixIcon: Icon(Iconsax.global),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
      suggestionsCallback: (pattern) async {
        if (pattern.length >= 3) {
          // Retorna a lista cityList filtrada pelo padrão
          return cityList
              .where(
                  (city) => city.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        } else {
          // Retorna uma lista vazia se o padrão não tiver pelo menos 3 caracteres
          return [];
        }
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        setState(() {
          widget.cityController.text = suggestion;
        });
      },
      noItemsFoundBuilder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "...",
            style: TextStyle(fontSize: 22),
          ),
        );
      },
    );
  }
}
