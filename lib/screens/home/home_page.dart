import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {

  
  final AuthBase auth;
  HomePage({@required this.auth});
  
  Future<void> _signOut() async {
    try {
      await auth.signOut();      
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
