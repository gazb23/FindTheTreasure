
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class LeaderboardScreen extends StatefulWidget {
  
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
 
  @override
  Widget build(BuildContext context) {
    
   
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Center(child: Image.asset('images/andicon.png', height: 50,)),
        ),
        floatingActionButton: FloatingActionButton(onPressed: 
        () {
          _getCurrentLocation();
    
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
           if (_currentPosition != null) 
           
            Center(child: Column(children: [
                Text(_currentPosition.latitude.toString()),
              Text(_currentPosition.longitude.toString()),
              Text('${(_currentPosition.latitude * 100).truncateToDouble() / 100}'),
              Text('${(_currentPosition.longitude * 100).truncateToDouble() / 100}'),
            
          
            ],),),
           
           
            
          ],
          
        ),
        
      ),
    );
    
  }
  _getCurrentLocation() {
    

    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
    .then((Position position) {
      setState(() {
        _currentPosition = position;
      
      });
     

    }).catchError((e) {
      print(e.toString());
    });
}

  
}

