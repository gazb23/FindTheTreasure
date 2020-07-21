
import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color color;

  const CustomCircularProgressIndicator({Key key, this.color = Colors.white}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color),

      );

    
  }
}