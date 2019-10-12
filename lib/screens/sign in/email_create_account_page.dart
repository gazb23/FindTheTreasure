import 'package:find_the_treasure/screens/sign%20in/email_create_account_form.dart';


import 'package:flutter/material.dart';

class EmailCreateAccountPage extends StatelessWidget {
  static const String id = 'create_account';
  
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
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _buildStack(context),
    );
  }

  Widget _buildStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bckgrnd.png"), fit: BoxFit.cover),
          ),
        ),
        EmailCreateAccountForm.create(context),
      ],
    );
  }
}
