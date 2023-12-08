import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void navigationFadeTo({
  required BuildContext context,
  required Widget destination,
}) {
  Navigator.push(
    context,
    PageTransition(
      duration: Duration(milliseconds: 300),
      type: PageTransitionType.fade,
      child: destination,
    ),
  );
}
