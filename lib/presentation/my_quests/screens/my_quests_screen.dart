


import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/screens/quest_detail_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyQuestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Center(child: Image.asset('images/andicon.png', height: 50,)),
        ),
        body: _buildUserQuestListView(context)
          
        ),
      
    );
  }
    Widget _buildUserQuestListView(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);
    final user = Provider.of<UserData>(context);
    return StreamBuilder<List<QuestModel>>(
        stream: database.userLikedQuestsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<QuestModel>(
            snapshot: snapshot,
            itemBuilder: (context, quest) => QuestListView(              
              numberOfDiamonds: quest.numberOfDiamonds,
              difficulty: quest.difficulty,
              numberOfKeys: quest.numberOfKeys,
              title: quest.title,
              image: quest.image,
              numberOfLocations: quest.numberOfLocations,
              location: quest.location,
              questModel: quest,
              onTap: () {
                QuestDetailScreen.show(context, quest: quest, user: user, database: database );
                
              },
            ),
          );
          }
          
        );
  }
}
