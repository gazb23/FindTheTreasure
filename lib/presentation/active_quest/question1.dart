import 'package:find_the_treasure/models/quest_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Question1 extends StatelessWidget {
  static const String id = 'question';
  @override
  
  Widget build(BuildContext context) {
    
    return Consumer<QuestModel>(
      builder: (context, questModel, _) => 
          Container(
        child: Text('${questModel.id}'),
      ),
    );
  }
}