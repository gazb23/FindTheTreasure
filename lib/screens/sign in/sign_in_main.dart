import 'package:find_the_treasure/screens/sign%20in/email_create_account_page.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets/platform_exception_alert_dialog.dart';


import 'package:find_the_treasure/widgets/sign_in_button.dart';
import 'package:find_the_treasure/widgets/social_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_page.dart';

class SignInMain extends StatelessWidget {
  static const String id = 'sign_in_main';

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(title: 'Sign in failed',
    exception: exception,).show(context);
  }
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER')
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signInWithFacebook();
    } on PlatformException catch (e) {
       if (e.code != 'ERROR_ABORTED_BY_USER')
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lock this screen to portrait orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          'images/slide_1.png',
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
        
        FractionallySizedBox(          
          widthFactor: 0.9,
          child: Container(            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                
                SocialSignInButton(
                  assetName: 'images/facebook-logo.png',
                  text: 'Sign in with Facebook',
                  textcolor: Colors.white,
                  color: Color(0xFF4267B2),
                  onPressed: () => _signInWithFacebook(context),
                ),
                SocialSignInButton(
                  assetName: 'images/google-logo.png',
                  text: 'Sign in with Google',
                  textcolor: Colors.black87,
                  color: Colors.grey[100],
                  onPressed: () => _signInWithGoogle(context),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    'OR',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SignInButton(
                  text: 'Create Account',
                  textcolor: Colors.white,
                  color: Colors.orangeAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, EmailCreateAccountPage.id);
                  },
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, EmailSignInPage.id);
                  },
                  child: Text(
                    'Already registered? Sign in here.',
                    textAlign: TextAlign.center,
                  ),
                ),
                
              ],
            ),
          ),
        )
      ],
    );
  }
}
