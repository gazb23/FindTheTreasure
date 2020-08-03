import 'package:find_the_treasure/theme.dart';
import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback onPressed;
 
  final double padding;

  CustomRaisedButton({
    this.child,
    this.color,
    this.onPressed,    
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      
      elevation: 1.0,
      color: color ?? MaterialTheme.orange,
      child: child,
      onPressed: onPressed,
      padding: EdgeInsets.all(padding ?? 10),
      shape: StadiumBorder(),
    );
  }
}
