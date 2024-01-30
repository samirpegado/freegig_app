import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MusicianOnlySelectionForm extends StatefulWidget {
  final TextEditingController categoryController;

  const MusicianOnlySelectionForm({
    Key? key,
    required this.categoryController,
  }) : super(key: key);

  @override
  _MusicianOnlySelectionFormState createState() =>
      _MusicianOnlySelectionFormState();
}

class _MusicianOnlySelectionFormState extends State<MusicianOnlySelectionForm> {
  String? selectedMusician;

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
                            return RadioListTile<String>(
                              title: Text(musician),
                              value: musician,
                              groupValue: selectedMusician,
                              onChanged: (value) {
                                setState(() {
                                  selectedMusician = value;
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
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (selectedMusician != null) {
                      widget.categoryController.text = selectedMusician!;
                    }

                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.check,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    widget.categoryController.dispose();

    super.dispose();
  }

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
        labelText: 'Categoria',
        prefixIcon: Icon(Iconsax.music),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
