import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Heart extends StatelessWidget {
  final DatabaseService database;
  final QuestModel questModel;  
  final List likedByCopy;
  final bool isLikedByUser;

  Heart({
    
    @required this.likedByCopy,
    @required this.isLikedByUser,
    @required this.database,
    @required this.questModel,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          isLikedByUser ? Icons.favorite : Icons.favorite_border,
          color: isLikedByUser ? Colors.redAccent : Colors.white,
          size: 35,
        ),
        onPressed: () {
          
            if (isLikedByUser) {
              likedByCopy.remove(database.uid);

              addQuestData(context, likedByCopy);
            } else {
              likedByCopy.add(database.uid);
              addQuestData(context, likedByCopy);
            }
          
        });
  }

  Future<void> addQuestData(BuildContext context, List likedByCopy) async {
    try {
      await database.updateUserLikedQuests(
          documentId: questModel.id,
          questModel: QuestModel(
            likedBy: likedByCopy,
            id: questModel.id,
            description: questModel.description,
            difficulty: questModel.difficulty,
            image: questModel.image,
            location: questModel.location,
            numberOfDiamonds: questModel.numberOfDiamonds,
            numberOfKeys: questModel.numberOfKeys,
            numberOfLocations: questModel.numberOfLocations,
            tags: questModel.tags,
            title: questModel.title,
          ));
    } catch (e) {
      print(e.toString());
    }
  }
}
