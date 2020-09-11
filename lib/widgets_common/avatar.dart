import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'custom_circular_progress_indicator_button.dart';

class Avatar extends StatelessWidget {
  final String photoURL;
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final VoidCallback onPressed;
  static const String _noImage =
      'https://firebasestorage.googleapis.com/v0/b/find-the-treasure-8d58f.appspot.com/o/ic_single.png?alt=media&token=3f9e2e42-8400-4f33-b483-9dfb0d9f72e7';
  const Avatar({
    Key key,
    @required this.photoURL,
    @required this.radius,
    this.borderWidth,
    this.borderColor,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _borderDecoration(),
      child: CachedNetworkImage(
       
        imageUrl: photoURL == null || photoURL == '' ? _noImage : photoURL,
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: radius * 2,
        ),
        placeholderFadeInDuration: Duration(seconds: 1),
        fadeInDuration: Duration(seconds: 1),
        fadeOutDuration: Duration(seconds: 1),
        placeholder: (context, url) => Container(
            height: radius * 2,
            child: Center(child: CustomCircularProgressIndicator())),
        imageBuilder: (context, photoURL) => InkWell(
          onTap: onPressed,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.black12,
            backgroundImage: photoURL,
            child:
                photoURL == null ? Icon(Icons.camera_alt, size: radius) : null,
          ),
        ),
      ),
    );
  }

  Decoration _borderDecoration() {
    if (borderColor != null && borderWidth != null) {
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      );
    }
    return null;
  }
}
