


import 'package:device_preview/device_preview.dart';
import 'package:find_the_treasure/presentation/active_quest/active_quest_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/home_page.dart';
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


void main() => runApp(

  DevicePreview(
    builder: (context) => MyApp(),
    enabled: false,
  ),
);


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
          debugShowCheckedModeBanner: false,
          locale: DevicePreview.of(context).locale, // <--- Add the locale
      builder: DevicePreview.appBuilder, // <--- Add the builder
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
            HomePage.id: (context) => HomePage(),
            ActiveQuestScreen.id : (context) => ActiveQuestScreen(),
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
          headline5: TextStyle(
              color: Colors.black54, fontSize: 28, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontFamily: 'quicksand'),
              bodyText1: TextStyle(
              fontSize: 18,
              color: Colors.white,
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
        actionsIconTheme: IconThemeData(
          color: Colors.black87
        ),
          color: Colors.white,
          textTheme: TextTheme(
              headline5: TextStyle(fontFamily: 'quicksand', fontSize: 20, color: Colors.black87))),
              iconTheme: IconThemeData(
                color: Colors.black87

              )
    );
  }
}
