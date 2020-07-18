import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/view_models/challenge_view_model.dart';
import 'package:find_the_treasure/view_models/question_view_model.dart';
import 'package:flutter/material.dart';

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
  bool _isLoading = false;
  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      return true;
    }
    return false;
  }

  void _submit() async {
    if (_validateAndSaveForm()) {
      try {
        if (checkAnswer(_answer)) {
          _isLoading = true;
          setState(() {});

          QuestionViewModel.submit(context,
              documentId: widget.arrayUnionDocumentId,
              challengeCompletedMessage:
                  widget.questionsModel?.challengeCompletedMessage,
              collectionRef: widget.arrayUnionCollectionRef,
              isLocation: widget.islocationQuestion,
              locationTitle: widget.locationTitle,
              isFinalChallenge: widget.isFinalChallenge);
        }
      } catch (e) {
        print(e.toString());
        _isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                if (!checkAnswer(value.toUpperCase().trim()) &&
                    value.isNotEmpty) {
                  ChallengeViewModel().answerIncorrect(
                    context: context,
                    questModel: widget.questModel,
                  );

                  return 'Answer incorrect';
                }
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
                enabled: !_isLoading,
                suffixIcon: IconButton(
                    enableFeedback: true,
                    icon: _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                MaterialTheme.orange),
                          )
                        : const Icon(
                            Icons.send,
                            color: MaterialTheme.orange,
                          ),
                    onPressed: !_isLoading ? _submit : null),
              ),
            ),
          ),
        ),
      ),
    );
  }
  //   bool checkAnswer(String answer) {
  //   List _answers = widget.answers;

  //   for (var i = 0; i < _answers.length; ++i) {
  //     // This
  //     _correctAnswer = RegExp("?!(the)|(an)?${widget.answers[i]}s?").hasMatch(answer);
  //   if (_correctAnswer) {
  //     return _correctAnswer;
  //   }

  //   }
  //   return false;
  // }

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
