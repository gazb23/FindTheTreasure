import 'package:find_the_treasure/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LeaderboardViewModel {

    static int calculatePoints({@required UserData userData,  @required BuildContext context,}) {

    int _userPointsCalc;
    if (userData.userDiamondCount > 0 && userData.userKeyCount > 0) {
      _userPointsCalc = userData.userDiamondCount * userData.userKeyCount;
    } else _userPointsCalc = 0;
    return _userPointsCalc;
  }
}