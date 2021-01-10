import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/view_models/challenge_view_model.dart';
import 'package:find_the_treasure/view_models/question_view_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultipleChoice extends StatefulWidget {
  final QuestModel questModel;
  final LocationModel locationModel;
  final QuestionsModel questionsModel;
  final bool isFinalChallenge;
  final bool showOwl;
  const MultipleChoice({
    Key key,
    @required this.questionsModel,
    @required this.isFinalChallenge,
    @required this.questModel,
    @required this.locationModel,
    this.showOwl = false,
  }) : super(key: key);

  @override
  _MultipleChoiceState createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  String _imageA = 'images/4.0x/ic_a_neutral.png';
  String _imageB = 'images/4.0x/ic_b_neutral.png';
  String _imageC = 'images/4.0x/ic_c_neutral.png';
  String _imageD = 'images/4.0x/ic_d_neutral.png';
  String _neutralOwl = 'images/ic_owl_neutral.png';
  String _correctOwl = 'images/ic_owl_correct.png';
  String _wrongOwl = 'images/ic_owl_wrong.png';
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildMultiChoiceTiles(),
          const SizedBox(height: 20),
          widget.showOwl ? Image.asset(_neutralOwl) : Container()
        ],
      ),
    );
  }

  Widget _buildMultiChoiceTiles() {
    return Column(
      children: <Widget>[
        // Answer 1
        Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50))),
          child: Center(
            child: ListTile(
              enabled: !_submitted,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              leading: Image.asset(
                _imageA,
                height: 40,
              ),
              title: AutoSizeText(
                widget.questionsModel.answerA['answer'],
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
              onTap: _submitA,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Answer 2
        Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50))),
          child: Center(
            child: ListTile(
              enabled: !_submitted,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              leading: Image.asset(
                _imageB,
                height: 40,
              ),
              title: AutoSizeText(
                widget.questionsModel.answerB['answer'],
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
              onTap: _submitB,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Answer 3
        Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50))),
          child: Center(
            child: ListTile(
              enabled: !_submitted,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              leading: Image.asset(
                _imageC,
                height: 40,
              ),
              title: AutoSizeText(
                widget.questionsModel.answerC['answer'],
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
              onTap: _submitC,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Answer 4
        Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50))),
          child: Center(
            child: ListTile(
              enabled: !_submitted,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              leading: Image.asset(
                _imageD,
                height: 40,
              ),
              title: AutoSizeText(
                widget.questionsModel.answerD['answer'],
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
              onTap: _submitD,
            ),
          ),
        ),
      ],
    );
  }

  void _submitA() async {
    final QuestionViewModel questionViewModel = Provider.of<QuestionViewModel>(context, listen: false);
    bool _isCorrect = widget.questionsModel.answerA.containsValue(true);
    if (_isCorrect) {
      setState(() {
        _imageA = 'images/4.0x/ic_a_correct.png';
        _neutralOwl = _correctOwl;
        _submitted = true;
      });

      await questionViewModel.submit(
        context,
        isLocation: false,
        challengeCompletedMessage:
            widget.questionsModel.challengeCompletedMessage,
        isFinalChallenge: widget.isFinalChallenge,
        documentId: widget.questionsModel.id,
        collectionRef: APIPath.challenges(
            questId: widget.questModel.id, locationId: widget.locationModel.id),
        locationTitle: widget.locationModel.title,
      );
    } else {
      setState(() {
        _imageA = 'images/4.0x/ic_a_wrong.png';
        _neutralOwl = _wrongOwl;
        _submitted = true;
      });
     await ChallengeViewModel().answerIncorrect(
        context: context,
        questModel: widget.questModel,      
        duration: Duration(milliseconds: 1800),
      );
      await Future.delayed(Duration(milliseconds: 2000));
      setState(() {
        _imageA = 'images/4.0x/ic_a_neutral.png';
        _neutralOwl = 'images/ic_owl_neutral.png';
        _submitted = false;
      });
    }
  }

  void _submitB() async {
    final QuestionViewModel questionViewModel = Provider.of<QuestionViewModel>(context, listen: false);
    if (widget.questionsModel.answerB.containsValue(true)) {
      setState(() {
        _imageB = 'images/4.0x/ic_b_correct.png';
        _neutralOwl = _correctOwl;
        _submitted = true;
      });

      questionViewModel.submit(
        context,
        isLocation: false,
        challengeCompletedMessage:
            widget.questionsModel.challengeCompletedMessage,
        isFinalChallenge: widget.isFinalChallenge,
        documentId: widget.questionsModel.id,
        collectionRef: APIPath.challenges(
            questId: widget.questModel.id, locationId: widget.locationModel.id),
        locationTitle: widget.locationModel.title,
      );
    } else {
      setState(() {
        _imageB = 'images/4.0x/ic_b_wrong.png';
        _neutralOwl = _wrongOwl;
        _submitted = true;
      });
      await ChallengeViewModel().answerIncorrect(
          context: context,
          questModel: widget.questModel,
       
          duration: Duration(milliseconds: 1800));
      await Future.delayed(Duration(milliseconds: 2000));
      setState(() {
        _imageB = 'images/4.0x/ic_b_neutral.png';
        _neutralOwl = 'images/ic_owl_neutral.png';
        _submitted = false;
      });
    }
  }

  void _submitC() async {
    final QuestionViewModel questionViewModel = Provider.of<QuestionViewModel>(context, listen: false);
    if (widget.questionsModel.answerC.containsValue(true)) {
      setState(() {
        _imageC = 'images/4.0x/ic_c_correct.png';
        _neutralOwl = _correctOwl;
        _submitted = true;
      });

      questionViewModel.submit(
        context,
        isLocation: false,
        challengeCompletedMessage:
            widget.questionsModel.challengeCompletedMessage,
        isFinalChallenge: widget.isFinalChallenge,
        documentId: widget.questionsModel.id,
        collectionRef: APIPath.challenges(
            questId: widget.questModel.id, locationId: widget.locationModel.id),
        locationTitle: widget.locationModel.title,
      );
    } else {
      setState(() {
        _imageC = 'images/4.0x/ic_c_wrong.png';
        _neutralOwl = _wrongOwl;
        _submitted = true;
      });
      await ChallengeViewModel().answerIncorrect(
          context: context,
          questModel: widget.questModel,
  
          duration: Duration(milliseconds: 1800));
      await Future.delayed(Duration(milliseconds: 2000));
      setState(() {
        _imageC = 'images/4.0x/ic_c_neutral.png';
        _neutralOwl = 'images/ic_owl_neutral.png';
        _submitted = false;
      });
    }
  }

  void _submitD() async {
    final QuestionViewModel questionViewModel = Provider.of<QuestionViewModel>(context, listen: false);
    if (widget.questionsModel.answerD.containsValue(true)) {
      setState(() {
        _imageD = 'images/4.0x/ic_d_correct.png';
        _neutralOwl = _correctOwl;
        _submitted = true;
      });

      questionViewModel.submit(
        context,
        isLocation: false,
        challengeCompletedMessage:
            widget.questionsModel.challengeCompletedMessage,
        isFinalChallenge: widget.isFinalChallenge,
        documentId: widget.questionsModel.id,
        collectionRef: APIPath.challenges(
            questId: widget.questModel.id, locationId: widget.locationModel.id),
        locationTitle: widget.locationModel.title,
      );
    } else {
      setState(() {
        _imageD = 'images/4.0x/ic_d_wrong.png';
        _neutralOwl = _wrongOwl;
        _submitted = true;
      });
      await ChallengeViewModel().answerIncorrect(
          context: context,
          questModel: widget.questModel,
        
          duration: Duration(milliseconds: 1800));
      await Future.delayed(Duration(milliseconds: 2000));
      setState(() {
        _imageD = 'images/4.0x/ic_d_neutral.png';
        _neutralOwl = 'images/ic_owl_neutral.png';
        _submitted = false;
      });
    }
  }
}
