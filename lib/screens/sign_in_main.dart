import 'package:find_the_treasure/screens/create_account.dart';
import 'package:find_the_treasure/screens/existing_account.dart';
import 'package:flutter/material.dart';
import 'package:find_the_treasure/widgets/rounded_button.dart';
import 'package:flutter/services.dart';

class SignInMain extends StatelessWidget {
  static const String id = 'sign_in_main';
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
              'images/slide_1.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            //TODO: Implement a carosel slider using a dart package
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RoundedButton(
                  color: Colors.lightBlue,
                  title: 'Sign Up with PooBook',
                  onpressed: null,
                ),
                RoundedButton(
                  color: Colors.redAccent,
                  title: 'Sign Up with Google',
                  onpressed: null,
                ),
                RoundedButton(
                  color: Colors.orangeAccent,
                  title: 'I\'m new hear!',
                  onpressed: () {
                    Navigator.pushNamed(context, CreateAccount.id);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ExistingAccount.id);
                  },
                  child: Text(
                    'Already registered? Login Here.',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
