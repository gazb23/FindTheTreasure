
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Heart extends StatefulWidget {
  final Function addQuest;
 

  Heart({Key key, this.addQuest}) : super(key: key);

  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> {
  Color _iconColor = Colors.white;
  IconData _iconType = Icons.favorite_border;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _iconType,
        color: _iconColor,
        size: 35,
      ),
      onPressed: () {
        setState(() {
          if (_iconType == Icons.favorite_border &&
              _iconColor == Colors.white) {
            _iconType = Icons.favorite;
            _iconColor = Colors.redAccent;

            _addQuestData(context);
          } else {
            _iconColor = Colors.white;
            _iconType = Icons.favorite_border;
          }
        });
      },
    );
  } 
  
  
  
  
  
  
  
  
  void _addQuestData(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);
    final quest = Provider.of<QuestModel>(context);

    database.userLikedQuest(
      {
        'title': quest.title,
        'difficulty': quest.difficulty,
        'image' : quest.image,
        'numberOfDiamonds': quest.numberOfDiamonds,
        'numberOfkeys': quest.numberOfKeys,
      }
    );
    
  }
}
