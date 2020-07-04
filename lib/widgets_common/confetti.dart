

import 'package:confetti/confetti.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class Confetti extends StatefulWidget {
   static const String id = 'confetti';
  @override
  _ConfettiState createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> {
  ConfettiController _controllerCenter;


  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
   _controllerCenter.play();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    return Scaffold(
      backgroundColor: Colors.amberAccent,
          body: Stack(
        children: <Widget>[
          Positioned(
            top: 50,
            left: 10,
                      child: Text('Congratualtions ' + userData.displayName, style: TextStyle(
              color: Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,),
          ),
          //CENTER -- Blast
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              minBlastForce: 10,
              numberOfParticles: 30,
              particleDrag: 0.1,
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  true, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.lightBlue,                
                Colors.orangeAccent,
                Colors.redAccent
              ], // manually specify the colors to be used
            ),
          ),
       
        ],
      ),
    );
  }

 
  
}