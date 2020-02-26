import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/active_quest/question_widgets/question_introduction.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/answer_box.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/widgets_common/quests/scroll.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionScrollSingleAnswer extends StatelessWidget {
  static const String id = 'quest_start_screen';

  final QuestModel questModel;
  final LocationModel locationModel;
  final QuestionsModel questionsModel;
  final bool locationQuestion;
  final bool isFinalChallenge;

  const QuestionScrollSingleAnswer({
    Key key,
    @required this.locationQuestion,
    this.questModel,
    this.locationModel,
    this.questionsModel,
    @required this.isFinalChallenge,
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
                  height: MediaQuery.of(context).size.height,
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
                        height: 20,
                      ),
                      Scroll(
                        question: locationQuestion
                        ? locationModel.question
                        : questionsModel.question,
                      ),
                      
                           SizedBox(height: 20,),
                      locationQuestion
                          ? AnswerBox(
                              isFinalChallenge: isFinalChallenge,
                              answers: locationModel.answers,
                              islocationQuestion: locationQuestion,
                              arrayUnionCollectionRef: APIPath.locations(
                                  questId: questModel.id),
                              arrayUnionDocumentId: locationModel.id,
                              locationTitle: locationModel.title,
                            )
                          : AnswerBox(
                              isFinalChallenge: isFinalChallenge,
                              answers: questionsModel.answers,
                              islocationQuestion: locationQuestion,
                              arrayUnionCollectionRef: APIPath.challenges(
                                  questId: questModel.id,
                                  locationId: locationModel.id),
                              arrayUnionDocumentId: questionsModel.id,
                              locationTitle: locationModel.title,
                            ),
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
