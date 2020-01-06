import 'package:find_the_treasure/widgets_common/quests/scroll.dart';
import 'package:flutter/material.dart';

class QuestStartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background_games.png',),
          fit: BoxFit.fill
        )
      ),
      child: Column(
        children: <Widget>[
          _buildPirateIntro(context),
        ],
      ),
    );
  }

  Widget _buildPirateIntro(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 125,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: Colors.brown,
            ),
            child: Center(
                child: Text(
                    'Ahoy me matey. This ancient scroll will lead you to where you need to be!',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Image.asset('images/pirate.png')),
        ]),
        SizedBox(
          height: 20,
        ),
        Scroll()
      ],
    );
  }
}
