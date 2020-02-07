import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/Shop/screens/shop_screen.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuestDiamondCalulationButton extends StatelessWidget {
  final QuestModel questModelStream;
  final UserData userData;
  final DatabaseService databaseService;
  final Function confirmQuest;
  final bool enabled;

  const QuestDiamondCalulationButton({
    Key key,
    @required this.questModelStream,
    @required this.userData,
    @required this.confirmQuest,
    @required this.databaseService, this.enabled,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool _isStartedBy = questModelStream.questStartedBy.contains(userData.uid);
    int _diamondCalc =
        (questModelStream.numberOfDiamonds - userData.userDiamondCount);
    int _keyCalc = (questModelStream.numberOfKeys - userData.userKeyCount);
    return SignInButton(
        text: _isStartedBy ? 'Continue Quest' : 'Start Quest',

        onPressed: () {
          if (userData.userDiamondCount >= questModelStream.numberOfDiamonds &&
              userData.userKeyCount >= questModelStream.numberOfKeys) {
            return confirmQuest(context, questModelStream, userData, databaseService);
          } else if (userData.userDiamondCount <
              questModelStream.numberOfDiamonds) {
            _confirmStoreDiamond(
              context,
              questModelStream,
              _diamondCalc,
            );
          } else
            _confirmStoreKey(context, questModelStream, _keyCalc);
        });
  }

// Show the correct PlatformAlert dialog and navigate the user to the store if requ
  Future<void> _confirmStoreKey(
      BuildContext context, QuestModel questModelStream, _keyCalc) async {
    final didRequestQuest = await PlatformAlertDialog(
      title: '${userData.displayName}',
      content:
          'It seems you need ${questModelStream.numberOfKeys - userData.userKeyCount} ${keyPluralCount(_keyCalc)} to complete the ${questModelStream.title} quest. Head to the store to buy some more or head off on an adventure that requires less keys.',
      cancelActionText: 'Cancel',
      defaultActionText: 'Store',
      image: Image.asset('images/ic_owl_wrong_dialog.png'),
    ).show(context);
    if (didRequestQuest) {
      Navigator.of(context, rootNavigator: true).push(
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
          'It seems you need ${questModelStream.numberOfDiamonds - userData.userDiamondCount} ${diamondPluralCount(_diamondCalc)} to complete the ${questModelStream.title} quest. Head to the store to buy some more',
      cancelActionText: 'Cancel',
      defaultActionText: 'Store',
      image: Image.asset('images/ic_owl_wrong_dialog.png'),
    ).show(context);
    if (didRequestQuest) {
      Navigator.of(context, rootNavigator: true).push(
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
