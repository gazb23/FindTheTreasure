import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/Shop/screens/shop_screen.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/view_models/leaderboard_view_model.dart';
import 'package:find_the_treasure/view_models/question_view_model.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeViewModel {
  // Challenge incorrect logic - if a question is answered incorrectly a pre-calculated amount of points will be subtracted from the users total amount.

  void answerIncorrect({
    @required BuildContext context,
    @required QuestModel questModel,
    Duration duration,
  }) async {
    final UserData _userData = Provider.of<UserData>(context, listen: false);
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);

    final UserData _updateUserData = UserData(
        userDiamondCount: _userData.userDiamondCount,
        userKeyCount: _userData.userKeyCount,
        points: LeaderboardViewModel.questionIncorrect(
            questModel: questModel, userData: _userData),
        displayName: _userData.displayName,
        email: _userData.email,
        photoURL: _userData.photoURL,
        uid: _userData.uid,
        isAdmin: _userData.isAdmin,
        locationsExplored: _userData.locationsExplored);

    await _databaseService.updateUserData(userData: _updateUserData);

    final snackBar = SnackBar(
      duration: duration ?? Duration(seconds: 4),
      backgroundColor: Colors.redAccent,
      content: AutoSizeText(
        'Answer incorrect. You lost: ${LeaderboardViewModel.showPointsLost(userData: _userData, questModel: questModel)} points ',
        maxLines: 1,
        style: TextStyle(
            fontSize: 18, fontFamily: 'Quicksand', color: Colors.white),
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

// Logic to show hint for a challenge question
  static void showHint({
    @required BuildContext context,
    @required QuestionsModel questionsModel,
    @required LocationModel locationModel,
    @required QuestModel questModel,
  }) async {
    final UserData _userData = Provider.of<UserData>(context, listen: false);
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    // Cost of a hint
    final int _hintCost = questModel.hintCost;

    //Show snackBar hint if the user has purchased it
    if (questionsModel.hintPurchasedBy.contains(_databaseService.uid)) {
      final snackBar = SnackBar(
        content: Text(
          'HINT: ${questionsModel.hint}',
          style: TextStyle(fontSize: 18, fontFamily: 'Quicksand'),
        ),
        duration: Duration(seconds: 20),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else if (!questionsModel.hintPurchasedBy.contains(_databaseService.uid) &&
        _userData.userDiamondCount >= _hintCost) {
      final didRequestHint = await PlatformAlertDialog(
        title: 'Purchase Hint',
        content:
            'Having trouble with the challenge? I can give ya a hint but it\'ll cost $_hintCost diamonds from your treasure bounty!',
        defaultActionText: 'Purchase Hint',
        backgroundColor: Colors.brown,
        contentTextColor: Colors.white,
        titleTextColor: Colors.white,
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
              uid: _userData.uid,
              isAdmin: _userData.isAdmin,
              locationsExplored: _userData.locationsExplored);

          _databaseService.updateUserData(userData: _updateUserData);
          _databaseService.arrayUnionField(
            documentId: questionsModel.id,
            field: 'hintPurchasedBy',
            collectionRef: APIPath.challenges(
                questId: questModel.id, locationId: locationModel.id),
          );
        } catch (e) {
          print(e.toString());
        }
      }
      //If the user does not have enough diamonds, send them to the store
    } else if (!questionsModel.hintPurchasedBy.contains(_databaseService.uid) &&
        _userData.userDiamondCount < _hintCost) {
      final didRequestHint = await PlatformAlertDialog(
        title: 'Purchase Hint',
        backgroundColor: Colors.brown,
        contentTextColor: Colors.white,
        titleTextColor: Colors.white,
        content:
            'Having trouble with the challenge? I can give ya a hint but it\'ll cost $_hintCost diamonds. Head to the store to purchase more.',
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

  // Logic to show SKIP for a challenge
  static void showChallengeSkip({
    @required BuildContext context,
    @required QuestionsModel questionsModel,
    @required LocationModel locationModel,
    @required QuestModel questModel,
  }) async {
    final UserData _userData = Provider.of<UserData>(context, listen: false);
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    // Cost of a skip
    final int _skipCost = questModel.skipCost;

    //Show snackBar hint if the user has purchased it
    if (_userData.userDiamondCount >= _skipCost) {
      final didRequestSkip = await PlatformAlertDialog(
        title: 'Purchase Skip',
        content:
            'Having trouble with the challenge? I can let ya a skip but it\'ll cost $_skipCost diamonds from your treasure bounty!',
        defaultActionText: 'Purchase Skip',
        backgroundColor: Colors.brown,
        contentTextColor: Colors.white,
        titleTextColor: Colors.white,
        cancelActionText: 'Cancel',
        image: Image.asset('images/ic_out_of_gems.png'),
      ).show(context);
      if (didRequestSkip) {
        try {
          final UserData _updateUserData = UserData(
              userDiamondCount: _userData.userDiamondCount - _skipCost,
              userKeyCount: _userData.userKeyCount,
              points: _userData.points,
              displayName: _userData.displayName,
              email: _userData.email,
              photoURL: _userData.photoURL,
              uid: _userData.uid,
              isAdmin: _userData.isAdmin,
              locationsExplored: _userData.locationsExplored);

          _databaseService.updateUserData(userData: _updateUserData);
          _databaseService.arrayUnionField(
            documentId: questionsModel.id,
            field: 'challengeCompletedBy',
            collectionRef: APIPath.challenges(
                questId: questModel.id, locationId: locationModel.id),
          );
  TODO:// work out how to remove the ability to skip the last question of a challenge
          Navigator.pop(context);

          final _didRequestNext = await PlatformAlertDialog(
            title: 'Congratulations!',
            content: questionsModel.challengeCompletedMessage ??
                'You\'ve completed the challenge!',
            cancelActionText: 'Not Now',
            defaultActionText: 'Next challenge',
            image: Image.asset(
              'images/owl_thumbs.png',
            ),
            // isLoading: false,
          ).show(context);
          if (_didRequestNext) {
            Navigator.pop(context);
          } else {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        } catch (e) {
          print(e.toString());
        }
      }
      //If the user does not have enough diamonds, send them to the store
    } else if (_userData.userDiamondCount < _skipCost) {
      final didRequestSkip = await PlatformAlertDialog(
        title: 'Purchase Skip',
        backgroundColor: Colors.brown,
        contentTextColor: Colors.white,
        titleTextColor: Colors.white,
        content:
            'Having trouble with the challenge? I can let ya skip but it\'ll cost $_skipCost diamonds. Head to the store to purchase more.',
        defaultActionText: 'Store',
        cancelActionText: 'Cancel',
        image: Image.asset('images/ic_out_of_gems.png'),
      ).show(context);
      if (didRequestSkip) {
        Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => ShopScreen(),
        ));
      }
    }
  }
}
