import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final BuildContext context;
  final QuestModel questModel;
  final LocationModel locationModel;
  final QuestionsModel questionsModel;

  const SkipButton({
    Key key,
   @required this.context,
   @required this.questModel,
   @required this.locationModel,
   @required this.questionsModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // QuestionViewModel.showChallengeSkip(
        //             context: context,
        //             questionsModel: questionsModel,
        //             locationModel: locationModel,
        //             questModel: questModel,
        //             isFinalChallenge: isFinalChallenge,
        //           );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
           ),
        child: Text('SKIP?', style: TextStyle(color: Colors.black, fontSize: 18),),
      ),
    );
  }
}
