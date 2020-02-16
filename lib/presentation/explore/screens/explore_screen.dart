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
    
  
    // Lock this screen to portrait orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        final _userData = Provider.of<UserData>(context);
        
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            'Find The Treasure',
            style: TextStyle(color: Colors.grey),
          ),
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
          actions: <Widget>[
            DiamondAndKeyContainer(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              numberOfDiamonds: 10,
              numberOfKeys: 10,
              color: Colors.black87,
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
                } 
                
                
              
            ),
          );
        });
  }
}
