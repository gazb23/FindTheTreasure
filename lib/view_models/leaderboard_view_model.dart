import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LeaderboardViewModel {

    static int calculatePoints({@required int updatedDiamonds, @required int updatedKeys }) {

    int _userPointsCalc;
    if (updatedDiamonds > 0 && updatedKeys > 0) {
      _userPointsCalc = updatedKeys * updatedDiamonds;
    } else _userPointsCalc = 0;
    return _userPointsCalc;
  }
}