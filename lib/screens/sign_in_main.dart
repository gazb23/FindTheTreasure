import 'package:flutter/material.dart';
import 'package:find_the_treasure/widgets/rounded_button.dart';
import 'package:flutter/services.dart';


class SignInMain extends StatelessWidget {
  
  @override
  
  Widget build(BuildContext context) {
    
    // Lock this screen to portrait orientation
    SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Image.asset(
              'assets/images/4.0x/slide_1.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RoundedButton(
                  color: Colors.lightBlue,
                  title: 'Sign Up with PooBook',
                  onpressed: () {},
                ),
                RoundedButton(
                  color: Colors.redAccent,
                  title: 'Sign Up with Google',
                  onpressed: () {},
                ),
                RoundedButton(
                  color: Colors.orangeAccent,
                  title: 'Create an Account',
                  onpressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
