import 'package:find_the_treasure/blocs/sign%20in/sign_in_bloc.dart';
import 'package:find_the_treasure/presentation/sign_in/screens/email_create_account_screen.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets_common/platform_exception_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:find_the_treasure/widgets_common/social_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_screen.dart';
import 'package:carousel_pro/carousel_pro.dart';

class SignInMainScreen extends StatelessWidget {
  static const String id = 'sign_in_main';
  final SocialSignInBloc bloc;
  final bool isLoading;
  const SignInMainScreen({
    Key key,
    this.bloc,
    this.isLoading,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SocialSignInBloc>(
          create: (_) => SocialSignInBloc(auth: auth, isLoading: isLoading),
          child: Consumer<SocialSignInBloc>(
            builder: (context, bloc, _) => SignInMainScreen(
              bloc: bloc,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
      
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await bloc.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') _showSignInError(context, e);
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
    // Create a circular progress indicator if there are any network delays
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Carousel(
            images: [
              Image.asset(
                'images/slide_1.png',
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
              Image.asset(
                'images/slide_2.png',
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
              Image.asset(
                'images/slide_3.png',
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              )
            ],
            showIndicator: false,
            animationCurve: Curves.easeIn,
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
                      Navigator.pushNamed(context, EmailCreateAccountScreen.id);
                    },
                  ),
                  FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () {
                      Navigator.pushNamed(context, EmailSignInScreen.id);
                    },
                    child: Text(
                      'Already registered? Sign in here.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          )
        ],
      );
  }
}
