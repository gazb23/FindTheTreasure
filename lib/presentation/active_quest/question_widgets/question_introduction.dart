import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:flutter/material.dart';

class QuestionIntroduction extends StatelessWidget {
  final BuildContext context;
  final LocationModel locationModel;
  final QuestionsModel questionsModel;
  final bool locationQuestion;
  final bool showImage;

  const QuestionIntroduction({
    Key key,
    @required this.context,
    @required this.locationModel,
    @required this.questionsModel,
    @required this.locationQuestion,
    this.showImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: showImage ? MediaQuery.of(context).size.height / 2.5 : MediaQuery.of(context).size.height / 3,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
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
              child: Column(
                children: <Widget>[
                  Text(

                    locationQuestion
                        ? locationModel.questionIntroduction
                        : questionsModel.questionIntroduction,
                    style: TextStyle(
                      
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: showImage ? 3 : null,
                  ),
                  SizedBox(height: 10,),
                  showImage
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 4,
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(40)),
                            image: DecorationImage(
                                image: NetworkImage(
                                  questionsModel.image,
                                ),
                                fit: BoxFit.fill,
                                alignment: Alignment.center),
                          )),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
