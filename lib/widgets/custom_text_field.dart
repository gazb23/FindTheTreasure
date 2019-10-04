import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;

  CustomTextField({this.labelText, this.keyboardType, this.obscureText = false, this.controller});
  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      child: TextField(
        controller: controller,
        cursorColor: Colors.orangeAccent,        
        keyboardType: keyboardType,
        obscureText: obscureText,
        // textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }
}
