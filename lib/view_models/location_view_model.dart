import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/challenge_platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationViewModel {


  // When all LOCATIONS for a given QUEST have been completed, add the user UID to questCompletedBy. Also provide some visual feedback for the user.

  static void submitQuestConquered(
    BuildContext context, {
    @required bool lastLocationCompleted,    
    @required QuestModel questModel,
  }) async {
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: true);

    if (!questModel.questCompletedBy.contains(_databaseService.uid) && lastLocationCompleted) {
      try {
       
        await _databaseService.arrayUnionField(
            documentId: questModel.id,
            uid: _databaseService.uid,
            field: 'questCompletedBy',
            collectionRef: APIPath.quests());
           
        final didCompleteLocation = await ChallengePlatformAlertDialog(
          title: 'Quest Conquered!',
          content:
              'Well done, you\'ve conquered  ${questModel.title}!',
          defaultActionText: 'OK',
          image: Image.asset('images/ic_excalibur_owl.png'),
        ).show(context);
        if (didCompleteLocation) {}
      } catch (e) {
        print(e.toString());
      }
    } else
      return null;
  }
}
