import 'package:expandable/expandable.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/presentation/active_quest/question_widgets/question_scroll_single_answer.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:flutter/material.dart';

class QuestLocationCard extends StatelessWidget {
  final QuestionsModel questionsModel;
  final QuestModel questModel;
  final DatabaseService databaseService;

  const QuestLocationCard(
      {Key key, this.questionsModel, this.questModel, this.databaseService})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ExpandablePanel(
            tapHeaderToExpand: true,
            tapBodyToCollapse: true,
            hasIcon: false,
            header: LocationHeader(
              questionsModel: questionsModel,
            ),
            expanded: ConstrainedBox(
              //TODO: Fix challenge box, so container sizes to number of challenges.
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 3),
              child: StreamBuilder<List<QuestionsModel>>(
                stream: databaseService.challengesStream(
                    questDocumentId: questModel.id,
                    locationDocumentId: questionsModel.id),
                builder: (context, snapshot) {                  
                  return ListItemsBuilder<QuestionsModel>(
                    snapshot: snapshot,
                    itemBuilder: (context, questionsModel) => Challenges(
                      questionsModel: questionsModel,
                      onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => QuestionScrollSingleAnswer(
                      questionsModel: questionsModel,
                      questModel: questModel,
                    ),
                  ),
                );
              },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LocationHeader extends StatelessWidget {
  final QuestionsModel questionsModel;

  const LocationHeader({Key key, this.questionsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.asset('images/pirate.png'),
        title: Text(
          questionsModel.locationTitle ?? 'Mystery Location 1',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontFamily: 'JosefinSans',
              fontSize: 20),
        ),
        trailing: Text(
                '${questionsModel.numberOfChallengesCompleted}/${questionsModel.numberOfChallenges}') ??
            Text('0/12'),
      ),
    );
  }
}

class Challenges extends StatelessWidget {
  final QuestionsModel questionsModel;
  final VoidCallback onTap;
  const Challenges({Key key, this.questionsModel, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.asset('images/ic_quest_nonactive.png'),
        title: Text(
          questionsModel.challengeTitle,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontFamily: 'JosefinSans',
              fontSize: 16),
        ),
        subtitle: Text(questionsModel.challengeProgressIndicator),
        onTap: onTap,
      ),
    );
  }
}

enum ChallengeProgress { notActive, active, complete }
