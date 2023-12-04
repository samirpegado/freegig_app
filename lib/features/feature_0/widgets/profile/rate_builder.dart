import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/rate_comments.dart';
import 'package:freegig_app/services/relationship/user_rate.dart';
import 'package:iconsax/iconsax.dart';

class RatingStreamBuilder extends StatefulWidget {
  final String profileUid;

  const RatingStreamBuilder({super.key, required this.profileUid});
  @override
  State<RatingStreamBuilder> createState() => _RatingStreamBuilderState();
}

class _RatingStreamBuilderState extends State<RatingStreamBuilder> {
  double media = 0;
  List<String> comments = [];
  List<String> raterId = [];
  String total = '';

  @override
  void initState() {
    super.initState();
    _loadRatingData();
  }

  Future<void> _loadRatingData() async {
    try {
      Map<String, dynamic> rateData =
          await UserRateService().getUserRatingData(widget.profileUid);

      setState(() {
        media = rateData['media'];
        comments = rateData['comentarios'];
        total = rateData['total'];
        raterId = rateData['avaliadorId'];
      });
    } catch (e) {
      print("Erro ao carregar dados da avaliação: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String mediaFormatada = media.toStringAsFixed(1);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => UserRateComments(
                        comments: comments,
                        raterId: raterId,
                        formatedRate: mediaFormatada,
                      ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    media > 0
                        ? '$mediaFormatada/5.0 - $total ${total == '1' ? 'Avaliação' : 'Avaliações'} '
                        : '* Nenhuma avaliação',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Icon(
                  Iconsax.arrow_right_3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
