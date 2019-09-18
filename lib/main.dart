import 'package:find_the_treasure/screens/create_account.dart';
import 'package:find_the_treasure/screens/sign_in_main.dart';
import 'package:flutter/material.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find The Treasure',
      theme: ThemeData(        
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white
        )
      ),
        initialRoute: SignInMain.id,
        routes: {
          // Each screen class has a static const to create that screen
          SignInMain.id : (context) => SignInMain(),
          CreateAccount.id : (context) => CreateAccount(),
        },
        );
  
  }
}
