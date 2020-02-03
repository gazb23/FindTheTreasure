import 'package:expandable/expandable.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/presentation/active_quest/question_widgets/question_scroll_single_answer.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestLocationCard extends StatelessWidget {
  final QuestionsModel questionsModel;
  final QuestModel questModel;
  final DatabaseService databaseService;

  const QuestLocationCard({
    Key key,
    this.questionsModel,
    this.questModel,
    this.databaseService,
  }) : super(key: key);
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
            theme: ExpandableThemeData(
              tapBodyToExpand: true,
              tapBodyToCollapse: true,
              tapHeaderToExpand: true,
            ),
            header: LocationHeader(
              questModel: questModel,
              questionsModel: questionsModel,
            ),
            expanded: ConstrainedBox(
              //TODO: Fix challenge box, so container sizes to number of challenges.
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2),
              child: StreamBuilder<List<QuestionsModel>>(
                stream: databaseService.challengesStream(
                    questId: questModel.id, locationId: questionsModel.id),
                builder: (context, snapshot) {
                  return ListItemsBuilder<QuestionsModel>(
                    title: 'Oh no! No challenges!',
                    message: 'Admin needs to add some!',
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
  final QuestModel questModel;

  const LocationHeader(
      {Key key, @required this.questionsModel, @required this.questModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService =
        Provider.of<DatabaseService>(context);
    return StreamProvider<QuestionsModel>(
        create: (context) => databaseService.locationStream(
            questId: questModel.id, locationId: questionsModel.id),
        
            child: Consumer<QuestionsModel>(
              builder: (context, _questionsModel, _ ) =>
                          Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  leading: Image.asset('images/pirate.png'),
                  title: Text(
                    questionsModel.locationTitle ?? 'Mystery Location 1',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontFamily: 'JosefinSans',
                        fontSize: 24),
                  ),
                  trailing: Text(
                          '${_questionsModel.numberOfChallengesCompleted}/${_questionsModel.numberOfChallenges}') ??
                      Text('0/12'),
                ),
              ),
            )
          
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
              fontFamily: 'quicksand',
              fontSize: 18),
        ),
        onTap: onTap,
      ),
    );
  }
}

