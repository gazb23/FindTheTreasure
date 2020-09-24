import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/Shop/screens/shop_screen.dart';
import 'package:find_the_treasure/presentation/active_quest/active_quest_screen.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/audio_player.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuestDiamondCalulationButton extends StatelessWidget {
  final QuestModel questModelStream;
  final UserData userData;
  final DatabaseService databaseService;

  const QuestDiamondCalulationButton({
    Key key,
    @required this.questModelStream,
    @required this.userData,
    @required this.databaseService,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool _isStartedBy =
        questModelStream.questStartedBy.contains(userData.uid);
    final bool _isCompletedBy =
        questModelStream.questCompletedBy.contains(userData.uid);
    int _diamondCalc =
        (questModelStream.numberOfDiamonds - userData.userDiamondCount);
    int _keyCalc = (questModelStream.numberOfKeys - userData.userKeyCount);

    return SignInButton(
        padding: 15,
        text: _isStartedBy || _isCompletedBy ? 'Continue Quest' : 'Start Quest',
        onPressed: () {
          if (userData.userDiamondCount >= questModelStream.numberOfDiamonds &&
                  userData.userKeyCount >= questModelStream.numberOfKeys ||
              _isStartedBy ||
              _isCompletedBy) {
            return _confirmQuest(
                context, questModelStream, userData, databaseService);
          } else if (userData.userDiamondCount <
              questModelStream.numberOfDiamonds) {
            return _confirmStoreDiamond(
              context,
              questModelStream,
              _diamondCalc,
            );
          } else
            return _confirmStoreKey(context, questModelStream, _keyCalc);
        });
  }

  Future<void> _confirmQuest(BuildContext context, QuestModel questModelStream,
      UserData userData, DatabaseService database) async {
    final bool _isStartedBy =
        questModelStream.questStartedBy.contains(userData.uid);
    final bool _isCompletedBy =
        questModelStream.questCompletedBy.contains(userData.uid);
    try {
      if (!_isStartedBy && !_isCompletedBy) {
        final didRequestQuest = await PlatformAlertDialog(
          title: '${userData.displayName}',
          content:
              'It seems ye have enough treasure for the ${questModelStream.title} quest. Do you want to start your adventure?',
          cancelActionText: 'Cancel',
          defaultActionText: 'Confirm',
          image: Image.asset('images/ic_excalibur_owl.png'),
        ).show(context);
        if (didRequestQuest) {
          AudioPlayerService player = AudioPlayerService();
          player.playSound(path: 'quest_purchased.mp3');
          final UserData _userData = UserData(
            userDiamondCount:
                userData.userDiamondCount - questModelStream.numberOfDiamonds,
            userKeyCount: userData.userKeyCount - questModelStream.numberOfKeys,
            points: userData.points,
            displayName: userData.displayName,
            locationsExplored: userData.locationsExplored,
            email: userData.email,
            photoURL: userData.photoURL,
            isAdmin: userData.isAdmin,
            uid: userData.uid,
            seenIntro: userData.seenIntro,
          );

          await database.arrayUnionField(
              collectionRef: APIPath.quests(),
              documentId: questModelStream.id,
              field: 'questStartedBy');

          database.updateUserData(userData: _userData);

          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => ActiveQuestScreen(
                questModel: questModelStream,
              ),
            ),
          );
        }
      } else if (_isStartedBy || _isCompletedBy) {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ActiveQuestScreen(
              questModel: questModelStream,
            ),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

// Show the correct PlatformAlert dialog and navigate the user to the store if requ
  Future<void> _confirmStoreKey(
      BuildContext context, QuestModel questModelStream, _keyCalc) async {
    final didRequestQuest = await PlatformAlertDialog(
      title: '${userData.displayName}',
      content:
          'It seems ye need ${questModelStream.numberOfKeys - userData.userKeyCount} ${keyPluralCount(_keyCalc)} to complete the ${questModelStream.title} quest. Head to the shop to buy some more or head off on an adventure that requires less keys.',
      cancelActionText: 'Cancel',
      defaultActionText: 'Shop',
      image: Image.asset('images/ic_owl_wrong_dialog.png'),
    ).show(context);
    if (didRequestQuest) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShopScreen(),
        ),
      );
    }
  }

  Future<void> _confirmStoreDiamond(
      BuildContext context, QuestModel questModelStream, _diamondCalc) async {
    final didRequestQuest = await PlatformAlertDialog(
      title: '${userData.displayName}',
      content:
          'It seems ye need ${questModelStream.numberOfDiamonds - userData.userDiamondCount} ${diamondPluralCount(_diamondCalc)} to complete the ${questModelStream.title} quest. Head to the shop to buy some more.',
      cancelActionText: 'Cancel',
      defaultActionText: 'Shop',
      image: Image.asset('images/ic_owl_wrong_dialog.png'),
    ).show(context);
    if (didRequestQuest) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShopScreen(),
        ),
      );
    }
  }

// String Plurals for diamond/s and key/s
  diamondPluralCount(int howMany) =>
      Intl.plural(howMany, one: 'more diamond', other: 'more diamonds');
  keyPluralCount(int howMany) =>
      Intl.plural(howMany, one: 'more key', other: 'more keys');
}
