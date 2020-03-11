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
        imageUrl: photoURL ?? 'https://firebasestorage.googleapis.com/v0/b/find-the-treasure-8d58f.appspot.com/o/ic_thnx.png?alt=media&token=b9d8b1f1-d36e-4013-ade6-d870eb6f7efa',
        placeholder: (context, url) => CustomCircularProgressIndicator(),
        imageBuilder: (context, photoURL) =>
              CircleAvatar(
          radius: radius,
          backgroundColor: Colors.black12,
          backgroundImage: photoURL != null ? photoURL : null,
          child: photoURL == null ? Icon(Icons.camera_alt, size: radius) : null,
        ),
      ),
    );
  }
}