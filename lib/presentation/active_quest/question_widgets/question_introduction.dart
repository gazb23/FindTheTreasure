import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:flutter/material.dart';

class QuestionIntroduction extends StatelessWidget {
  final BuildContext context;
  final LocationModel locationModel;
  final QuestionsModel questionsModel;
  final bool locationQuestion;

  const QuestionIntroduction({
    Key key,
    @required this.context,
    @required this.locationModel,
    @required this.questionsModel,
    @required this.locationQuestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
      return Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
             
              maxHeight: MediaQuery.of(context).size.height/5,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  EdgeInsets.only(top: 20, left: 20, right: 30, bottom: 20),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0.3, 0.1),
                        blurRadius: 1.0,
                        spreadRadius: 1.0)
                  ],
                  color: Colors.grey.shade800,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(50))),
              child: SingleChildScrollView(
                child: Text(
                  locationQuestion
                      ? locationModel.questionIntroduction
                      : questionsModel.questionIntroduction,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );
    }
  }

