import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/common/widgets/build_profile_image.dart';
import 'package:iconsax/iconsax.dart';

class MyGigsCardTile extends StatelessWidget {
  final Widget destination;
  final Widget leadingIcon;

  final Map<String, dynamic> gig;
  const MyGigsCardTile(
      {super.key,
      required this.destination,
      required this.gig,
      required this.leadingIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: InkWell(
        onTap: () {
          navigationFadeTo(context: context, destination: destination);
        },
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                leadingIcon,
                SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gig['gigDescription'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Text(
                        FormatDate().formatDateString(gig['gigDate']) +
                            ', ' +
                            gig['gigInitHour'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        gig['gigLocale'],
                        style: TextStyle(color: Colors.grey[600]),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 25),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BuildProfileImage(
                        profileImageUrl: gig['profileImageUrl'], imageSize: 40),
                    SizedBox(width: 10),
                    Icon(Iconsax.arrow_right_3)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
