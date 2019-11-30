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
        appBar: AppBar(
          centerTitle: true,
          title: Text('Profile', style: TextStyle(color: Colors.black87)),
          actions: <Widget>[
            FlatButton(
              child: Text('LOGOUT'),
              onPressed: () => _confirmSignOut(context),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: _buildUserInfo(user),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background_team.png"),
                    fit: BoxFit.cover),
              ),
            ),
            _buildTreasure(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserData user) {
    return Column(
      children: <Widget>[
        Avatar(
          photoURL: user.photoURL,
          radius: 50,
        ),
        SizedBox(
          height: 8,
        ),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(color: Colors.black87),
          ),
        SizedBox(
          height: 8.0,
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
        Container(
          
          width: 50.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                'images/4.0x/ic_diamond.png',
                height: 45,
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
                height: 70.0,
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
