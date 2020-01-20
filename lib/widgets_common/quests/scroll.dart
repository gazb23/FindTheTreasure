
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:flutter/material.dart';


class Scroll extends StatelessWidget {
  final QuestionsModel questionsModel;

  const Scroll({Key key, this.questionsModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          color: Colors.brown.shade50,
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 2.5),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Text(
                  questionsModel.question,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
              ),
            ),
          ),
        ),
        Image.asset('images/roll_left.png'),
        Align(
            alignment: Alignment.topRight,
            child: Image.asset('images/roll_right.png')),
        Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'images/roll_right.png',
            )),
        Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              'images/roll_left.png',
            )),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 22),
            color: Colors.brown.shade100.withOpacity(.8),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 10,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 22),
            color: Colors.brown.shade100.withOpacity(.8),
          ),
        )
      ]),
    );
  }
}
