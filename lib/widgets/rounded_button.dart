import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function onpressed;

  RoundedButton({this.color, this.title, this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
          child: RaisedButton(
        color: color,
        child: Text(title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),),
        
        onPressed: onpressed,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        shape: StadiumBorder(),
        

      ),
    );
  }
}