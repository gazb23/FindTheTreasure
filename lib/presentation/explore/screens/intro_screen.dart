import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/widgets/home_page.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';

import 'package:find_the_treasure/widgets_common/quests/generic_scroll.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool _isLoading = false;
bool _isFinished = false;
bool _showTreasure = false;
bool _startAnimation = false;
class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    UserData _userData = Provider.of<UserData>(context);
    DatabaseService _database = Provider.of<DatabaseService>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        
          backgroundColor: Colors.brown,
          body: Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            'images/3.0x/ic_avatar_pirate.png',
            height: 125,
          ),
          GestureDetector(
            onTap: () {
                setState(() {
                  _startAnimation =true;
                });
              },
                            child: CustomScroll(
              question: _startAnimation ? TyperAnimatedTextKit(
                
                  pause: Duration(seconds: 2),
                  text: [
                    'Hello, ${_userData.displayName} and welcome to Find The Treasure.',
                    'I have burried treasure all over this great land for you to discover.',
                    'but finding these burried bounties won\'t be easy...',
                    'You\'ll explore new lands, conquer quests and solve challenging puzzels.',
                    'To help you along your way I\'ve given you 50 diamonds and 1 key.',
                    'Are you ready for adventure?'
                  ],
                  textStyle: TextStyle(color: Colors.black87, fontSize: 26),
                  isRepeatingAnimation: false,
                  speed: Duration(milliseconds: 90),
                  textAlign: TextAlign.center,
                  alignment: AlignmentDirectional.center,
                  onNextBeforePause: (index, isLast) {
                    switch (index) {
                      case 4:
                        setState(() {
                          _showTreasure = true;
                        });
                        break;
                      default:
                    }
                  },
                  onFinished: () {
                    setState(() {
                      _isFinished = true;
                    });
                  }) : Text('Tap to start.' , style: TextStyle(color: Colors.black87, fontSize: 28),)
            ),
          ),
          AnimatedOpacity(
            opacity: _showTreasure ? 1 : 0,
            duration: Duration(seconds: 2),
            child: DiamondAndKeyContainer(
              numberOfDiamonds: 50,
              numberOfKeys: 1,
              mainAxisAlignment: MainAxisAlignment.center,
              diamondHeight: 50,
              skullKeyHeight: 60,
              fontSize: 20,
            ),
          ),
          AnimatedOpacity(
            opacity: _isFinished ? 1 : 0,
            duration: Duration(seconds: 2),
                            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: SignInButton(
                text: 'START',
                isLoading: _isLoading,
                padding: 15,
                onPressed: _isLoading || _isFinished == false
                    ? null
                    : () {
                        _isLoading = !_isLoading;
                        final UserData updatedUserData = UserData(
                            displayName: _userData.displayName,
                            email: _userData.email,
                            id: _userData.id,
                            isAdmin: _userData.isAdmin,
                            locationsExplored: _userData.locationsExplored,
                            photoURL: _userData.photoURL,
                            points: _userData.points,
                            userDiamondCount: _userData.userDiamondCount,
                            userKeyCount: _userData.userKeyCount,
                            uid: _userData.uid,
                            seenIntro: true);
                        try {
                          _database.updateUserData(
                              userData: updatedUserData);

                          Navigator.pushNamed(context, '/');
                        } catch (e) {
                          _isLoading = false;
                          print(e.toString());
                        }
                      },
              ),
            ),
          )
        ],
      )),
        ),
    );
  }
}
