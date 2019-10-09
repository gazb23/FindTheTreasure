import 'package:find_the_treasure/screens/sign%20in/email_sign_in_form.dart';

import 'package:flutter/material.dart';



class EmailSignInPage extends StatelessWidget {
  static const String id = 'email_sign_in_page';


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
          'Sign In',
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
                image: AssetImage("images/bckgrnd.png"), fit: BoxFit.cover),
          ),
        ),
        EmailSignInForm()
      ],
    );
  }
}
