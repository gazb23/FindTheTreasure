import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback onPressed;
  final double bottomPadding;
  final double padding;

  CustomRaisedButton({
    this.child,
    this.color,
    this.onPressed,
    this.bottomPadding,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ?? 10),
      child: RaisedButton(
        elevation: 1.0,
        color: color ?? Colors.orangeAccent,
        child: child,
        onPressed: onPressed,
        padding: EdgeInsets.all(padding ?? 10),
        shape: StadiumBorder(),
      ),
    );
  }
}
