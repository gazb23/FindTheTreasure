import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets_common/avatar.dart';
import 'package:find_the_treasure/widgets_common/custom_list_view.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'account_page';

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSingOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',      
    ).show(context);
    if (didRequestSingOut) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
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
                _buildUserInfo(context, user),
                _buildTreasure(context, user),
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
                photoURL: user.photoURL,
                radius: 50,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Text(
                user.displayName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            FlatButton(
              child: Text('LOGOUT'),
              onPressed: () => _confirmSignOut(context),
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


