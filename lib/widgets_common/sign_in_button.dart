import 'package:find_the_treasure/widgets_common/custom_circular_progress_indicator_button.dart';
import 'package:find_the_treasure/widgets_common/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    bool isLoading = false,
    @required String text,    
    Color color,
    Color textcolor,
    double bottomPadding,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: !isLoading ? Text(
            
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(color: textcolor ?? Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600,),
          ) : CustomCircularProgressIndicator(),
          color: color,
          onPressed: onPressed,
          padding: bottomPadding

        );


}
