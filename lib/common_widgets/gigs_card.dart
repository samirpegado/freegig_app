import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CommonGigsCard extends StatefulWidget {
  final Color moneyColor;
  final Map<String, dynamic> gig;
  const CommonGigsCard(
      {super.key, required this.gig, required this.moneyColor});

  @override
  State<CommonGigsCard> createState() => _CommonGigsCardState();
}

class _CommonGigsCardState extends State<CommonGigsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 240,
                  child: Text(
                    widget.gig['gigDescription'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Iconsax.money_recive5,
                      size: 20.0,
                      color: widget.moneyColor,
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      child: Text(
                        widget.gig['gigCache'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.music5,
                      size: 14.0,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: 240,
                      child: Text(
                        "${widget.gig['gigCategorys'].join(', ')}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Iconsax.location5,
                      size: 14.0,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.gig['gigLocale'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.calendar5,
                                size: 14.0,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 4),
                              Text(
                                widget.gig['gigDate'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Iconsax.clock5,
                                size: 14.0,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${widget.gig['gigInitHour']} - ${widget.gig['gigFinalHour']}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            widget.gig['publicName'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(width: 8),
                          ClipOval(
                            child: Image.network(
                              widget.gig['profileImageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
