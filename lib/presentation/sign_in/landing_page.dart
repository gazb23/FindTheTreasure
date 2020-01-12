
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/widgets/home_page.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/sign_in_main_screen.dart';

class LandingPage extends StatelessWidget {
  // id is a named route for the main()
  static const String id = 'landing_page';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(      
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user != null) {
              return MultiProvider(
                providers: [
                  Provider<User>.value(
                    value: user,
                  ),
                  Provider<DatabaseService>(
                    create: (_) => DatabaseService(uid: user.uid),
                  ),
                  
                ],
                child: Consumer<DatabaseService>(
                  builder: (_, databaseService, __) => StreamProvider<UserData>(
                    create: (_) => databaseService.userDataStream(),
                    child: HomePage(),
                  ),
                ),
              );
            } else
              return SignInMainScreen.create(context);
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(backgroundColor: Colors.orangeAccent,),
            ),
          );
        });
  }
}
