

import 'package:find_the_treasure/models/location_model.dart';
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
        // Add UID to quest completed by
        _databaseService.arrayUnionField(
            documentId: questModel.id,
            uid: _databaseService.uid,
            field: 'questCompletedBy',
            collectionRef: APIPath.quests());
        // Remove UID from questStartedBy
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
          _databaseService.updateUserDiamondAndKey(userData: _userData);
        }
      } catch (e) {
        print(e.toString());
      }
    } else
      return null;
  }

// Logic for when a location is discovered
  static void submitLocationDiscovered({
    @required BuildContext context,
    @required LocationModel locationModel,
    @required DatabaseService databaseService,
    @required QuestModel questModel,
  }) async {
    if (!locationModel.locationDiscoveredBy.contains(databaseService.uid)) {
      try {
        // databaseService.arrayUnionField(
        //     documentId: locationModel.id,
        //     uid: databaseService.uid,
        //     field: 'locationDiscoveredBy',
        //     collectionRef: APIPath.locations(questId: questModel.id));

        final didDiscoverLocation = await ChallengePlatformAlertDialog(
          backgroundColor: Colors.amberAccent,
          title: 'Location Discovered!',
          content:
              'Well done, you\'ve found ${locationModel.title}and unlocked the challenges! ',
          defaultActionText: 'Continue',
          image: Image.asset(
            'images/2.0x/ic_avatar_pirate.png',
            height: 60,
          ),
        ).show(context);

        if (didDiscoverLocation) {}
      } catch (e) {}
    }
  }

  // Logic for when a location is not discovered
  static Future<void> submitLocationNotDiscovered({
    @required BuildContext context,
    @required LocationModel locationModel,
    @required DatabaseService databaseService,
    @required QuestModel questModel,
  }) async {
    if (!locationModel.locationDiscoveredBy.contains(databaseService.uid)) {
      
        final didNotDiscoverLocation = await ChallengePlatformAlertDialog(
          backgroundColor: Colors.white,
          title: 'Close, but no cigar!',
          content: 'Head to ${locationModel.title}to unlock the challenges! ',
          defaultActionText: 'OK',        
          image: Image.asset('images/ic_owl_wrong_dialog.png'),
        ).show(context);

        if (didNotDiscoverLocation) {}
      } 
    } 
  } 


// String Plurals for diamond/s and key/s
diamondPluralCount(int howMany) =>
    Intl.plural(howMany, one: 'diamond', other: 'diamonds');
keyPluralCount(int howMany) => Intl.plural(howMany, one: 'key', other: 'keys');
