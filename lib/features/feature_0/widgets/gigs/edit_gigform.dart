import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:freegig_app/classes/formatcurrency.dart';
import 'package:freegig_app/common/widgets/musicianmultiselectionform.dart';

import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class EditGigForm extends StatefulWidget {
  final String gigUid;

  const EditGigForm({Key? key, required this.gigUid}) : super(key: key);
  @override
  State<EditGigForm> createState() => _EditGigFormState();
}

class _EditGigFormState extends State<EditGigForm> {
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _cacheController = TextEditingController();
  final _categoryController = TextEditingController();
  final _detailsController = TextEditingController();
  final _initTimeController = TextEditingController();
  final _finalTimeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final hourformat = DateFormat("HH:mm");
  final dataformat = DateFormat("dd-MM-yyyy");

  bool isLoading = false;

  DateTime? startTime;
  DateTime? endTime;

  @override
  void initState() {
    _loadGigData();
    super.initState();
  }

  Future<void> _loadGigData() async {
    try {
      DocumentSnapshot gigSnapshot = await FirebaseFirestore.instance
          .collection('gigs')
          .doc(widget.gigUid)
          .get();

      if (gigSnapshot.exists) {
        var gigData = gigSnapshot.data() as Map<String, dynamic>;

        setState(() {
          List<dynamic> categorys = gigData['gigCategorys'];

          _descriptionController.text = gigData['gigDescription'];

          _categoryController.text =
              categorys.map((element) => '$element').join(", ");
          _dateController.text = gigData['gigDate'];
          _cacheController.text = gigData['gigCache'];
          _detailsController.text = gigData['gigDetails'];
          _initTimeController.text = gigData['gigInitHour'];
          _finalTimeController.text = gigData['gigFinalHour'];
        });
      }
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
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
                  "Editar GIG",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 15),

                TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Este campo é obrigatório.';
                    } else {
                      return null;
                    }
                  },
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

                ///Hora de inicio e término
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DateTimeField(
                        controller: _initTimeController,
                        validator: (value) {
                          if (value == null || value == "") {
                            return 'Hora inválida.';
                          } else {
                            return null;
                          }
                        },
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
                            builder: (context, child) => MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            ),
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
                        validator: (value) {
                          if (value == null || value == "") {
                            return 'Hora inválida.';
                          } else {
                            return null;
                          }
                        },
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
                      validator: (value) {
                        if (value == null || value == "") {
                          return 'Data inválida.';
                        } else {
                          return null;
                        }
                      },
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
                        readOnly: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Valor inválido.';
                          } else {
                            return null;
                          }
                        },
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
                          fillColor: Color.fromARGB(255, 238, 238, 238),
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Este campo é obrigatório.';
                    } else {
                      return null;
                    }
                  },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          await FirebaseFirestore.instance
                              .collection('gigs')
                              .doc(widget.gigUid)
                              .update({
                            'gigDescription': _descriptionController.text,
                            'gigInitHour': _initTimeController.text,
                            'gigFinalHour': _finalTimeController.text,
                            'gigDate': _dateController.text,
                            'gigCategorys':
                                _categoryController.text.split(', '),
                            'gigDetails': _detailsController.text,
                          });
                          setState(() {
                            isLoading = false;
                          });

                          Navigator.of(context).pop();
                        } else {
                          print('Deu merda');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                "Editar GIG",
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
              ],
            ),
          )),
    );
  }
}
