import 'package:flutter/material.dart';

class BuildProfileImage extends StatelessWidget {
  final String profileImageUrl;
  final double imageSize;
  const BuildProfileImage(
      {super.key, required this.profileImageUrl, required this.imageSize});

  @override
  Widget build(BuildContext context) {
    return profileImageUrl.isNotEmpty
        ? Container(
            height: imageSize,
            width: imageSize,
            child: ClipOval(
              child: Image.network(
                profileImageUrl,
                fit: BoxFit.cover,
                width: imageSize,
                height: imageSize,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Container(
                    height: imageSize,
                    width: imageSize,
                    child: CircleAvatar(
                      radius: imageSize / 2,
                      backgroundImage:
                          AssetImage('assets/profiles/default-user-image.png'),
                    ),
                  );
                },
              ),
            ),
          )
        : Container(
            height: imageSize,
            width: imageSize,
            child: CircleAvatar(
              radius: imageSize / 2,
              backgroundImage:
                  AssetImage('assets/profiles/default-user-image.png'),
            ),
          );
  }
}
