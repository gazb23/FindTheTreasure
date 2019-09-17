import 'package:find_the_treasure/screens/sign_in_main.dart';
import 'package:flutter/material.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find The Treasure',
        home: SignInMain()
        );
  
  }
}
