import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Heart extends StatelessWidget {
  final DatabaseService database;
  final QuestModel questModel;
  final bool isLikedByUser;

  Heart({
    @required this.isLikedByUser,
    @required this.database,
    @required this.questModel,
  })  : assert(questModel != null),
        assert(database != null),
        assert(isLikedByUser != null);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          isLikedByUser ? Icons.favorite : Icons.favorite_border,
          color: isLikedByUser ? Colors.redAccent : Colors.white,
          size: 35,
        ),
        onPressed: () {
          isLikedByUser
              ? database.arrayRemove(questModel.id)
              : database.arrayUnion(questModel.id);
        });
  }


}
