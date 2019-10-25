import 'package:find_the_treasure/widgets_common/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String assetName,
    @required String text,
    Color color,
    Color textcolor,
    VoidCallback onPressed,
  })  : assert(assetName != null),
        assert(text != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(assetName),
              
              Text(
                text,
                style: TextStyle(
                  color: textcolor,
                  fontSize: 18.0,
                ),
              ),
              Opacity(opacity: 0.0, child: Image.asset(assetName)),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
