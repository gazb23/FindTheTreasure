import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets_common/avatar.dart';
import 'package:find_the_treasure/widgets_common/custom_list_view.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'account_page';

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
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
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background_team.png"),
                    fit: BoxFit.cover),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
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
        Container(
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(10)),
          width: 10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                'images/4.0x/ic_diamond.png',
                height: 35,
              ),
              Text(
                user.userDiamondCount.toString(),
                style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Image.asset(
                'images/explore/key.png',
                height: 60.0,
              ),
              Text(
                user.userKeyCount.toString(),
                style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Log out functionality

