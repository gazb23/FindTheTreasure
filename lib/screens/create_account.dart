import 'package:flutter/material.dart';

class CreateAccount extends StatelessWidget {
  static const String id = 'create_account';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/bckgrnd.png',
            fit: BoxFit.cover,
          ),
          Container(
            margin: EdgeInsets.only(
                top: 40.0, right: 40.0, bottom: 150.0, left: 40.0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30.0)),
            child: Column(
              children: <Widget>[
                TextField(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
