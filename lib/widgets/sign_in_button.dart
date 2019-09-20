import 'package:find_the_treasure/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textcolor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(color: textcolor, fontSize: 18.0),
          ),
          color: color,
          onPressed: onPressed,
        );
}
