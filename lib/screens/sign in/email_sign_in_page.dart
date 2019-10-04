import 'package:find_the_treasure/widgets/custom_list_view.dart';
import 'package:find_the_treasure/widgets/custom_text_field.dart';
import 'package:find_the_treasure/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';

import 'password_reset.dart';

class ExistingAccount extends StatelessWidget {
  static const String id = 'existing_account';
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
        CustomListView(
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            CustomTextField(
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              labelText: 'Password',
              obscureText: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            SignInButton(
              text: 'Sign in',
              textcolor: Colors.white,
              color: Colors.orangeAccent,
              onPressed: () {
                // Log into main screen
              },
            ),
            
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, PasswordReset.id);
              },
              child: Text(
                'Forgotten Password?',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        )
      ],
    );
  }
}
