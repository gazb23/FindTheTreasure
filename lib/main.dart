import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:find_the_treasure/presentation/active_quest/active_quest_screen.dart';
import 'package:find_the_treasure/presentation/explore/screens/intro_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/home_page.dart';
import 'package:find_the_treasure/presentation/profile/screens/profile_screen.dart';
import 'package:find_the_treasure/presentation/sign_in/screens/email_create_account_screen.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/services/connectivity_service.dart';
import 'package:find_the_treasure/services/data_connectivity_service.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/authentication/apple_sign_in_available.dart';
import 'package:find_the_treasure/widgets_common/authentication/auth_widget.dart';
import 'package:find_the_treasure/widgets_common/authentication/auth_widget_builder.dart';
import 'package:flutter/material.dart';
import 'presentation/sign_in/screens/email_sign_in_screen.dart';
import 'presentation/sign_in/screens/password_reset_screen.dart';
import 'presentation/sign_in/screens/sign_in_main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  // Fix for: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  WidgetsFlutterBinding.ensureInitialized();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: MyApp(),
  ));
}

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
          create: (context) =>
              DataConnectivityService().connectivityStreamController.stream,
        )
      ],
      child: AuthWidgetBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
          // Keep text scaling correct when user changes text scale on phone
            builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaleFactor.clamp(0.8, 1.35);
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
        );
      },
          debugShowCheckedModeBanner: false,
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
            ActiveQuestScreen.id: (context) => ActiveQuestScreen(),
            IntroScreen.id: (context) => IntroScreen()
          },
        );
      }),
    );
  }
}
