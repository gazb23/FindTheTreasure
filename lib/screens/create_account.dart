import 'package:flutter/material.dart';

class CreateAccount extends StatelessWidget {
  static const String id = 'create_account';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
         icon: Icon(Icons.arrow_back, color: Colors.black,),
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
          DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bckgrnd.png')
              )
            ),
          )
        ],
      ),
    );
  }
}
