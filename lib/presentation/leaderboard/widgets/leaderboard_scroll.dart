import 'package:flutter/material.dart';

class LeaderboardScroll extends StatelessWidget {
  final Widget child;

  const LeaderboardScroll({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:0),
      child: Stack(children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          color: Colors.brown.shade50,
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(
              minHeight: 200,
              maxHeight: MediaQuery.of(context).size.height / 2.5),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: child
              ),
            ),
          ),
        ),
        Image.asset('images/roll_left.png'),
        Align(
            alignment: Alignment.topRight,
            child: Image.asset('images/roll_right.png')),
        Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'images/roll_right.png',
            )),
        Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              'images/roll_left.png',
            )),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 22),
            color: Colors.brown.shade100.withOpacity(.8),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 10,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 22),
            color: Colors.brown.shade100.withOpacity(.8),
          ),
        )
      ]),
    );
  }
}
