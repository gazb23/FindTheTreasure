import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/leaderboard/widgets/leaderboard_scroll.dart';
import 'package:find_the_treasure/presentation/leaderboard/widgets/user_profile_list_tile.dart';
import 'package:find_the_treasure/widgets_common/avatar.dart';

import 'package:flutter/material.dart';

class LeaderboardProfileScreen extends StatefulWidget {
  final UserData userData;

  const LeaderboardProfileScreen({
    Key key,
    @required this.userData,
  }) : super(key: key);

  @override
  _LeaderboardProfileScreenState createState() =>
      _LeaderboardProfileScreenState();
}

class _LeaderboardProfileScreenState extends State<LeaderboardProfileScreen> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Stack(children: [
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("images/background_team.png"),
                  fit: BoxFit.cover),
            ),
            child: Container(
              child: ListView(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildUserInfo(widget.userData),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: LeaderboardScroll(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTreasureTile(),
                              _buildLocationsExploredTile(),
                              _buildPointsTile(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ]),
    );
  }

  Widget _buildUserInfo(UserData user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Avatar(
            borderColor: Colors.white,
            borderWidth: 5,
            photoURL: user.photoURL,
            radius: 80,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: AutoSizeText(
            user.displayName,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTreasureTile() {
    return UserProfileListTile(
      image: 'images/diamond2.png',
      imageHeight: 30,
      title: 'Diamonds',
      number: widget.userData.userDiamondCount,
    );
  }

  Widget _buildLocationsExploredTile() {
    return UserProfileListTile(
      image: 'images/hiker.png',
      imageHeight: 35,
      title: 'Locations Explored',
      number: widget.userData.locationsExplored.length,
    );
  }

  Widget _buildPointsTile() {
    return UserProfileListTile(
      image: 'images/podium.png',
      imageHeight: 35,
      title: 'Points',
      number: widget.userData.points,
    );
  }

  // Widget _buildLocations(List location, UserData userData) {
  //   if (location.length > 0)
  //     return Column(
  //         children: location
  //             .map((location) => ListTile(
  //                   contentPadding: const EdgeInsets.symmetric(horizontal: 30),
  //                   leading: const Icon(
  //                     Icons.done,
  //                     color: Colors.amberAccent,
  //                   ),
  //                   title: AutoSizeText(
  //                     location,
  //                     maxLines: 2,
  //                     style: const TextStyle(color: Colors.white, fontSize: 20),
  //                   ),
  //                 ))
  //             .toList());
  //   else
  //     return Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Center(
  //             child: Image.asset(
  //           'images/ic_owl_wrong_dialog.png',
  //           height: 75,
  //         )),
  //         const Text(
  //           'It\'s OWL good!',
  //           style: const TextStyle(color: Colors.white, fontSize: 20),
  //         )
  //       ],
  //     );
  // }
}
