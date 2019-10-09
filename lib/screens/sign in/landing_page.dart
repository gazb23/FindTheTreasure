import 'package:find_the_treasure/screens/home/home_page.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_in_main.dart';

class LandingPage extends StatelessWidget {
  // id is a named route for the main()
  static const String id = 'landing_page';
  @override
  
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInMain();
            }
            //If user is !null
            return HomePage();
            // If waiting for data from Firebase return a progress indicator
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
