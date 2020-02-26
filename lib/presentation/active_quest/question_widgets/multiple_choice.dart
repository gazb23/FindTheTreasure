import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/view_models/question_view_model.dart';

import 'package:flutter/material.dart';

class MultipleChoice extends StatefulWidget {
  final QuestModel questModel;
  final LocationModel locationModel;
  final QuestionsModel questionsModel;
  final bool isFinalChallenge;

  const MultipleChoice({
    Key key,
    @required this.questionsModel,
    @required this.isFinalChallenge,
    @required this.questModel,
    @required this.locationModel,
  }) : super(key: key);

  @override
  _MultipleChoiceState createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  String _imageA = 'images/4.0x/ic_a_neutral.png';
  String _imageB = 'images/4.0x/ic_b_neutral.png';
  String _imageC = 'images/4.0x/ic_c_neutral.png';
  String _imageD = 'images/4.0x/ic_d_neutral.png';
  bool _submitted = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildMultiChoiceTiles(),
      ],
    );
  }

  Widget _buildMultiChoiceTiles() {
    return Column(
      children: <Widget>[
        // Answer 1
        Container(
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))),
          child: Center(
            child: ListTile(
              enabled: !_submitted,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              leading: Image.asset(_imageA),
              title: Text(
                widget.questionsModel.answerA.values.first,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
              onTap: _submitA,
            ),
          ),
        ),
        SizedBox(height: 10),
        // Answer 2
        Container(
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))),
          child: Center(
            child: ListTile(
              enabled: !_submitted,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              leading: Image.asset(_imageB),
              title: Text(
                widget.questionsModel.answerB.values.first,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
              onTap: _submitB,
            ),
          ),
        ),
        SizedBox(height: 10),
        // Answer 3
        Container(
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))),
          child: Center(
            child: ListTile(
              enabled: !_submitted,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              leading: Image.asset(_imageC),
              title: Text(
                widget.questionsModel.answerC.values.first,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
              onTap: _submitC,
            ),
          ),
        ),
        SizedBox(height: 10),
        // Answer 4
        Container(
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))),
          child: Center(
            child: ListTile(
              enabled: !_submitted,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              leading: Image.asset(_imageD),
              title: Text(
                widget.questionsModel.answerD.values.first,
                style: TextStyle(
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
    
      if (widget.questionsModel.answerA.containsValue(true)) {
        setState(() {
          _imageA = 'images/4.0x/ic_a_correct.png';
        _submitted = true;
        });
        
        QuestionViewModel.submit(
          context,
          isLocation: false,
          isFinalChallenge: widget.isFinalChallenge,
          documentId: widget.questionsModel.id,
          collectionRef: APIPath.challenges(
              questId: widget.questModel.id,
              locationId: widget.locationModel.id),
          locationTitle: widget.locationModel.title,
        );
      } else {
        setState(() {
          _imageA = 'images/4.0x/ic_a_wrong.png';
          _submitted = true;
        });
         final snackBar = SnackBar(
          content: Text(
            'Oh no, wrong answer!',
            style: TextStyle(fontSize: 18,),
          ),
          
        );
        Scaffold.of(context).showSnackBar(snackBar);
        await Future.delayed(Duration(milliseconds: 4300));
        setState(() {
          _imageA = 'images/4.0x/ic_a_neutral.png';
          _submitted = false;
        });
         
       
      }
    
  }
  void _submitB() async {
    
      if (widget.questionsModel.answerB.containsValue(true)) {
        setState(() {
          _imageB = 'images/4.0x/ic_b_correct.png';
        _submitted = true;
        });
        
        QuestionViewModel.submit(
          context,
          isLocation: false,
          isFinalChallenge: widget.isFinalChallenge,
          documentId: widget.questionsModel.id,
          collectionRef: APIPath.challenges(
              questId: widget.questModel.id,
              locationId: widget.locationModel.id),
          locationTitle: widget.locationModel.title,
        );
      } else {
        setState(() {
          _imageB = 'images/4.0x/ic_b_wrong.png';
          _submitted = true;
        });
         final snackBar = SnackBar(
          content: Text(
            'Oh no, wrong answer!',
            style: TextStyle(fontSize: 18,),
          ),
          
        );
        Scaffold.of(context).showSnackBar(snackBar);
        await Future.delayed(Duration(milliseconds: 4300));
        setState(() {
          _imageB = 'images/4.0x/ic_b_neutral.png';
          _submitted = false;
        });
         
       
      }
    
  }
  void _submitC() async {
    
      if (widget.questionsModel.answerC.containsValue(true)) {
        setState(() {
          _imageC = 'images/4.0x/ic_c_correct.png';
        _submitted = true;
        });
        
        QuestionViewModel.submit(
          context,
          isLocation: false,
          isFinalChallenge: widget.isFinalChallenge,
          documentId: widget.questionsModel.id,
          collectionRef: APIPath.challenges(
              questId: widget.questModel.id,
              locationId: widget.locationModel.id),
          locationTitle: widget.locationModel.title,
        );
      } else {
        setState(() {
          _imageC = 'images/4.0x/ic_c_wrong.png';
          _submitted = true;
        });
         final snackBar = SnackBar(
          content: Text(
            'Oh no, wrong answer!',
            style: TextStyle(fontSize: 18,),
          ),
          
        );
        Scaffold.of(context).showSnackBar(snackBar);
        await Future.delayed(Duration(milliseconds: 4300));
        setState(() {
          _imageC = 'images/4.0x/ic_c_neutral.png';
          _submitted = false;
        });
         
       
      }
    
  }
  void _submitD() async {
    
      if (widget.questionsModel.answerD.containsValue(true)) {
        setState(() {
          _imageD = 'images/4.0x/ic_d_correct.png';
        _submitted = true;
        });
        
        QuestionViewModel.submit(
          context,
          isLocation: false,
          isFinalChallenge: widget.isFinalChallenge,
          documentId: widget.questionsModel.id,
          collectionRef: APIPath.challenges(
              questId: widget.questModel.id,
              locationId: widget.locationModel.id),
          locationTitle: widget.locationModel.title,
        );
      } else {
        setState(() {
          _imageD = 'images/4.0x/ic_d_wrong.png';
          _submitted = true;
        });
         final snackBar = SnackBar(
          content: Text(
            'Oh no, wrong answer!',
            style: TextStyle(fontSize: 18,),
          ),
          
        );
        Scaffold.of(context).showSnackBar(snackBar);
        await Future.delayed(Duration(milliseconds: 4300));
        setState(() {
          _imageD = 'images/4.0x/ic_d_neutral.png';
          _submitted = false;
        });
         
       
      }
    
  }
}
