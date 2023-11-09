import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchGoogleAddress extends StatefulWidget {
  static String selectedPlace = "";

  const SearchGoogleAddress({Key? key}) : super(key: key);

  @override
  State<SearchGoogleAddress> createState() => _SearchGoogleAddressState();
}

class _SearchGoogleAddressState extends State<SearchGoogleAddress> {
  final TextEditingController _searchController = TextEditingController();

  Uuid uuid = const Uuid();
  String sessionToken = "";
  List<dynamic> placeList = [];

  void getSuggestions(String input) async {
    String googleApiKey = dotenv.env['CHAVE_GOOGLE_API'].toString();
    String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =
        "$baseUrl?input=$input&key=$googleApiKey&sessiontoken=$sessionToken&components=country:BR&language=pt-BR";

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      setState(() {
        placeList = jsonDecode(response.body.toString())["predictions"];
      });
    } else {
      throw Exception("Falha ao carregar os dados");
    }
  }

  void onChange() {
    if (sessionToken.isEmpty) {
      sessionToken = uuid.v4();
    } else {
      getSuggestions(_searchController.text);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      onChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "Localização",
              hintText: "Local, endereço, cidade, estado...",
              prefixIcon: Icon(Iconsax.location),
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
          suggestionsCallback: (pattern) async {
            getSuggestions(pattern);
            return placeList.map((place) => place["description"]).toList();
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSuggestionSelected: (suggestion) {
            setState(() {
              SearchGoogleAddress.selectedPlace = suggestion;
              _searchController.text = suggestion;
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
        ),
      ],
    );
  }

  ///Código antigo sem usar o TypeAheadField
  /*
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "Endereço, região, local",
            prefixIcon: Icon(Iconsax.location),
            filled: true,
            fillColor: Colors.white,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        Visibility(
          visible: _searchController.text != SearchGoogleAddress.selectedPlace,
          child: Container(
            color: Colors.white,
            height: 300,
            child: ListView.builder(
              itemCount: placeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Colors.white,
                  selectedTileColor: Colors.grey,
                  title: Text(placeList[index]["description"]),
                  onTap: () {
                    setState(
                      () {
                        SearchGoogleAddress.selectedPlace =
                            placeList[index]["description"];
                        _searchController.text =
                            SearchGoogleAddress.selectedPlace;
                      },
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
  */
}
