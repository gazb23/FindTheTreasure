import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String message;

  const EmptyContent({Key key, this.title = 'No Quests Currently Available', this.message = 'New Quests coming soon!'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title, style: TextStyle(
              fontSize: 32,
              color: Colors.black54
            ),),
            Text(message, style: TextStyle(
              fontSize: 16,
              color: Colors.black54),)
          ],
        ),
      ),
    );
  }
}
