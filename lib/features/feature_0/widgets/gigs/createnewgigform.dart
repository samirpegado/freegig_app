import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freegig_app/common_widgets/formatcurrency.dart';
import 'package:freegig_app/common_widgets/musicianmultiselectionform.dart';
import 'package:freegig_app/common_widgets/searchgoogleaddress.dart';
import 'package:freegig_app/common_widgets/searchgooglecity.dart';
import 'package:freegig_app/data/services/gigs_data_services.dart';
import 'package:freegig_app/features/feature_0/navigation_menu.dart';

import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class CreateNewGig extends StatefulWidget {
  @override
  State<CreateNewGig> createState() => _CreateNewGigState();
}

class _CreateNewGigState extends State<CreateNewGig> {
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _dateController = TextEditingController();
  final _cacheController = TextEditingController();
  final _categoryController = TextEditingController();
  final _detailsController = TextEditingController();
  final _initTimeController = TextEditingController();
  final _finalTimeController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _dateController.dispose();
    _cacheController.dispose();
    _categoryController.dispose();
    _detailsController.dispose();
    _initTimeController.dispose();
    _finalTimeController.dispose();

    super.dispose();
  }

  final hourformat = DateFormat("HH:mm");
  final dataformat = DateFormat("dd-MM-yyyy");

  DateTime? startTime;
  DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 30,
                      ))
                ],
              ),

              Text(
                "Nova GIG",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  hintText: "Ex: Show no GIG Recepções",
                  prefixIcon: Icon(Iconsax.keyboard),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30)
                ], // Define o limite para 30 caracteres
              ),
              SizedBox(height: 15),
              SearchGoogleCity(
                cityController: _cityController,
              ),
              SizedBox(height: 15),
              SearchGoogleAddress(
                addressController: _addressController,
              ),
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
                      child: DateTimeField(
                    controller: _dateController,
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
                      return await showDatePicker(
                        context: context,
                        firstDate: now,
                        initialDate: currentValue ?? now,
                        lastDate: DateTime(2100),
                      );
                    },
                  )),
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
                        hintText: 'Por músico',
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
              MusicianMultiSelectionForm(
                categoryController: _categoryController,
              ),

              SizedBox(height: 15),

              ///Mais detalhes
              TextFormField(
                controller: _detailsController,
                maxLength: 150,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
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
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF274b99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  GigsDataService().createNewGig(
                    gigDescription: _descriptionController.text,
                    gigCity: _cityController.text,
                    gigAddress: _addressController.text,
                    gigInitHour: _initTimeController.text,
                    gigFinalHour: _finalTimeController.text,
                    gigDate: _dateController.text,
                    gigCache: _cacheController.text,
                    gigCategorys: _categoryController.text.split(', '),
                    gigDetails: _detailsController.text,
                  );
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NavigationMenu(navPage: 1)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    "Criar GIG",
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
    );
  }
}
