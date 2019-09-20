import 'package:find_the_treasure/screens/create_account.dart';
import 'package:find_the_treasure/screens/existing_account.dart';
import 'package:find_the_treasure/widgets/sign_in_button.dart';
import 'package:find_the_treasure/widgets/social_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInMain extends StatelessWidget {
  static const String id = 'sign_in_main';
  @override
  Widget build(BuildContext context) {
    // Lock this screen to portrait orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/andicon.png'),
        ),
      ),
      backgroundColor: Colors.white,
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
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
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SocialSignInButton(
                assetName: 'images/facebook-logo.png',
                text: 'Sign in with Facebook',
                textcolor: Colors.white,
                color: Color(0xFF4267B2),
                onPressed: () {},
              ),
              SizedBox(
                height: 10.0,
              ),
              SocialSignInButton(
                assetName: 'images/google-logo.png',
                text: 'Sign in with Google',
                textcolor: Colors.black87,
                color: Colors.grey[100],
                onPressed: () {},
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  'OR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              SignInButton(
                text: 'Sign in with email',
                textcolor: Colors.white,
                color: Colors.orangeAccent,
                onPressed: () {
                  Navigator.pushNamed(context, CreateAccount.id);
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ExistingAccount.id);
                },
                child: Text(
                  'Already registered? Sign in here.',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
        )
      ],
    );
  }
}
