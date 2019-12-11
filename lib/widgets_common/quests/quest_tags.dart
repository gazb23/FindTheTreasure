import 'package:flutter/material.dart';

class QuestTags extends StatelessWidget {

  final String title;

  const QuestTags({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10)
        
      ),
      child: Text(title,textDirection: TextDirection.ltr, style: TextStyle(color: Colors.white, fontSize: 12, ),),
    );
  }
}