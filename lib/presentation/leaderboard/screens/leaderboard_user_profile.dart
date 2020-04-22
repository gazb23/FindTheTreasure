import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/models/user_model.dart';

import 'package:find_the_treasure/widgets_common/avatar.dart';
import 'package:find_the_treasure/widgets_common/custom_list_view.dart';

import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:flutter/material.dart';


class LeaderboardProfileScreen extends StatelessWidget {
  final UserData userData;

  const LeaderboardProfileScreen({
    Key key,
    @required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background_team.png"),
                    fit: BoxFit.fill),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                _buildUserInfo(context, userData),
                _buildTreasure(context, userData),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserData user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Avatar(
                borderColor: Colors.white,
                borderWidth: 3,
                photoURL: user.photoURL,
                radius: 50,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
               constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width/1.5
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: AutoSizeText(
                user.displayName,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            
          ],
        ),
      ],
    );
  }

  Widget _buildTreasure(BuildContext context, UserData user) {
    return CustomListView(
      color: Colors.brown,
      children: <Widget>[
        Image.asset(
          'images/ic_treasure.png',
          height: 80,
        ),
        SizedBox(
          height: 10,
        ),
        DiamondAndKeyContainer(
          numberOfDiamonds: user.userDiamondCount,
          numberOfKeys: user.userKeyCount,
          diamondHeight: 40,
          skullKeyHeight: 60,
          fontSize: 20,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
