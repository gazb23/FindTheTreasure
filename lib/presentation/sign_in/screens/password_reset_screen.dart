import 'package:find_the_treasure/presentation/sign_in/widgets/password_reset_form.dart';

import 'package:flutter/material.dart';



class PasswordResetScreen extends StatelessWidget {
  static const String id = 'password_reset';
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _buildStack(context),
    );
  }

  Stack _buildStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bckgrnd_frgt.png"),
                fit: BoxFit.cover),
          ),
        ),
        PasswordResetForm.create(context)
      ],
    );
  }
}
