import 'package:cached_network_image/cached_network_image.dart';
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
              child: Image(
                image: CachedNetworkImageProvider(profileImageUrl),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: imageSize,
                    width: imageSize,
                    child: ClipOval(
                      child: Container(
                        color: Colors.grey[400],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : Container(
            height: imageSize,
            width: imageSize,
            child: ClipOval(
              child: Container(
                color: Colors.grey[400],
              ),
            ),
          );
  }
}
