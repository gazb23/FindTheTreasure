import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LeaderboardViewModel{


  static int questComplete({@required UserData userData, @required QuestModel questModel}) {
    int userPointsCalc = userData.points + questModel.questPoints;
    
    return userPointsCalc;
 

  }
  // The amount of points subtracted for an incorrect question
  static int questionIncorrect({@required UserData userData, @required QuestModel questModel}) {
    
     int incorrectQuestion = (questModel.questPoints * 0.05).truncate();
     int userPointsCalc = userData.points - incorrectQuestion;


     return userPointsCalc;
  }

  static int showPointsLost({@required UserData userData, @required QuestModel questModel}) {
     int incorrectQuestion = (questModel.questPoints * 0.05).truncate();
     return incorrectQuestion;
  }

  
}
