import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/active_quest/question_widgets/multiple_choice.dart';
import 'package:find_the_treasure/presentation/active_quest/question_widgets/question_introduction.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/view_models/challenge_view_model.dart';

import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionMultipleChoiceWithPicture extends StatelessWidget {
  final QuestModel questModel;
  final LocationModel locationModel;
  final QuestionsModel questionsModel;
  final bool locationQuestion;
  final bool isFinalChallenge;

  const QuestionMultipleChoiceWithPicture({
    Key key,
    this.questModel,
    this.locationModel,
    this.questionsModel,
    this.locationQuestion,
    this.isFinalChallenge,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Builder(
            
            builder: (context) => StreamBuilder<QuestionsModel>(
                stream: databaseService.challengeStream(
                    questId: questModel.id,
                    locationId: locationModel.id,
                    challengeId: questionsModel.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active)  {
                    final questionsModelStream = snapshot.data;
                    return InkWell(
                      onTap: () {
                        ChallengeViewModel.showHint(
                            context: context,
                            questionsModel: questionsModelStream,
                            locationModel: locationModel,
                            questModel: questModel,
                            );
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: 
                        
                        Text(
                          !questionsModelStream.hintPurchasedBy.contains(databaseService.uid) ?
                          'HINT?' : 'SHOW HINT',
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                    
                    );
                    
                  } return Container();
                }),

          ),
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
          actions: <Widget>[
            DiamondAndKeyContainer(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              numberOfDiamonds: userData.userDiamondCount,
              numberOfKeys: userData.userKeyCount,
              color: Colors.black87,
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/background_games.png',
                  ),
                  fit: BoxFit.fill)),
          child: ListView(
            children: <Widget>[
              QuestionIntroduction(
                context: context,
                locationModel: locationModel,
                questionsModel: questionsModel,
                locationQuestion: locationQuestion,
                showImage: true,

              ),
              SizedBox(
                height: 10,
              ),
              MultipleChoice(
                questionsModel: questionsModel,
                locationModel: locationModel,
                isFinalChallenge: isFinalChallenge,
                questModel: questModel,
                showOwl: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
