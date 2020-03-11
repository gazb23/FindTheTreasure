import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/challenge_platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final UserData userData = Provider.of<UserData>(context);
    if (!questModel.questCompletedBy.contains(_databaseService.uid) &&
        lastLocationCompleted) {
      try {
        await _databaseService.arrayUnionField(
            documentId: questModel.id,
            uid: _databaseService.uid,
            field: 'questCompletedBy',
            collectionRef: APIPath.quests());
        await _databaseService.arrayRemoveField(
            documentId: questModel.id,
            uid: _databaseService.uid,
            field: 'questStartedBy',
            collectionRef: APIPath.quests());

        final didCompleteLocation = await ChallengePlatformAlertDialog(
          backgroundColor: Colors.amberAccent,
          title: 'Quest Conquered!',
          content:
              'Well done, you\'ve conquered  ${questModel.title}! For your troubles here\'s ${questModel.bountyDiamonds} ${diamondPluralCount(questModel.bountyDiamonds)} and ${questModel.bountyKeys} ${keyPluralCount(questModel.bountyKeys)} for your treasure chest',
          defaultActionText: 'Oh Yeah!',
          image: Image.asset('images/ic_treasure.png'),
        ).show(context);
        if (didCompleteLocation) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          final UserData _userData = UserData(
          userDiamondCount:
              userData.userDiamondCount + questModel.bountyDiamonds,
          userKeyCount: userData.userKeyCount + questModel.bountyKeys,
          displayName: userData.displayName,
          email: userData.email,
          photoURL: userData.photoURL,
          uid: userData.uid,
        );
        await _databaseService.updateUserDiamondAndKey(userData: _userData);
        }
      } catch (e) {
        print(e.toString());
      } 
    } else
      return null;
  }
}

// String Plurals for diamond/s and key/s
diamondPluralCount(int howMany) =>
    Intl.plural(howMany, one: 'diamond', other: 'diamonds');
keyPluralCount(int howMany) => Intl.plural(howMany, one: 'key', other: 'keys');
