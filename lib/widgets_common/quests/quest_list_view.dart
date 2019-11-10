import 'package:flutter/material.dart';

class QuestListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      height: 250.0,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Placeholder(
              
              color: Colors.grey,
              fallbackHeight: 150.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              
              children: <Widget>[
                Text('Waterfall Quest')
              ],
            ),
          )
        ],
      ),
    );
  }
}
