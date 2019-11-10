
import 'package:find_the_treasure/widgets_common/quests/quest_list_view.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          centerTitle: true,          
          title: FlatButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                content: Text('You clicked me'),
                title: Text('TREASURE!!'),
              )
            ),
            child: Image.asset('images/ic_treasure.png')),
        ),
        body: Stack(
          children: <Widget>[
            Container(            
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/bckgrnd.png"),
                    fit: BoxFit.cover),
              ),
            ),
            QuestListView(),
          ],
        ),
      ),
    );
  }
}
