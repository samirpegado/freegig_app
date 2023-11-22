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
  TextEditingController _textController = TextEditingController();
  String? selectedMusician;

  void _showSelectionDialog() async {
    Map<String, List<String>> musicianCategories = {
      'Voz': ['Vocalista', 'Backing Vocal'],
      'Cordas': [
        'Guitarrista',
        'Baixista',
        'Violonista',
        'Violinista',
        'Violoncelista',
        'Harpista',
      ],
      'Teclas': ['Pianista', 'Tecladista', 'Organista', 'Sanfoneiro'],
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
                      _textController.text = selectedMusician!;
                      widget.categoryController.text = _textController.text;
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
