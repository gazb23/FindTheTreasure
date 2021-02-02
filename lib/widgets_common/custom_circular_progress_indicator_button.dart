import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color color;
  final int height;
  final int width;

  const CustomCircularProgressIndicator(
      {Key key, this.color = Colors.white, this.height, this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 20,
      width: width ?? 20,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
