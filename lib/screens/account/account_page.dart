
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets/platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
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
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Image.asset('images/andicon.png'),
          actions: <Widget>[
            FlatButton(
              child: Text('LOGOUT'),
              onPressed: () => _confirmSignOut(context),
            )
          ],
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
          ],
        ),
      ),
    );
  }
}
