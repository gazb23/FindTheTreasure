      import 'package:flutter/material.dart';

class AnswerBox extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, ),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 1.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              
              TextField(

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: 'Enter your answer',
                  suffixIcon: Image.asset('images/tick_small.png')
                ),
              ),
              SizedBox(height: 10,)
            ]),
      ),
    );
        }
      }
