import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/material.dart';
import 'screens/sign in/email_create_account_page.dart';
import 'screens/sign in/email_sign_in_page.dart';
import 'screens/sign in/landing_page.dart';
import 'screens/sign in/password_reset.dart';
import 'screens/sign in/sign_in_main.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      builder: (context) => Auth(),
      child: MaterialApp(
        title: 'Find The Treasure',
        theme: _buildThemeData(),
        initialRoute: LandingPage.id,
        routes: {
          // Each screen class has a static const to create that screen
          SignInMain.id: (context) => SignInMain(),
          EmailCreateAccountPage.id: (context) => EmailCreateAccountPage(),
          EmailSignInPage.id: (context) => EmailSignInPage(),
          PasswordReset.id: (context) => PasswordReset(),
          LandingPage.id: (context) => LandingPage(),
        },
      ),
    );
  }

// Theme for the app
  ThemeData _buildThemeData() {
    return ThemeData(
        buttonTheme: ButtonThemeData(
          height: 45.0,
        ),
        textTheme: TextTheme(
            body1: TextStyle(fontSize: 17.0, color: Colors.grey[500])),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500])),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent)),
          labelStyle: TextStyle(color: Colors.grey[500]),
        ),
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.white));
  }
}
