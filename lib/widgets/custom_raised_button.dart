import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback onPressed;
  final double height;
  CustomRaisedButton({
    this.child,
    this.color,
    this.onPressed,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      
      child: RaisedButton(
        elevation: 1.0,
        color: color,
        child: child,
        onPressed: onPressed,
        shape: StadiumBorder(),
      ),
    );
  }
}
