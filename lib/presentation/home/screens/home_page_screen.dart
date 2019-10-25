import 'package:flutter/material.dart';

class HomePageSreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Center(child: Image.asset('images/andicon.png')),
        ),
        body: Stack(
          children: <Widget>[
            Container(            
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/bckgrnd_login.png"),
                    fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
