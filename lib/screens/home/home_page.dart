
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets/platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSingout = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Leaving already!? Are you sure?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSingout) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('images/andicon.png'),
        actions: <Widget>[
          FlatButton(
            child: Text('Sign out'),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bckgrnd_frgt.png"),
                  fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
