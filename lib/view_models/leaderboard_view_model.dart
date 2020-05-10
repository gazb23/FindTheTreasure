import 'package:find_the_treasure/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LeaderboardViewModel {

    static int calculatePoints({@required int updatedDiamonds, @required int updatedKeys, @required List locationExplored }) {

    int _userPointsCalc;
    if (updatedDiamonds > 0 && updatedKeys > 0 && locationExplored.length > 0) {
      _userPointsCalc = ((updatedKeys * updatedDiamonds * locationExplored.length)/2).truncate();
    } else _userPointsCalc = 0;
    return _userPointsCalc;
  }

      static int pointsUnchanged({@required UserData userData}) {

    int _userPointsCalc = userData.points;
   
    return _userPointsCalc;
  }

}