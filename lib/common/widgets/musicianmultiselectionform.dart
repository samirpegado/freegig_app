import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MusicianMultiSelectionForm extends StatefulWidget {
  final TextEditingController categoryController;

  const MusicianMultiSelectionForm(
      {super.key, required this.categoryController});
  @override
  _MusicianMultiSelectionFormState createState() =>
      _MusicianMultiSelectionFormState();
}

class _MusicianMultiSelectionFormState
    extends State<MusicianMultiSelectionForm> {
  Map<String, Set<String>> selectedMusiciansByCategory = {};

  void _showSelectionDialog() async {
    Map<String, List<String>> musicianCategories = {
      'Populares': [
        'Vocalista',
        'Guitarrista',
        'Baixista',
        'Violonista',
        'Tecladista',
        'Sanfoneiro',
        'Baterista',
        'Percussionista',
        'Saxofonista',
        'Violinista',
      ],
      'Diversos': [
        'Flautista',
        'Violoncelista',
        'Harpista',
        'Pianista',
        'Organista',
        'Clarinetista',
        'Oboísta',
        'Trompetista',
        'Trombonista',
        'Timpanista',
        'Xilofonista',
      ],
      'Outros': ['Banda'],
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
                        initiallyExpanded: category == 'Populares',
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

                      widget.categoryController.text =
                          selectedMusicians.join(', ');

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
/*
  @override
  void dispose() {
    widget.categoryController.dispose();

    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.categoryController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Categoria inválida.';
        } else {
          return null;
        }
      },
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
