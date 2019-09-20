import 'package:find_the_treasure/screens/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sign_in_main.dart';

class LandingPage extends StatefulWidget {
  static const String id = 'landing_page';
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FirebaseUser _user;
  void _updateUser(FirebaseUser user) {
    setState(() {
     _user = user; 
    });
  }
  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInMain(
        onSignIn: _updateUser,
      );
    }
    return HomePage(
      onSignOut: () => _updateUser(null),
    ); 
  }
}
