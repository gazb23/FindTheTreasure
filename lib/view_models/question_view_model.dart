import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/active_quest/question_types/question_multiple_choice.dart';
import 'package:find_the_treasure/presentation/active_quest/question_types/question_multiple_choice_picture.dart';
import 'package:find_the_treasure/presentation/active_quest/question_types/question_scroll_single_answer.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';

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
        _databaseService.arrayUnionField(
          documentId: documentId,
          field: 'challengeCompletedBy',
          collectionRef: collectionRef,
        );
        if (!isFinalChallenge) {
          final _didRequestNext = await PlatformAlertDialog(
            title: 'Congratulations!',
            content: 'You\'ve completed the challenge!',
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
        } else {
          _databaseService.arrayUnionField(
            documentId: documentId,
            field: 'challengeCompletedBy',
            collectionRef: collectionRef,
          );
          Navigator.pop(context);
        }
      } catch (e) {
        print(e.toString());
      }
    } else
      // If Location Question
      try {
        _databaseService.arrayUnionField(
          documentId: documentId,
          field: 'locationStartedBy',
          collectionRef: collectionRef,
        );
        final _didCompleteChallenge = await PlatformAlertDialog(
          title: 'Location Unlocked!',
          content:
              'Well done, you\'ve discovered  $locationTitle. It\'s adventure time!',
          cancelActionText: 'Not Now',
          defaultActionText: 'Start Challenge',
          image: Image.asset('images/ic_excalibur_owl.png'),
        ).show(context);
        if (_didCompleteChallenge) {
          Navigator.pop(context);
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
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
      final UserData _userData = Provider.of<UserData>(context);
      try {
        final Future<void> locationCompleteBy =
            _databaseService.arrayUnionField(
                documentId: locationModel.id,
                field: 'locationCompletedBy',
                collectionRef: APIPath.locations(questId: questModel.id));

        final Future<void> locationsExplored =
            _databaseService.arrayUnionFieldData(
                documentId: _userData.uid,
                location: locationModel.title,
                field: 'locationsExplored',
                collectionRef: APIPath.users());

        final List<Future> futures = [locationCompleteBy, locationsExplored];
        
        await Future.wait(futures);

        if (lastLocationCompleted) {
          print('WOOOO');
        } else if (!lastLocationCompleted) {
          final didCompleteLocation = await PlatformAlertDialog(
            backgroundColor: Colors.amberAccent,
            title: 'Location Conquered!',
            content:
                'Well done, you\'ve conquered  ${locationModel.title}. Time for your next adventure!',
            defaultActionText: 'Next Location',
            cancelActionText: 'Not Now',
            image: Image.asset('images/ic_excalibur_owl.png'),
          ).show(context);
          if (didCompleteLocation) {
          } else {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      } catch (e) {
        print(e.toString());
      }
    } else
      return null;
  }

// Logic to push the correct challenge type for the QuestLocationCard
  static void loadQuestion({
    @required BuildContext context,
    @required QuestionsModel questionsModel,
    @required QuestModel questModel,
    @required LocationModel locationModel,
    @required bool isFinalChallenge,
  }) {
    switch (questionsModel.questionType) {
      case 'questionSingleAnswer':
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => QuestionScrollSingleAnswer(
              isFinalChallenge: isFinalChallenge,
              locationQuestion: false,
              questModel: questModel,
              questionsModel: questionsModel,
              locationModel: locationModel,
            ),
          ),
        );
        break;
      case 'questionMultipleChoice':
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => QuestionMultipleChoice(
              isFinalChallenge: isFinalChallenge,
              locationQuestion: false,
              questModel: questModel,
              questionsModel: questionsModel,
              locationModel: locationModel,
            ),
          ),
        );
        break;
      case 'questionMultipleChoicePicture':
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => QuestionMultipleChoiceWithPicture(
              isFinalChallenge: isFinalChallenge,
              locationQuestion: false,
              questModel: questModel,
              questionsModel: questionsModel,
              locationModel: locationModel,
            ),
          ),
        );
        break;
    }
  }
}
