import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/Shop/screens/shop_screen.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/view_models/leaderboard_view_model.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/quests/challenge_platform_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeViewModel {
  // Challenge incorrect logic - if a question is answered incorrectly a pre-calculated amount of diamonds will be subtracted from the users total amount of diamonds.

  void answerIncorrect({
    @required BuildContext context,
  }) async {
    final UserData _userData = Provider.of<UserData>(context, listen: false);
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    // How many diamonds to subtract for an incorrect answer
    const int _diamonds = 1;
    final int updatedDiamonds = _userData.userDiamondCount - _diamonds;
    
    final UserData _updateUserData = UserData(
      userDiamondCount: _userData.userDiamondCount - _diamonds,
      userKeyCount: _userData.userKeyCount,
      points: LeaderboardViewModel.calculatePoints(updatedDiamonds: updatedDiamonds, updatedKeys: _userData.userKeyCount),
      displayName: _userData.displayName,
      email: _userData.email,
      photoURL: _userData.photoURL,
      uid: _userData.uid,
    );

    _databaseService.updateUserDiamondAndKey(userData: _updateUserData);
  }

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
    final int _hintCost = 5;
    
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
    } else if (!questionsModel.hintPurchasedBy.contains(_databaseService.uid) && _userData.userDiamondCount >= _hintCost) {
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
            points: LeaderboardViewModel.calculatePoints(updatedDiamonds: _userData.userDiamondCount, updatedKeys: _userData.userKeyCount),
            displayName: _userData.displayName,
            email: _userData.email,
            photoURL: _userData.photoURL,
            uid: _userData.uid,
          );

          _databaseService.updateUserDiamondAndKey(userData: _updateUserData);
          _databaseService.arrayUnionField(
            documentId: questionsModel.id,
            uid: _databaseService.uid,
            field: 'hintPurchasedBy',
            collectionRef: APIPath.challenges(questId: questModel.id, locationId: locationModel.id),
          );

         
        }  
        
        
        catch (e) {
          print(e.toString());
        }
      }
    } else if (!questionsModel.hintPurchasedBy.contains(_databaseService.uid) && _userData.userDiamondCount < _hintCost) {
      final didRequestHint = await ChallengePlatformAlertDialog(
        title: 'Hint Purchase',
        backgroundColor: Colors.brown,
        textColor: Colors.white,
        content:
            'Having trouble with the challenge? I can give ya a hint but it\'ll cost ya $_hintCost diamonds. Head to the store to purchase more.',
        defaultActionText: 'Store',
        cancelActionText: 'Cancel',
        image: Image.asset('images/ic_out_of_gems.png'),
      ).show(context);
      if (didRequestHint) {
        Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShopScreen(),
        ));
      }
    }
  }
}
