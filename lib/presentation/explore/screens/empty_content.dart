import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String message;
  

  const EmptyContent({Key key, this.title = 'No Quests Currently Available', this.message = 'New Quests coming soon!'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.title, textAlign: TextAlign.center,
            ),
            SizedBox(height: 15,),
            Image.asset('images/ic_excalibur_owl.png'),
            SizedBox(height: 15,),
            Text(message, style: Theme.of(context).textTheme.body1)
              
          ],
        ),
      ),
    );
  }
}
