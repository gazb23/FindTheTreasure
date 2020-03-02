import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'custom_circular_progress_indicator_button.dart';

class Avatar extends StatelessWidget {
  final String photoURL;
  final double radius;

  const Avatar({Key key, this.photoURL, this.radius}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 8.0
        )
      ),
      child: CachedNetworkImage(
        imageUrl: photoURL,
        placeholder: (context, url) => CustomCircularProgressIndicator(),
        imageBuilder: (context, image) =>
              CircleAvatar(
          radius: radius,
          backgroundColor: Colors.black12,
          backgroundImage: photoURL != null ? image : null,
          child: photoURL == null ? Icon(Icons.camera_alt, size: radius) : null,
        ),
      ),
    );
  }
}