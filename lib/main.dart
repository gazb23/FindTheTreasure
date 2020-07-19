


import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:device_preview/device_preview.dart';
import 'package:find_the_treasure/presentation/active_quest/active_quest_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/home_page.dart';
import 'package:find_the_treasure/presentation/profile/screens/profile_screen.dart';
import 'package:find_the_treasure/presentation/sign_in/screens/email_create_account_screen.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/services/connectivity_service.dart';
import 'package:find_the_treasure/services/data_connectivity_service.dart';
import 'package:find_the_treasure/theme.dart';
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
        StreamProvider<DataConnectionStatus>(
          create: (context) => DataConnectivityService().connectivityStreamController.stream,
        )
      ],
      child: AuthWidgetBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: true,
          locale: DevicePreview.of(context).locale, // <--- Add the locale
      builder: DevicePreview.appBuilder, // <--- Add the builder
          title: 'Find The Treasure',
          theme: MaterialTheme.buildThemeData(),
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


}
