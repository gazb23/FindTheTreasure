import 'package:find_the_treasure/widgets_common/custom_list_view.dart';
import 'package:find_the_treasure/widgets_common/custom_text_field.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
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
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bckgrnd_frgt.png"),
                  fit: BoxFit.cover),
            ),
          ),
          CustomListView(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'images/ic_owl_wrong_dialog.png',
                  height: 120.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'If you\'ve forgotten your password already, good luck with the quests! No sweat - just enter your email below and we\'ll reset it.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.0,
              ),
              CustomTextField(
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20.0,
              ),
              SignInButton(
                text: 'Reset Password',
                textcolor: Colors.white,
                color: Colors.orangeAccent,
                onPressed: () {
                  //TODO: Password reset onpressed - add fx
                },
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
