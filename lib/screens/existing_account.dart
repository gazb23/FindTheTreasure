import 'package:find_the_treasure/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

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
          'Log In',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
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
                      children: <Widget>[
                        Text('Use your email and password used in registration process',
                        textAlign: TextAlign.center,),
                        SizedBox(
                          height: 10.0,
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
                        RoundedButton(
                          color: Colors.orangeAccent,
                          title: 'Log In',
                          onpressed: () {},
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                  onTap: () {
                    // TODO: Add navigation to forgotten password screen.
                  },
                                  child: Text('Forgotten Password?',
                  textAlign: TextAlign.center,),
                ),
                SizedBox(height: 20.0,)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
