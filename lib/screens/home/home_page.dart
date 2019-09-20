import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {

  final VoidCallback onSignOut;
  HomePage({@required this.onSignOut});
  
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/andicon.png'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Sign out'),
            onPressed: _signOut
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
