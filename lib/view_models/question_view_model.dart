import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/challenge_platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionViewModel {
  // Logic for when an answer is submitted. If correct, will add UID to Firestore Database and display the correct PlatformAlertDialog.
  static void submit(
    BuildContext context, {
    @required bool isLocation,
    @required bool isFinalChallenge,
    @required String documentId,
    @required String collectionRef,
    @required String locationTitle,
  }) async {
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    // If Challenge Question
    if (!isLocation) {
      try {
        await _databaseService.arrayUnionField(
          documentId: documentId,
          uid: _databaseService.uid,
          field: 'challengeCompletedBy',
          collectionRef: collectionRef,
        );
        if (!isFinalChallenge) {
          final _didRequestNext = await ChallengePlatformAlertDialog(
            title: 'Congratulations!',
            content: 'You\'ve completed this challenge!',
            cancelActionText: 'Not Now',
            defaultActionText: 'Next challenge',
            image: Image.asset(
              'images/ic_excalibur_owl.png',
            ),
            isLoading: false,
          ).show(context);
          if (_didRequestNext) {
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        } else {
          Navigator.pop(context);
          await _databaseService.arrayUnionField(
            documentId: documentId,
            uid: _databaseService.uid,
            field: 'challengeCompletedBy',
            collectionRef: collectionRef,
          );
          
        }
      } catch (e) {
        print(e.toString());
      }
    } else
      // If Location Question
      try {
        await _databaseService.arrayUnionField(
          documentId: documentId,
          uid: _databaseService.uid,
          field: 'locationStartedBy',
          collectionRef: collectionRef,
        );
        final _didCompleteChallenge = await ChallengePlatformAlertDialog(
          title: 'Location Unlocked!',
          content:
              'Well done, you\'ve discovered  $locationTitle. Time for your next adventure!',
          defaultActionText: 'Start Challenge',
          image: Image.asset('images/ic_excalibur_owl.png'),
          isLoading: false,
        ).show(context);
        if (_didCompleteChallenge) {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      } catch (e) {
        print(e.toString());
      }
  }

  // When all CHALLENGES for a given LOCATION have been completed, add the user UID to locationCompletedBy. Also provide some visual feedback for the user.

  static void submitLocationConquered(
    BuildContext context, {
    @required bool lastChallengeCompleted,
    @required bool lastLocationCompleted,
    @required LocationModel locationModel,
    @required QuestModel questModel,
  }) async {
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: true);

    if (!locationModel.locationCompletedBy.contains(_databaseService.uid) &&
        lastChallengeCompleted) {
      try {
        
        await _databaseService.arrayUnionField(
            documentId: locationModel.id,
            uid: _databaseService.uid,
            field: 'locationCompletedBy',
            collectionRef: APIPath.locations(questId: questModel.id));
            
        if (lastLocationCompleted) {
          print('WOOOO');
        } else if (!lastLocationCompleted){
          final didCompleteLocation = await ChallengePlatformAlertDialog(
            title: 'Location Conquered!',
            content:
                'Well done, you\'ve conquered  ${locationModel.title}. Time for your next adventure!',
            defaultActionText: 'Next Location',
            image: Image.asset('images/ic_excalibur_owl.png'),
          ).show(context);
          if (didCompleteLocation) {}
        }
      } catch (e) {
        print(e.toString());
      }
    } else
      return null;
  }
}
