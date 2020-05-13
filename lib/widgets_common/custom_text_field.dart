import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final Function onEditingComplete;
  final Function(String) onChanged;
  final String errorText;
  final bool enabled;
  final Widget suffixIcon;
  
  CustomTextField({this.labelText, this.keyboardType, this.obscureText = false, this.controller, this.textInputAction, this.focusNode, this.onEditingComplete, this.onChanged, this.errorText, this.enabled = true, this.suffixIcon, });
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
        onChanged: onChanged,
        
        textInputAction: textInputAction,       
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: labelText,
          errorText: errorText,
          enabled: enabled,
        ),
      ),
    );
  }
}
