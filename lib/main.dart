import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/material.dart';
import 'screens/sign in/create_account.dart';
import 'screens/sign in/existing_account.dart';
import 'screens/sign in/landing_page.dart';
import 'screens/sign in/password_reset.dart';
import 'screens/sign in/sign_in_main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find The Treasure',
      theme: _buildThemeData(),
      initialRoute: LandingPage.id,
      routes: {
        // Each screen class has a static const to create that screen
        SignInMain.id : (context) => SignInMain(auth: Auth(),),
        CreateAccount.id : (context) => CreateAccount(),
        ExistingAccount.id : (context) => ExistingAccount(),
        PasswordReset.id : (context) => PasswordReset(),
        LandingPage.id : (context) => LandingPage(auth: Auth(),),
      },
    );
  }



// Theme for the app
  ThemeData _buildThemeData() {
    return ThemeData(
      buttonTheme: ButtonThemeData(
        height: 45.0,                         
      ),
      textTheme: TextTheme(
        body1: TextStyle(
          fontSize: 17.0,
          color: Colors.grey[500]
        )
      ),
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
