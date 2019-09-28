import 'package:find_the_treasure/widgets/custom_text_field.dart';
import 'package:find_the_treasure/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';



class CreateAccount extends StatelessWidget {
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
      body: _buildStack(),
    );
  }
  

  Widget _buildStack() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bckgrnd.png"), fit: BoxFit.cover),
          ),
        ),
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(25.0),
          children: <Widget>[
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 8.0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CustomTextField(
                        labelText: 'First Name',
                      ),
                      CustomTextField(
                        labelText: 'Last Name',
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
                        text: 'Sign up',
                        textcolor: Colors.white,
                        color: Colors.orangeAccent,
                        onPressed: () {
                          // Push to home screen
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
