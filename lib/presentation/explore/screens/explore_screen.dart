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

class ExploreScreen extends StatefulWidget {
  static const String id = 'explore_page';

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    final _userDiamondCount = Provider.of<UserData>(context).userDiamondCount;
    final _userKeyCount = Provider.of<UserData>(context).userKeyCount;
    
    // Lock this screen to portrait orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
     backgroundColor: Colors.orangeAccent,

          leading: Icon(Icons.search, color: Colors.white,),
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
          actions: <Widget>[
            DiamondAndKeyContainer(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              numberOfDiamonds: _userDiamondCount,
              numberOfKeys: _userKeyCount,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: _buildListView(context),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
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
