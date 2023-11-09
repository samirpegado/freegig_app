import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final Color colorCircle;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
    required this.colorCircle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(colorCircle),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = imagePath;

    return ClipOval(
      child: Image.asset(
        image,
        fit: BoxFit.cover,
        width: 128,
        height: 128,
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: colorCircle,
          all: 8,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
