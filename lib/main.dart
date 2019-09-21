
import 'package:find_the_treasure/screens/sign%20in/landing_page.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/material.dart';
import 'screens/sign in/create_account.dart';
import 'screens/sign in/existing_account.dart';
import 'screens/sign in/password_reset.dart';
import 'screens/sign in/sign_in_main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find The Treasure',
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(
            fontSize: 16.0,
            color: Colors.grey
          )
        ),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orangeAccent)),
            
            labelStyle: TextStyle(color: Colors.grey),
          ),
          backgroundColor: Colors.white,
          appBarTheme: AppBarTheme(color: Colors.white)),
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
}
