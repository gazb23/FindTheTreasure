import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/view_models/challenge_view_model.dart';
import 'package:find_the_treasure/view_models/question_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnswerBox extends StatefulWidget {
  final QuestModel questModel;
  final QuestionsModel questionsModel;
  final List<dynamic> answers;
  final bool islocationQuestion;
  final bool isFinalChallenge;
  final String arrayUnionCollectionRef;
  final String arrayUnionDocumentId;
  final String locationTitle;

  const AnswerBox({
    Key key,
    @required this.answers,
    @required this.islocationQuestion,
    @required this.arrayUnionCollectionRef,
    @required this.arrayUnionDocumentId,
    @required this.locationTitle,
    @required this.isFinalChallenge,
    @required this.questModel,
    @required this.questionsModel,
  }) : super(key: key);
  @override
  _AnswerBoxState createState() => _AnswerBoxState();
}

class _AnswerBoxState extends State<AnswerBox> {
  final _formKey = GlobalKey<FormState>();
  String _answer;
  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      return true;
    }
    return false;
  }

  void _submit()   {
    FocusScope.of(context).unfocus();
    final questionViewModel =
        Provider.of<QuestionViewModel>(context, listen: false);
    final challengeViewModel =
        Provider.of<ChallengeViewModel>(context, listen: false);

    if (_validateAndSaveForm()) {
      try {
        if (checkAnswer(_answer)) {
          
           questionViewModel.submit(context,
              documentId: widget.arrayUnionDocumentId,
              challengeCompletedMessage:
                  widget.questionsModel?.challengeCompletedMessage,
              collectionRef: widget.arrayUnionCollectionRef,
              isLocation: widget.islocationQuestion,
              locationTitle: widget.locationTitle,
              isFinalChallenge: widget.isFinalChallenge);
        } else {
           challengeViewModel.answerIncorrect(
            context: context,
            questModel: widget.questModel,
          );
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final QuestionViewModel questionViewModel =
        Provider.of<QuestionViewModel>(context);
    final ChallengeViewModel challengeViewModel =
        Provider.of<ChallengeViewModel>(context);
    return Opacity(
      opacity: .9,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 1.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
          child: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                // if (!checkAnswer(value.toUpperCase().trim()) &&
                //     value.isNotEmpty) {

                //   return 'Answer incorrect';
                // }
                if (checkAnswer(value.toUpperCase().trim()) &&
                    value.isNotEmpty) {
                  return null;
                }

                return value.isNotEmpty ? null : 'Please enter your answer';
              },
              onSaved: (value) => _answer = value.toUpperCase().trim(),
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'Enter your answer',
                enabled: !questionViewModel.isLoading ||
                    !challengeViewModel.isLoading,
                suffixIcon: IconButton(
                    enableFeedback: true,
                    icon: questionViewModel.isLoading ||
                            challengeViewModel.isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                MaterialTheme.orange),
                          )
                        : const Icon(
                            Icons.send,
                            color: MaterialTheme.orange,
                          ),
                    onPressed: !questionViewModel.isLoading ||
                            !challengeViewModel.isLoading
                        ? _submit
                        : null),
              ),
            ),
          ),
        ),
      ),
    );
  }

// REGEXP that will omit 'the, an OR a from start of sentence || s, es from the end of sentence
  bool checkAnswer(String answer) {
    List _answers = widget.answers;
    for (var i = 0; i < _answers.length; i++) {
      var re = RegExp("^(?:the |an |a )?${_answers[i]}(?:s|es)?.?\$",
          caseSensitive: false);
      if (re.hasMatch(answer)) return true;
    }
    return false;
  }
}
