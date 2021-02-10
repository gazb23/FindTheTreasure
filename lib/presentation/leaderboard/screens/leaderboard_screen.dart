import 'dart:ui';

import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/presentation/leaderboard/screens/leaderboard_user_profile.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/leaderboard.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    final _database = Provider.of<DatabaseService>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: const AssetImage("images/background_games.png"),
                  fit: BoxFit.fill),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 155.0),
            child: LeaderboardListTile(databaseService: _database),
          ),
          LeaderboardTitle(),
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10),
                child: Image.asset(
                  'images/2.0x/ic_trophy.png',
                  height: 90,
                ),
              )),
        ],
      ),
    );
  }
}

class LeaderboardTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 10, right: 10, top: 55 + MediaQuery.of(context).padding.top),
      height: 100,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Divider(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'No.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: const Text(
                  'Player name',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
                const Text(
                  'Points',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LeaderboardListTile extends StatelessWidget {
  final DatabaseService databaseService;

  const LeaderboardListTile({Key key, @required this.databaseService})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserData>>(
      
        stream: databaseService.usersStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<UserData>(
              title: 'Error',
              message:
                  'Oh no! Unfortunately we cannot find the dang leaderboard at the moment. Please try again later.',
              snapshot: snapshot,
              itemBuilder: (context, user, index) => LeaderBoardTile(
                    place: index + 1,
                    photoURL: user.photoURL ?? null,
                    displayName: user.displayName,
                    points: user.points,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => LeaderboardProfileScreen(
                                  userData: user,
                                )),
                      );
                    },
                  ));
        });
  }
}
