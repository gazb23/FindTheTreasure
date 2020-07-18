import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/presentation/active_quest/question_widgets/question_app_bar.dart';
import 'package:find_the_treasure/presentation/active_quest/question_widgets/question_introduction.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/view_models/question_view_model.dart';
import 'package:find_the_treasure/widgets_common/quests/answer_box.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionSingleAnswerPicture extends StatelessWidget {
  final QuestModel questModel;
  final LocationModel locationModel;
  final QuestionsModel questionsModel;
  final bool locationQuestion;
  final bool isFinalChallenge;

  const QuestionSingleAnswerPicture({
    Key key,
    this.questModel,
    this.locationModel,
    this.questionsModel,
    this.locationQuestion,
    this.isFinalChallenge,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    Provider.of<DatabaseService>(context);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: locationQuestion || keyboardIsOpened
            ? Container()
            : FloatingActionButton.extended(
                label: Text(
                  'SKIP?',
                  style: TextStyle(
                    fontSize: 18,
                    color: MaterialTheme.orange,
                  ),
                ),
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                backgroundColor: Colors.white,
                onPressed: () {
                  QuestionViewModel.showChallengeSkip(
                    context: context,
                    questionsModel: questionsModel,
                    locationModel: locationModel,
                    questModel: questModel,
                    isFinalChallenge: isFinalChallenge,
                  );
                }),
        appBar: QuestionAppBar(
          locationQuestion: locationQuestion,
          locationModel: locationModel,
          questModel: questModel,
          questionsModel: questionsModel,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
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
                largerImage: true,
              ),
              const SizedBox(
                height: 50,
              ),
              locationQuestion
                  ? AnswerBox(
                      questionsModel: questionsModel,
                      questModel: questModel,
                      isFinalChallenge: isFinalChallenge,
                      answers: locationModel.answers,
                      islocationQuestion: locationQuestion,
                      arrayUnionCollectionRef:
                          APIPath.locations(questId: questModel.id),
                      arrayUnionDocumentId: locationModel.id,
                      locationTitle: locationModel.title,
                    )
                  : AnswerBox(
                      questionsModel: questionsModel,
                      questModel: questModel,
                      isFinalChallenge: isFinalChallenge,
                      answers: questionsModel.answers,
                      islocationQuestion: locationQuestion,
                      arrayUnionCollectionRef: APIPath.challenges(
                          questId: questModel.id, locationId: locationModel.id),
                      arrayUnionDocumentId: questionsModel.id,
                      locationTitle: locationModel.title,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
