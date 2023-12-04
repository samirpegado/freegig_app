import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchGoogleAddress extends StatefulWidget {
  final TextEditingController addressController;

  const SearchGoogleAddress({Key? key, required this.addressController})
      : super(key: key);

  @override
  State<SearchGoogleAddress> createState() => _SearchGoogleAddressState();
}

class _SearchGoogleAddressState extends State<SearchGoogleAddress> {
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

        /// Remove a palavra "Brasil" da descrição
        placeList.forEach((place) {
          if (place.containsKey("description")) {
            place["description"] =
                place["description"].replaceAll(", Brasil", "");
          }
        });
      });
    } else {
      throw Exception("Falha ao carregar os dados");
    }
  }

  void onChange() {
    if (sessionToken.isEmpty) {
      sessionToken = uuid.v4();
    } else {
      getSuggestions(widget.addressController.text);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.addressController.addListener(() {
      onChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: widget.addressController,
            decoration: InputDecoration(
              labelText: "Local",
              hintText: "Local, endereço...",
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
              widget.addressController.text = suggestion;
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
}
