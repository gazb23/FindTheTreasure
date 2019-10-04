import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final Function onEditingComplete;
  
  CustomTextField({this.labelText, this.keyboardType, this.obscureText = false, this.controller, this.textInputAction, this.focusNode, this.onEditingComplete, });
  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      child: TextField(
        controller: controller,
        cursorColor: Colors.orangeAccent,     
        onEditingComplete: onEditingComplete,
        focusNode: focusNode,   
        keyboardType: keyboardType,
        obscureText: obscureText,
        
        textInputAction: textInputAction,
        // textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }
}
