import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/answer_box.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/widgets_common/quests/scroll.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionScrollSingleAnswer extends StatelessWidget {
  static const String id = 'quest_start_screen';
  final String questTitle;
  final String questId;
  final String questionIntroduction;
  final String question;
  final List<dynamic> answers;
  final bool locationQuestion;

  const QuestionScrollSingleAnswer({
    Key key,
    @required this.questTitle,
    @required this.questId,
    @required this.questionIntroduction,
    @required this.question,
    @required this.answers,
    @required this.locationQuestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService =
        Provider.of<DatabaseService>(context);
    final UserData userData = Provider.of<UserData>(context);

    return StreamBuilder<QuestModel>(
        stream: databaseService.questStream(questId: questId),
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
                      _buildPirateIntro(context, questionIntroduction),
                      SizedBox(
                        height: 10,
                      ),
                      Scroll(
                        question: question,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      AnswerBox(
                        answers: answers,
                        locationQuestion: locationQuestion,
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

Widget _buildPirateIntro(BuildContext context, String questionIntroduction) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 20,
      ),
      Stack(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 15),
          margin: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            color: Colors.brown,
          ),
          child: Center(
              child: Text(questionIntroduction,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: Image.asset('images/pirate.png')),
      ]),
      SizedBox(
        height: 10,
      ),
    ],
  );
}
