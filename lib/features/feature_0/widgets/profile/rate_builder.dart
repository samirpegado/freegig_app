import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/rate_comments.dart';
import 'package:freegig_app/services/relationship/user_rate.dart';
import 'package:iconsax/iconsax.dart';

class RatingStreamBuilder extends StatelessWidget {
  final String profileUid;

  const RatingStreamBuilder({Key? key, required this.profileUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: UserRateService().getUserRatingData(profileUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erro: ${snapshot.error}"));
        } else {
          Map<String, dynamic> rateData = snapshot.data!;

          double media = rateData['media'];
          String mediaFormatada = media.toStringAsFixed(1);
          List<String> comments = rateData['comentarios'];
          List<String> raterId = rateData['avaliadorId'];
          String total = rateData['total'];

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
                      ),
                    );
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
      },
    );
  }
}
