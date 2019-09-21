import 'package:find_the_treasure/screens/home/home_page.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/material.dart';
import 'sign_in_main.dart';

class LandingPage extends StatefulWidget {
  static const String id = 'landing_page';
  final AuthBase auth;
  LandingPage({@required this.auth});
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User user = await widget.auth.currentUser();
    _updateUser(user);
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            if (user == null) {
              return SignInMain(
                auth: widget.auth,
                onSignIn: (user) => _updateUser(user),
              );
            }
            return HomePage(
              auth: widget.auth,
              onSignOut: () => _updateUser(null),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
