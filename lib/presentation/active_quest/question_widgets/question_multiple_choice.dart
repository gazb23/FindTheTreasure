import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/active_quest/question_widgets/multiple_choice.dart';
import 'package:find_the_treasure/presentation/active_quest/question_widgets/question_introduction.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionMultipleChoice extends StatelessWidget {
  final QuestModel questModel;
  final LocationModel locationModel;
  final QuestionsModel questionsModel;
  final bool locationQuestion;
  final bool isFinalChallenge;

  const QuestionMultipleChoice({
    Key key,
    this.questModel,
    this.locationModel,
    this.questionsModel,
    this.locationQuestion,
    this.isFinalChallenge,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService =
        Provider.of<DatabaseService>(context);
    final UserData userData = Provider.of<UserData>(context);

    return StreamBuilder<QuestModel>(
        stream: databaseService.questStream(questId: questModel.id),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            final _questModelStream = snapshot.data;
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(_questModelStream.title),
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MultipleChoice(
                        questionsModel: questionsModel,
                        locationModel: locationModel,
                        isFinalChallenge: isFinalChallenge,
                        questModel: questModel,
                      ),
                      Container(child: Image.asset('images/ic_owl_neutral.png', height: 200,))
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.data == null) {
            CircularProgressIndicator();
          }
          return Container();
        });
  }
}
