import 'package:find_the_treasure/widgets_common/quests/quest_list_view.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          centerTitle: true,
          title: FlatButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        content: Text('You clicked me'),
                        title: Text('TREASURE!!'),
                      )),
              child: Image.asset('images/ic_treasure.png')),
        ),
        body: 
        // Container(
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("images/bckgrnd.png"), fit: BoxFit.cover, ),
        //   ),
        //   child:
           ListView(
            children: <Widget>[
              QuestListView(
                title: 'Mountain Quest',
                image: AssetImage('images/explore/wild_mountain.jpg'),
                diamondCount: 50,
                difficultyColor: Colors.greenAccent,
                difficultyTitle: 'Easy',
                keyCount: 1,
              ),
              QuestListView(
                diamondCount: 125,
                difficultyColor: Colors.redAccent,
                difficultyTitle: 'Hard',
                image: AssetImage('images/explore/Coolum.jpg'),
                keyCount: 3,
                title: 'Beach Quest',
              ),
              QuestListView(
                diamondCount: 225,
                difficultyColor: Colors.orangeAccent,
                difficultyTitle: 'moderate',
                image: AssetImage('images/explore/alex_heads.jpg'),
                keyCount: 1,
                title: 'Ultimate Beach Quest',
              )
            ],
          ),
        ),
      
    );
  }
}
