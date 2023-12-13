// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:freegig_app/classes/formatdate.dart';
import 'package:freegig_app/common/widgets/build_profile_image.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:freegig_app/services/archive/archive_service.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/archived_more_info.dart';
import 'package:iconsax/iconsax.dart';

class ArchivedGigs extends StatefulWidget {
  @override
  State<ArchivedGigs> createState() => _ArchivedGigsState();
}

class _ArchivedGigsState extends State<ArchivedGigs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'GIGs arquivadas',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.0,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: GigsArchived().getMyAllArchivedGigsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                } else {
                  List<Map<String, dynamic>> gigs = snapshot.data ?? [];

                  if (gigs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Center(
                        child: Text(
                          'Nenhuma gig encontrada',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: gigs.map((gig) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      ArchivedMoreInfo(gig: gig));
                            },
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Iconsax.archive,
                                      color: Colors.grey[500],
                                    ),
                                    SizedBox(width: 25),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            gig['gigDescription'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            FormatDate().formatDateString(
                                                    gig['gigDate']) +
                                                ', ' +
                                                gig['gigInitHour'],
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                          Text(
                                            gig['gigLocale'],
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 25),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        BuildProfileImage(
                                            profileImageUrl:
                                                gig['profileImageUrl'],
                                            imageSize: 40),
                                        SizedBox(width: 10),
                                        Icon(Iconsax.arrow_right_3)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
