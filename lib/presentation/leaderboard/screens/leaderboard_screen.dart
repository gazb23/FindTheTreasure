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
                  image: AssetImage("images/background_games.png"),
                  fit: BoxFit.fill),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 155.0),
            child: _buildListTile(_database),
          ),
          _buildLeaderBoardTitle(),
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Image.asset(
                  'images/2.0x/ic_trophy.png',
                  height: 90,
                ),
              )),
        ],
      ),
    );
  }

  Container _buildLeaderBoardTitle() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 55),
      height: 100,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
                  style: const TextStyle(),
                ),
               const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Text(
                  'Player name',
                  textAlign: TextAlign.center,
                )),
                Text('Points')
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListTile(DatabaseService _database) {
    return StreamBuilder<List<UserData>>(
        stream: _database.usersStream(),
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
