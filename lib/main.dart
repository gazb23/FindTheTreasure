import 'package:find_the_treasure/presentation/active_quest/question_widgets/question_scroll_single_answer.dart';
import 'package:find_the_treasure/presentation/profile/screens/profile_screen.dart';
import 'package:find_the_treasure/presentation/sign_in/screens/email_create_account_screen.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/services/connectivity_service.dart';
import 'package:find_the_treasure/widgets_common/authentication/auth_widget.dart';
import 'package:find_the_treasure/widgets_common/authentication/auth_widget_builder.dart';
import 'package:flutter/material.dart';
import 'presentation/sign_in/screens/email_sign_in_screen.dart';

import 'presentation/sign_in/screens/password_reset_screen.dart';
import 'presentation/sign_in/screens/sign_in_main_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(
          create: (context) => Auth(),
        ),
        StreamProvider<ConnectivityStatus>(
          create: (context) =>
              ConnectivityService().connectionStatusController.stream,
        ),
      ],
      child: AuthWidgetBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
          title: 'Find The Treasure',
          theme: _buildThemeData(),
          home: AuthWidget(userSnapshot: userSnapshot),
          routes: {
            // Each screen class has a static const to create that screen
            SignInMainScreen.id: (context) => SignInMainScreen(),
            EmailCreateAccountScreen.id: (context) =>
                EmailCreateAccountScreen(),
            EmailSignInScreen.id: (context) => EmailSignInScreen(),
            PasswordResetScreen.id: (context) => PasswordResetScreen(),            
            ProfileScreen.id: (context) => ProfileScreen(),
            QuestionScrollSingleAnswer.id: (context) => QuestionScrollSingleAnswer(),
            
          },
        );
      }),
    );
  }

// Theme for the app
  ThemeData _buildThemeData() {
    return ThemeData(
      buttonTheme: ButtonThemeData(
        height: 45.0,
      ),
      dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 22.0,
              fontWeight: FontWeight.w500),
          contentTextStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 18.0,
          )),
      fontFamily: 'quicksand',
      // Define the text theme for the app
      textTheme: TextTheme(
          title: TextStyle(
              color: Colors.black54, fontSize: 28, fontWeight: FontWeight.bold),
          body1: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontFamily: 'quicksand'),
          button: TextStyle(
            fontSize: 15.0,
          )),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[500])),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orangeAccent)),
        labelStyle: TextStyle(color: Colors.grey[500]),
      ),
      backgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
          color: Colors.white,
          textTheme: TextTheme(
              title: TextStyle(fontFamily: 'quicksand', fontSize: 20, color: Colors.black87))),
              iconTheme: IconThemeData(
                color: Colors.black87

              )
    );
  }
}
