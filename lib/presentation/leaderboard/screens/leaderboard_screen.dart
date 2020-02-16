
import 'package:find_the_treasure/services/google_maps_display.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Center(child: Image.asset('images/andicon.png', height: 50,)),
        ),
        body: Stack(
          children: <Widget>[
            Container(            
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background_games.png"),
                    fit: BoxFit.fill),
              ),
            ),
            GoogleMapsDisplay()
          ],
          
        ),
        
      ),
    );
  }
}
