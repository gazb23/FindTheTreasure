import 'package:find_the_treasure/constants.dart';
import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/Shop/screens/shop_screen.dart';
import 'package:find_the_treasure/presentation/active_quest/question_types/question_multiple_choice.dart';
import 'package:find_the_treasure/presentation/active_quest/question_types/question_multiple_choice_picture.dart';
import 'package:find_the_treasure/presentation/active_quest/question_types/question_picture_single_answer.dart';
import 'package:find_the_treasure/presentation/active_quest/question_types/question_scroll_single_answer.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/audio_player.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/services/global_functions.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/view_models/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionViewModel extends ChangeNotifier {
  bool isLoading = false;

  // Logic for when an answer is submitted. If correct, will add UID to Firestore Database and display the correct PlatformAlertDialog.
  Future<void> submit(
    BuildContext context, {
    @required bool isLocation,
    @required bool isFinalChallenge,
    @required String documentId,
    @required String collectionRef,
    @required String locationTitle,
    @required String challengeCompletedMessage,
    @required UserData userData,
  }) async {
    isLoading = true;
    notifyListeners();
    // Not using await on async functions as this will stop Firebase offline mode from working. Instead, I have created a simulated network delay to improve feedback for the user.
    await GlobalFunction.delayBy(minTime: 300, maxTime: 1500);
    AudioPlayerService().playSound(path: 'answer_correct.mp3');
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
        final UserData _userData = UserData(
            displayName: userData.displayName,
            email: userData.email,
            id: userData.id,
            isAdmin: userData.isAdmin,
            locationsExplored: userData.locationsExplored,
            photoURL: userData.photoURL,
            points: userData.points + correctPoints,
            userDiamondCount: userData.userDiamondCount,
            seenIntro: true,
            uid: userData.uid);
        _databaseService.updateUserData(userData: _userData);
        isLoading = false;
        notifyListeners();

        if (!isFinalChallenge) {
          final _didRequestNext = await PlatformAlertDialog(
            title: 'Challenge Complete!',
            showPoints: true,
            content:
                challengeCompletedMessage ?? 'You\'ve completed the challenge!',
            cancelActionText: 'Not Now',
            defaultActionText: 'Next challenge',
            image: Image.asset(
              'images/ic_excalibur_owl.png',
              height: 120,
            ),
          ).show(context);
          if (_didRequestNext) {
            Navigator.pop(context);
          } else {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        } else {
          // If final challenge for a location
          Navigator.pop(context);
        }
      } catch (e) {
        print(e.toString());
      } finally {
        isLoading = false;
        notifyListeners();
      }
    } else if (isLocation)
      // If Location Question
      try {
        _databaseService.arrayUnionField(
          documentId: documentId,
          field: 'locationStartedBy',
          collectionRef: collectionRef,
        );
        final UserData _userData = UserData(
          displayName: userData.displayName,
          email: userData.email,
          id: userData.id,
          isAdmin: userData.isAdmin,
          locationsExplored: userData.locationsExplored,
          photoURL: userData.photoURL,
          points: userData.points + correctPoints,
          userDiamondCount: userData.userDiamondCount,
          seenIntro: true,
          uid: userData.uid,
        );
        _databaseService.updateUserData(userData: _userData);
        isLoading = false;
        notifyListeners();
        final _didCompleteChallenge = await PlatformAlertDialog(
          backgroundColor: Colors.brown,
          contentTextColor: Colors.white,
          titleTextColor: Colors.white,
          showPoints: true,
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
      } finally {
        isLoading = false;
        notifyListeners();
      }
  }

  /*
  This method will do the following:
  1. When all CHALLENGES for a given LOCATION have been completed, add the user UID to locationCompletedBy. Also provide some visual feedback for the user.
  2. If the last location has been completed, call the submitQuestConquered method
  
*/
  static void checkQuestLogic(
    BuildContext context, {
    @required bool lastChallengeCompleted,
    @required bool lastLocationCompleted,
    @required LocationModel locationModel,
    @required QuestModel questModel,
  }) async {
    final UserData _userData = Provider.of<UserData>(context);
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: true);

    if (!locationModel.locationCompletedBy.contains(_databaseService.uid) &&
        lastChallengeCompleted) {
      try {
        if (!_userData.locationsExplored.contains(locationModel.title)) {
          //Add the title of the location to the users locationsExplored field
          _databaseService.arrayUnionFieldData(
              documentId: _userData.uid,
              data: locationModel.title,
              field: 'locationsExplored',
              collectionRef: APIPath.users());
          // await locationsExplored;
        }
        _databaseService.arrayUnionField(
            documentId: locationModel.id,
            field: 'locationCompletedBy',
            collectionRef: APIPath.locations(questId: questModel.id));

        // await locationCompleteBy;

        // If the user has completed all the locations for a quest
        if (lastLocationCompleted) {
          LocationViewModel().submitQuestConquered(
            context,
            lastLocationCompleted: lastLocationCompleted,
            questModel: questModel,
          );
        } else if (!lastLocationCompleted) {
          final didCompleteLocation = await PlatformAlertDialog(
            backgroundColor: Colors.amberAccent,
            title: 'Location Conquered!',
            content:
                'Well done, you\'ve conquered  ${locationModel.title}. Time for your next adventure!',
            defaultActionText: 'Next Location',
            cancelActionText: 'Not Now',
            contentTextColor: Colors.black87,
            image: Image.asset('images/ic_excalibur_owl.png'),
          ).show(context);
          if (didCompleteLocation) {
            // Pop alert dialog
          } else {
            //Take user back to explore screen
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
      case 'questionSingleAnswerPicture':
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => QuestionSingleAnswerPicture(
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

  // Logic to show SKIP for a challenge **Cannot skip a location based question
  static void showChallengeSkip({
    @required BuildContext context,
    @required QuestionsModel questionsModel,
    @required LocationModel locationModel,
    @required QuestModel questModel,
    @required bool isFinalChallenge,
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
        final QuestionViewModel questionViewModel =
            Provider.of<QuestionViewModel>(context, listen: false);
        try {
          final UserData _updateUserData = UserData(
            userDiamondCount: _userData.userDiamondCount - _skipCost,
            // userKeyCount: _userData.userKeyCount,
            points: _userData.points,
            displayName: _userData.displayName,
            email: _userData.email,
            photoURL: _userData.photoURL,
            uid: _userData.uid,
            isAdmin: _userData.isAdmin,
            locationsExplored: _userData.locationsExplored,
            seenIntro: _userData.seenIntro,
          );

          _databaseService.updateUserData(userData: _updateUserData);

          questionViewModel.submit(
            context,
            userData: _userData,
            isLocation: false,
            challengeCompletedMessage: questionsModel.challengeCompletedMessage,
            isFinalChallenge: isFinalChallenge,
            documentId: questionsModel.id,
            collectionRef: APIPath.challenges(
                questId: questModel.id, locationId: locationModel.id),
            locationTitle: locationModel.title,
          );
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
