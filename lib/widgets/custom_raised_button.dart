import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback onPressed;
  
  CustomRaisedButton({
    this.child,
    this.color,
    this.onPressed,    
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
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
