import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/searchgooglecity.dart';
import 'package:freegig_app/features/feature_1/screens/2_listmusicians.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class GigDetails extends StatefulWidget {
  @override
  _GigDetailsState createState() => _GigDetailsState();
}

class _GigDetailsState extends State<GigDetails> {
  final _fixeddateController = TextEditingController();
  final _initTimeController = TextEditingController();
  final _cityController = TextEditingController();
  final hourformat = DateFormat("HH:mm");

  DateTime? startTime;
  DateTime? endTime;
  String getTodayFormated() {
    DateTime dataAtual = DateTime.now();
    return DateFormat("dd-MM-yyyy").format(dataAtual);
  }

  @override
  Widget build(BuildContext context) {
    _fixeddateController.text = getTodayFormated();

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NavigationMenu()));
        print(_initTimeController.text);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Procurar músicos',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 19.0,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        backgroundColor: backgroundColor,
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: [
                SizedBox(height: 12),
                Text(
                  "Encontre músicos para tocar com você hoje em uma GIG",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),

                SizedBox(height: 20),
                SearchGoogleCity(
                  cityController: _cityController,
                ),
                SizedBox(height: 15),

                TextField(
                  controller: _fixeddateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.calendar),
                    filled: true,
                    fillColor: backgroundColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),

                ///Botao
                SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF274b99),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListMusicians()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      "Encontrar músicos",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
