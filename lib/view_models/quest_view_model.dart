import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/active_quest/quest_completed_screen.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'leaderboard_view_model.dart';

class QuestViewModel {
  // Logic for when the treasure is discovered

  static void submitTreasureDiscovered({
    @required BuildContext context,
    @required DatabaseService databaseService,
    @required QuestModel questModel,
  }) async {
    if (!questModel.treasureDiscoveredBy.contains(databaseService.uid)) {
      final UserData userData = Provider.of<UserData>(context, listen: false);
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
          isAdmin: userData.isAdmin,
          seenIntro: true);
      try {
        // Update User Data
        final updateUserData =
            databaseService.updateUserData(userData: _userData);
        final treasureDiscovereBy = databaseService.arrayUnionField(
            documentId: questModel.id,
            field: 'treasureDiscoveredBy',
            collectionRef: APIPath.quests());
        List<Future> futures = [updateUserData, treasureDiscovereBy];
        Future.wait(futures);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    QuestCompletedScreen(questModel: questModel)));
      } catch (e) {
        print(e.toString());
      }
    }
  }

// If user cannot find the treasure and wishes to skip
  static void submitTreasureSkipped({
    @required BuildContext context,
    @required DatabaseService databaseService,
    @required QuestModel questModel,
  }) async {
    if (!questModel.treasureDiscoveredBy.contains(databaseService.uid)) {
      final UserData userData = Provider.of<UserData>(context, listen: false);
      final UserData _userData = UserData(
        userDiamondCount: userData.userDiamondCount,
        locationsExplored: userData.locationsExplored,
        userKeyCount: userData.userKeyCount,
        points: LeaderboardViewModel.questComplete(
          userData: userData,
          questModel: questModel,
        ),
        displayName: userData.displayName,
        email: userData.email,
        photoURL: userData.photoURL,
        uid: userData.uid,
        isAdmin: userData.isAdmin,
        seenIntro: true,
      );
      try {
        final updateUserData =
            databaseService.updateUserData(userData: _userData);
        final treasureDiscovereBy = databaseService.arrayUnionField(
            documentId: questModel.id,
            field: 'treasureDiscoveredBy',
            collectionRef: APIPath.quests());
        List<Future> futures = [updateUserData, treasureDiscovereBy];
        await Future.wait(futures);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    QuestCompletedScreen(questModel: questModel)));
      } catch (e) {
        print(e.toString());
      }
    }
  }

  // Logic for when a location is not discovered
  static Future<void> submitTreasureNotDiscovered({
    @required BuildContext context,
    @required DatabaseService databaseService,
    @required QuestModel questModel,
  }) async {
    if (!questModel.treasureDiscoveredBy.contains(databaseService.uid)) {
      final didNotDiscoverLocation = await PlatformAlertDialog(
        backgroundColor: Colors.white,
        title: 'Close, but no cigar!',
        content:
            'To unearth the treasure find the location depicted in the image. Tap the button when you have arrived.',
        defaultActionText: 'OK',
        image: Image.asset(
          'images/ic_owl_wrong_dialog.png',
        ),
      ).show(context);

      if (didNotDiscoverLocation) {}
    }
  }
}
