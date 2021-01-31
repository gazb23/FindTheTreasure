import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/constants.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LeaderboardViewModel {
  static int questComplete(
      {@required UserData userData, @required QuestModel questModel}) {
    int userPointsCalc = userData.points + questModel.questPoints;

    return userPointsCalc;
  }

  // The amount of points subtracted for an incorrect question
  static int questionIncorrect({
    @required UserData userData,
    @required QuestModel questModel,
  }) {
    int userPointsCalc = userData.points <= 0 ? 0 : userData.points - incorrectPoints;

    return userPointsCalc;
  }

  static Widget showPointsLost({@required UserData userData}) {
    TextStyle textStyle = TextStyle(
              fontSize: 18,
              fontFamily: 'Quicksand',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            );

    return userData.points > 0
        ? AutoSizeText(
            'Answer incorrect: - $incorrectPoints points ',
            maxLines: 1,
            style: textStyle
          )
        : AutoSizeText(
            'Answer incorrect',
            maxLines: 1,
            style: textStyle
          );
  }
}
