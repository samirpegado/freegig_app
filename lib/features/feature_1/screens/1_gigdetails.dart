import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:freegig_app/features/feature_1/screens/2_listmusicians.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';
import 'package:freegig_app/common_widgets/formatcurrency.dart';
import 'package:freegig_app/common_widgets/searchgoogleaddress.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class GigDetails extends StatefulWidget {
  @override
  _GigDetailsState createState() => _GigDetailsState();
}

class _GigDetailsState extends State<GigDetails> {
  final TextEditingController _fixeddateController = TextEditingController();
  final TextEditingController _cacheController = TextEditingController();
  final TextEditingController _initTimeController = TextEditingController();
  final TextEditingController _finalTimeController = TextEditingController();

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

                ///Pesquisa de endereco
                SearchGoogleAddress(),
                SizedBox(height: 15),

                ///Hora de inicio e término
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DateTimeField(
                        controller: _initTimeController,
                        decoration: InputDecoration(
                          labelText: 'Início',
                          prefixIcon: Icon(Iconsax.clock),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        format: hourformat,
                        onShowPicker: (context, currentValue) async {
                          final timeInicio = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          setState(() {
                            startTime = DateTimeField.convert(timeInicio);
                            _initTimeController.text = startTime.toString();
                          });
                          return DateTimeField.convert(timeInicio);
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: DateTimeField(
                        controller: _finalTimeController,
                        decoration: InputDecoration(
                          labelText: 'Término',
                          prefixIcon: Icon(Iconsax.clock),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        format: hourformat,
                        initialValue:
                            startTime, // Defina o valor inicial do campo de término com o valor do campo de início.
                        onShowPicker: (context, currentValue) async {
                          final timeTermino = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ??
                                (startTime ??
                                    DateTime
                                        .now())), // Use startTime se estiver definido.
                          );
                          setState(() {
                            endTime = DateTimeField.convert(timeTermino);
                            _finalTimeController.text = endTime.toString();
                          });
                          return DateTimeField.convert(timeTermino);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                ///Data e cache
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
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
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _cacheController,
                        onChanged: (value) {
                          setState(() {
                            _cacheController.text =
                                FormatCurrency().formatCurrency(value);
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Cachê',
                          prefixIcon: Icon(Iconsax.money),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                ///Mais detalhes
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Mais detalhes da sua GIG...\nLocal, evento, estilo de música...',
                    labelText: "Detalhes",
                    prefixIcon: Icon(Iconsax.device_message),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),

                ///Botao
                SizedBox(height: 35),
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
