import 'package:find_the_treasure/presentation/account/screens/account_screen.dart';
import 'package:find_the_treasure/presentation/sign_in/screens/email_create_account_screen.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/sign_in/screens/email_sign_in_screen.dart';
import 'presentation/sign_in/landing_page.dart';
import 'presentation/sign_in/screens/password_reset_screen.dart';
import 'presentation/sign_in/screens/sign_in_main_screen.dart';
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
          SignInMainScreen.id: (context) => SignInMainScreen(),
          EmailCreateAccountScreen.id: (context) => EmailCreateAccountScreen(),
          EmailSignInScreen.id: (context) => EmailSignInScreen(),
          PasswordResetScreen.id: (context) => PasswordResetScreen(),
          LandingPage.id: (context) => LandingPage(),
          AccountScreen.id : (context) => AccountScreen(),
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
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 22.0,
            fontWeight: FontWeight.w500
          ),
          contentTextStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 18.0,
          )
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
