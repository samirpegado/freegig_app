import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/creategigs.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';

class GIGs extends StatelessWidget {
  const GIGs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'GIGs',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 19.0,
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        backgroundColor: backgroundColor,
        body: CreateGigs());
  }
}
