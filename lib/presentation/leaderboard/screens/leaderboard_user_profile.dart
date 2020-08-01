import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:find_the_treasure/models/user_model.dart';
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
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.05),
                child: ListView(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildUserInfo(context, widget.userData),
                        SizedBox(
                          height: 50,
                        ),
                        _buildTreasureTile(context, widget.userData),
                        _buildLocationsExploredTile(context, widget.userData)
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ]),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserData user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Avatar(
            borderColor: Colors.white,
            borderWidth: 3,
            photoURL: user.photoURL,
            radius: 70,
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

  Widget _buildTreasureTile(BuildContext context, UserData userData) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Card(
        color: Colors.brown.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ExpandablePanel(
            theme: ExpandableThemeData(iconColor: Colors.white),
            header: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              leading: Image.asset(
                'images/treasure.png',
                height: 50,
              ),
              title: Text(
                'Bounty',
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            expanded: Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    leading: Image.asset('images/ic_diamond.png'),
                    title: AutoSizeText(
                      'Diamonds',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    trailing: AutoSizeText(
                      userData.userDiamondCount.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    leading: Image.asset(
                      'images/explore/skull_key.png',
                      height: 30,
                    ),
                    title: AutoSizeText(
                      'Keys',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    trailing: AutoSizeText(
                      userData.userKeyCount.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent),
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildLocationsExploredTile(BuildContext context, UserData userData) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Card(
          color: Colors.grey.shade500,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ExpandablePanel(
              theme: ExpandableThemeData(iconColor: Colors.white),
              header: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                leading: Image.asset(
                  'images/hiker.png',
                  height: 50,
                ),
                title: AutoSizeText(
                  'Locations Explored',
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  userData.locationsExplored.length.toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              expanded: Column(
                children: <Widget>[
                  _buildLocations(userData.locationsExplored, userData),
                  const SizedBox(height: 20)
                ],
              ))),
    );
  }

  Widget _buildLocations(List location, UserData userData) {
    if (location.length > 0)
      return Column(
          children: location
              .map((location) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    leading: const Icon(
                      Icons.done,
                      color: Colors.amberAccent,
                    ),
                    title: AutoSizeText(
                      location,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ))
              .toList());
    else
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Image.asset(
            'images/ic_owl_wrong_dialog.png',
            height: 75,
          )),
          const Text(
            'It\'s OWL good!',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          )
        ],
      );
  }
}
