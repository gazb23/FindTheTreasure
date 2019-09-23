import 'package:find_the_treasure/screens/home/home_page.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/material.dart';
import 'sign_in_main.dart';

class LandingPage extends StatelessWidget {
  // id is a named route for the main()
  static const String id = 'landing_page';

  final AuthBase auth;
  LandingPage({@required this.auth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInMain(
                auth: auth,
                
              );
            }
            //If user is !null
            return HomePage(
              auth: auth,
              
            );
            // If waiting from data from Firebase return a progress indicator
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
