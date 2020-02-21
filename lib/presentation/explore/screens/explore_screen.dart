import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';

import 'package:find_the_treasure/presentation/explore/screens/quest_detail_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatelessWidget {
  static const String id = 'explore_page';

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
    // Lock this screen to portrait orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // Needed a null check to be able to display UserData in the AppBar    
    int getUserDiamonds(BuildContext context) {
      int _userDiamondCount;

      if (_userData != null) {
        _userDiamondCount = _userData.userDiamondCount;
      }
      return _userDiamondCount;
    }

    int getUserKeys(BuildContext context) {
      int _userKeyCount;

      if (_userData != null) {
        _userKeyCount = _userData.userKeyCount;
      }
      return _userKeyCount;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade800,
          title: Text(
            'Find The Treasure',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
          actions: <Widget>[
            DiamondAndKeyContainer(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              numberOfDiamonds: getUserDiamonds(context),
              numberOfKeys: getUserKeys(context),
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: _buildListView(context, _userData),
      ),
    );
  }

  Widget _buildListView(BuildContext context, UserData _userData) {
    final database = Provider.of<DatabaseService>(context);
    return StreamBuilder<List<QuestModel>>(
        stream: database.questsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<QuestModel>(
            snapshot: snapshot,
            itemBuilder: (context, quest, index) => QuestListView(
                numberOfDiamonds: quest.numberOfDiamonds,
                difficulty: quest.difficulty,
                numberOfKeys: quest.numberOfKeys,
                title: quest.title,
                image: quest.image,
                numberOfLocations: quest.numberOfLocations,
                location: quest.location,
                questModel: quest,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => QuestDetailScreen(
                        userData: _userData,
                        questModel: quest,
                        database: database,
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
