import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableCard extends StatelessWidget {
  final String question;
  final String answer;

  const ExpandableCard({
    Key key,
    this.question,
    this.answer,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 6),
        elevation: 3,
          color: Colors.orangeAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ExpandablePanel(
            theme: ExpandableThemeData(
              iconColor: Colors.white,
              hasIcon: true,
              
            ),
            header: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              leading: Icon(Icons.help_outline, color: Colors.white,),
              title: Text(question, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            expanded: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(answer, style: TextStyle(color: Colors.black87,), textAlign: TextAlign.left,),
              ),
            ),
          )),
    );
  }
}
