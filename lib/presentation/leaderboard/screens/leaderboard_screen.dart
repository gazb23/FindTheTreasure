import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Center(child: Image.asset('images/andicon.png')),
        ),
        body: Stack(
          children: <Widget>[
            Container(            
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background_games.png"),
                    fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
