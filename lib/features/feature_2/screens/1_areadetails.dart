import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/searchgooglecity.dart';
import 'package:freegig_app/features/feature_2/screens/2_listgigs.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class AreaDetails extends StatefulWidget {
  const AreaDetails({super.key});

  @override
  _AreaDetailsState createState() => _AreaDetailsState();
}

class _AreaDetailsState extends State<AreaDetails> {
  final dataformat = DateFormat("dd-MM-yyyy");
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NavigationMenu()));
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Procurar uma GIG',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 19.0,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: [
                SizedBox(height: 12),
                Text(
                  "Encontre todas as GIGs disponíveis para o seu Free",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),

                ///Pesquisa de endereco
                SearchGoogleCity(cityController: _cityController),
                SizedBox(height: 15),

                ///Data
                DateTimeField(
                  decoration: InputDecoration(
                    labelText: 'Data',
                    prefixIcon: Icon(Iconsax.calendar),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  format: dataformat,
                  onShowPicker: (context, currentValue) async {
                    final now = DateTime.now();
                    final tomorrow = DateTime(now.year, now.month, now.day + 1);
                    return await showDatePicker(
                      context: context,
                      firstDate: tomorrow,
                      initialDate: currentValue ?? tomorrow,
                      lastDate: DateTime(2100),
                    );
                  },
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ListGigs()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      "Encontrar GIGs",
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
