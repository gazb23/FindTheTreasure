import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/Shop/screens/shop_screen.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/view_models/leaderboard_view_model.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/quests/challenge_platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LocationViewModel extends ChangeNotifier {

  // When all LOCATIONS for a given QUEST have been completed, add the user UID to questCompletedBy. Also provide some visual feedback for the user.
  void submitQuestConquered(
    BuildContext context, {
    @required bool lastLocationCompleted,
    @required QuestModel questModel,
  }) async {
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final UserData userData = Provider.of<UserData>(context, listen: false);
    if (!questModel.questCompletedBy.contains(userData.uid) &&
        lastLocationCompleted) {
      final int updatedDiamondCount =
          userData.userDiamondCount + questModel.bountyDiamonds;
      final int updatedKeyCount = userData.userKeyCount + questModel.bountyKeys;

      final UserData _userData = UserData(
        userDiamondCount: updatedDiamondCount,
        locationsExplored: userData.locationsExplored,
        userKeyCount: updatedKeyCount,
        points: LeaderboardViewModel.questComplete(
          userData: userData,
          questModel: questModel,
        ),
        displayName: userData.displayName,
        email: userData.email,
        photoURL: userData.photoURL,
        uid: userData.uid,
      );
      try {
        // Add UID to quest completed by
        final questCompleted = _databaseService.arrayUnionField(
            documentId: questModel.id,
            field: 'questCompletedBy',
            collectionRef: APIPath.quests());

        // Remove UID from questStartedBy
        final questStartedBy = _databaseService.arrayRemoveField(
            documentId: questModel.id,
            field: 'questStartedBy',
            collectionRef: APIPath.quests());
        // Update User Data
        final updateUserData =
            _databaseService.updateUserData(userData: _userData);
        List<Future> futures = [questCompleted, questStartedBy, updateUserData];
        await Future.wait(futures);
       Navigator.pop(context);
        final didCompleteQuest = await PlatformAlertDialog(
          backgroundColor: Colors.amberAccent,
          contentTextColor: Colors.black87,
          title: 'Quest Conquered!',
          content:
              'Well done, you\'ve conquered  ${questModel.title}! For your troubles here\'s ${questModel.bountyDiamonds} ${diamondPluralCount(questModel.bountyDiamonds)} and ${questModel.bountyKeys} ${keyPluralCount(questModel.bountyKeys)} for your treasure chest.',
          defaultActionText: 'Oh Yeah!',
          image: Image.asset('images/ic_treasure.png'),
        ).show(context);

        if (didCompleteQuest) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (e) {
        print(e.toString());
      }
    } else if (questModel.questCompletedBy.contains(userData.uid)) {
      return null;
    }
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
        databaseService.arrayUnionField(
            documentId: locationModel.id,
            field: 'locationDiscoveredBy',
            collectionRef: APIPath.locations(questId: questModel.id));

        final didDiscoverLocation = await ChallengePlatformAlertDialog(
          backgroundColor: Colors.amberAccent,
          title: 'Location Discovered!',
          content:
              'Well done, you\'ve found ${locationModel.title} and unlocked the challenges! ',
          defaultActionText: 'Continue',
          image: Image.asset(
            'images/2.0x/ic_avatar_pirate.png',
            height: 100,
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
      final didNotDiscoverLocation = await PlatformAlertDialog(
        backgroundColor: Colors.white,
        title: 'Close, but no cigar!',
        content: 'Head to ${locationModel.title} to unlock the challenges! ',
        defaultActionText: 'OK',
        image: Image.asset(
          'images/ic_owl_wrong_dialog.png',
        ),
      ).show(context);

      if (didNotDiscoverLocation) {}
    }
  }

  // LOGIC to show HINT for a location question
  void showHint({
    @required BuildContext context,
    @required LocationModel locationModel,
    @required QuestModel questModel,
  }) async {
    final UserData _userData = Provider.of<UserData>(context, listen: false);
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    // Cost of a hint
    final int _hintCost = 5;

    //Show snackBar hint if the user has purchased it
    if (locationModel.hintPurchasedBy.contains(_databaseService.uid)) {
      final snackBar = SnackBar(
        content: Text(
          'HINT: ${locationModel.hint}',
          style: TextStyle(fontSize: 18, fontFamily: 'Quicksand'),
        ),
        duration: Duration(seconds: 20),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else if (!locationModel.hintPurchasedBy.contains(_databaseService.uid) &&
        _userData.userDiamondCount >= _hintCost) {
      final didRequestHint = await PlatformAlertDialog(
        title: 'Purchase Hint',
        content:
            'Having trouble with the challenge? I can give ya a hint but it\'ll cost ya $_hintCost diamonds from your treasure bounty!',
        defaultActionText: 'Purchase Hint',
        cancelActionText: 'Cancel',
        image: Image.asset('images/ic_out_of_gems.png'),
      ).show(context);
      if (didRequestHint) {
        try {
          final UserData _updateUserData = UserData(
            userDiamondCount: _userData.userDiamondCount - _hintCost,
            userKeyCount: _userData.userKeyCount,
            points: _userData.points,
            displayName: _userData.displayName,
            email: _userData.email,
            photoURL: _userData.photoURL,
             isAdmin: _userData.isAdmin,
            locationsExplored: _userData.locationsExplored,
            uid: _userData.uid,
          );

          _databaseService.updateUserData(userData: _updateUserData);
          _databaseService.arrayUnionField(
            documentId: locationModel.id,
            field: 'hintPurchasedBy',
            collectionRef: APIPath.locations(questId: questModel.id),
          );
          notifyListeners();
        } catch (e) {
          print(e.toString());
        }
      }
    } else if (!locationModel.hintPurchasedBy.contains(_databaseService.uid) &&
        _userData.userDiamondCount < _hintCost) {
      final didRequestHint = await PlatformAlertDialog(
        title: 'Hint Purchase',
        backgroundColor: Colors.brown,
        contentTextColor: Colors.white,
        titleTextColor: Colors.white,
        content:
            'Having trouble with the challenge? I can give ya a hint but it\'ll cost ya $_hintCost diamonds. Head to the store to purchase more.',
        defaultActionText: 'Store',
        cancelActionText: 'Cancel',
        image: Image.asset('images/ic_out_of_gems.png'),
      ).show(context);
      if (didRequestHint) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShopScreen(),
        ));
      }
    }
  }
}

// String Plurals for diamond/s and key/s
diamondPluralCount(int howMany) =>
    Intl.plural(howMany, one: 'diamond', other: 'diamonds');
keyPluralCount(int howMany) => Intl.plural(howMany, one: 'key', other: 'keys');
