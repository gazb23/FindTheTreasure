import 'dart:ui';
import 'package:apple_sign_in/apple_sign_in_button.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:find_the_treasure/blocs/sign_in/sign_in_bloc.dart';
import 'package:find_the_treasure/presentation/sign_in/screens/email_create_account_screen.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/authentication/apple_sign_in_available.dart';
import 'package:find_the_treasure/widgets_common/platform_exception_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:find_the_treasure/widgets_common/social_sign_in_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'email_sign_in_screen.dart';

class SignInMainScreen extends StatefulWidget {
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

  @override
  _SignInMainScreenState createState() => _SignInMainScreenState();
}

class _SignInMainScreenState extends State<SignInMainScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<Size> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 2000,
      ),
    );

    animation = Tween<Size>(begin: Size(0, 0), end: Size(250, 250))
        .animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceOut,
    ));
    animationController.forward();
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  void _showDuplicateAccountSignInError(
      BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  void _showNetworkError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Network Error',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await widget.bloc.signInWithGoogle();
    } on PlatformException catch (e) {
      print('ERROR:' + e.toString());
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      } else if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
        _showDuplicateAccountSignInError(context, e);
      } else if (e.code == 'network_error') {
        _showNetworkError(context, e);
      } else {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final authService = Provider.of<AuthBase>(context, listen: false);
      final user = await authService
          .signInWithApple(scopes: [Scope.email, Scope.fullName]);
      print('uid: ${user.uid}');
    } catch (e) {
      print(e);
    }
  }

  // Future<void> _signInWithFacebook(BuildContext context) async {

  //   try {
  //     await widget.bloc.signInWithFacebook();
  //   } on PlatformException catch (e) {
  //     if (e.code != 'ERROR_ABORTED_BY_USER') {
  //       _showSignInError(context, e);
  //     }

  //     }
  // }

  @override
  Widget build(BuildContext context) {
    // Lock this screen to portrait orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        backgroundColor: Colors.white,
        body: widget.isLoading
            ? Center(
                child: Image.asset(
                  'images/compass.gif',
                  height: 200,
                  semanticLabel: 'Screen loading',
                ),
              )
            : Stack(children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: const AssetImage("images/bckgrnd.png"),
                          fit: BoxFit.cover),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 7,
                        sigmaY: 7,
                      ),
                      child: Container(color: Colors.black.withOpacity(0.1)),
                    )),
                _buildContent(context),
              ]));
  }

  Widget _buildContent(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
    if (widget.isLoading) {
      return Center(
        child: Image.asset(
          'images/compass.gif',
          height: 200,
          semanticLabel: 'Screen loading',
        ),
      );
    } else
      return Column(children: <Widget>[
        Expanded(
          flex: 4,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Container(
              width: animation.value.width,
              height: animation.value.height,
              child: Image.asset(
                'images/3.0x/ic_excalibur_owl.png',
                semanticLabel: 'Owl with sword.',
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (appleSignInAvailable.isAvailable)
                      AppleSignInButton(
                        style: ButtonStyle.white,
                        cornerRadius: 35, // style as needed
                        type: ButtonType.signIn, // style as needed
                        onPressed: () => _signInWithApple(context),
                      ),
                    // SocialSignInButton(
                    //     assetName: 'images/facebook-logo.png',
                    //     text: 'Sign in with Facebook',
                    //     textcolor: Colors.white,
                    //     color: Color(0xFF4267B2),
                    //     onPressed: () => _signInWithFacebook(context)
                    //     // : _showConnectionFailureDialog(context),
                    //     ),
                    SocialSignInButton(
                        assetName: 'images/google-logo.png',
                        text: 'Sign in with Google',
                        textcolor: Colors.black87,
                        color: Colors.grey[100],
                        onPressed: () => _signInWithGoogle(context)),
                    Center(
                      child: Text(
                        'OR',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    SignInButton(
                      text: 'Create Account',
                      textcolor: Colors.white,
                      padding: 12,
                      color: MaterialTheme.orange,
                      onPressed: () {
                        Navigator.pushNamed(
                            context, EmailCreateAccountScreen.id);
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
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'quicksand'),
                          children: [
                            TextSpan(
                                text:
                                    'By continuing you agree to Find the Treasure\'s '),
                            TextSpan(
                                text: 'Terms & Conditions ',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(
                                        'https://www.findthetreasure.com.au/terms-conditions/');
                                  },
                                style: TextStyle(color: MaterialTheme.orange)),
                            TextSpan(text: 'and '),
                            TextSpan(
                                text: 'Privacy Policy.',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(
                                        'https://www.findthetreasure.com.au/privacy-policy/');
                                  },
                                style: TextStyle(color: MaterialTheme.orange))
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
