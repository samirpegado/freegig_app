import 'package:flutter/material.dart';
import 'package:freegig_app/services/relationship/user_rate.dart';

class MusicianRateNumber extends StatefulWidget {
  final String profileUid;

  const MusicianRateNumber({super.key, required this.profileUid});
  @override
  State<MusicianRateNumber> createState() => _MusicianRateNumberState();
}

class _MusicianRateNumberState extends State<MusicianRateNumber> {
  double media = 0;

  @override
  void initState() {
    super.initState();
    _loadRatingData();
  }

  Future<void> _loadRatingData() async {
    try {
      Map<String, dynamic> dados =
          await UserRateService().getUserRatingData(widget.profileUid);

      setState(() {
        media = dados['media'];
      });
    } catch (e) {
      print("Erro ao carregar dados da avaliação: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String mediaFormatada = media.toStringAsFixed(1);
    return Text(
      media > 0 ? mediaFormatada : 'N/A',
      style: TextStyle(color: Color.fromARGB(255, 80, 78, 78), fontSize: 14.0),
    );
  }
}
