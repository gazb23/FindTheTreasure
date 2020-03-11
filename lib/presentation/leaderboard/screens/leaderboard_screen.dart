import 'package:find_the_treasure/models/user_location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final userLocation = Provider.of<UserLocation>(context);
    final double locationLatitude = -26.6779; 
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Center(child: Image.asset('images/andicon.png', height: 50,)),
        ),
        floatingActionButton: FloatingActionButton(onPressed: 
        () {

        },
        child: Icon(Icons.location_searching),
        backgroundColor: Colors.orangeAccent,),
        body: Stack(
          children: <Widget>[
            Container(            
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background_games.png"),
                    fit: BoxFit.fill),
              ),
            ),
            Center(child: Text('latitude: ${userLocation.latitude}, longitude: ${userLocation.longitude}')),
            
          ],
          
        ),
        
      ),
    );
    
  }
}
