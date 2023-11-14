import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MusicianSelectionForm extends StatefulWidget {
  final TextEditingController categoryController;

  const MusicianSelectionForm({super.key, required this.categoryController});
  @override
  _MusicianSelectionFormState createState() => _MusicianSelectionFormState();
}

class _MusicianSelectionFormState extends State<MusicianSelectionForm> {
  TextEditingController _textController = TextEditingController();
  Map<String, Set<String>> selectedMusiciansByCategory = {};

  void _showSelectionDialog() async {
    Map<String, List<String>> musicianCategories = {
      'Voz': ['Cantor', 'Cantora'],
      'Cordas': [
        'Guitarrista',
        'Baixista',
        'Violonista',
        'Violinista',
        'Violoncelista',
        'Harpista',
      ],
      'Teclas': ['Pianista', 'Tecladista', 'Organista'],
      'Sopros': [
        'Flautista',
        'Saxofonista',
        'Trompetista',
        'Trombonista',
        'Clarinetista',
        'Oboísta',
      ],
      'Percussão': ['Baterista', 'Percussionista', 'Timpanista', 'Xilofonista'],
    };

    // Inicialize os conjuntos para cada categoria
    for (var category in musicianCategories.keys) {
      if (!selectedMusiciansByCategory.containsKey(category)) {
        selectedMusiciansByCategory[category] = Set();
      }
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Escolha a categoria de músicos para sua GIG",
                style: TextStyle(fontSize: 18),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: List<Widget>.generate(
                    musicianCategories.length,
                    (index) {
                      var category = musicianCategories.keys.toList()[index];
                      return ExpansionTile(
                        title: Text(category),
                        children: List<Widget>.generate(
                          musicianCategories[category]!.length,
                          (j) {
                            var musician = musicianCategories[category]![j];
                            return CheckboxListTile(
                              title: Text(musician),
                              value: selectedMusiciansByCategory[category]!
                                  .contains(musician),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    selectedMusiciansByCategory[category]!
                                        .add(musician);
                                  } else {
                                    selectedMusiciansByCategory[category]!
                                        .remove(musician);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                    )),
                IconButton(
                    onPressed: () {
                      List<String> selectedMusicians = [];
                      selectedMusiciansByCategory
                          .forEach((category, musicians) {
                        selectedMusicians.addAll(musicians);
                      });
                      _textController.text = selectedMusicians.join(', ');
                      widget.categoryController.text = _textController.text;

                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.check,
                    )),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      readOnly: true,
      onTap: () {
        _showSelectionDialog();
      },
      decoration: InputDecoration(
        labelText: 'Categoria de músicos',
        prefixIcon: Icon(Iconsax.music),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
