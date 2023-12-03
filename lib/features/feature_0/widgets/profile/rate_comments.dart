import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/rate_profile_rater.dart';

class UserRateComments extends StatefulWidget {
  final List<String> comments;
  final List<String> raterId;
  final String formatedRate;
  UserRateComments({
    super.key,
    required this.comments,
    required this.raterId,
    required this.formatedRate,
  });

  @override
  State<UserRateComments> createState() => _UserRateCommentsState();
}

class _UserRateCommentsState extends State<UserRateComments> {
  @override
  Widget build(BuildContext context) {
    // Filtra os comentários não vazios
    List<String> nonEmptyComments =
        widget.comments.where((comment) => comment.isNotEmpty).toList();

    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Fechar',
              style: TextStyle(color: Colors.black),
            ))
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('Avaliações')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 35,
              ),
              SizedBox(width: 10),
              Text(
                widget.formatedRate,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
            ],
          ),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              nonEmptyComments.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: nonEmptyComments.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GetProfileRater(
                            profileUid: widget.raterId[index],
                            comments: '"${nonEmptyComments[index]}"',
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Sem avaliações disponíveis.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
