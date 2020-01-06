import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/active_quest/active_quest_start_screen.dart';
import 'package:find_the_treasure/presentation/explore/screens/quest_detail_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyQuestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      theme: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.grey.shade800,
          ),
        ),
      
      home: DefaultTabController(
        length: 3,
        child: SafeArea(
                  child: Scaffold(
            appBar: AppBar(
              
              bottom: TabBar(
                indicatorColor: Colors.orangeAccent,
                labelColor: Colors.white,
                labelStyle: TextStyle(
                    fontFamily: 'quicksand', fontWeight: FontWeight.bold),
                tabs: <Widget>[
                  Tab(
                    text: 'Current',
                  ),
                  Tab(
                    text: 'Liked',
                  ),
                  Tab(
                    text: 'Conquered',
                  ),
                ],
              ),
              title: Text(
                'Your Quests',
                style:
                    TextStyle(fontFamily: 'JosefinSans', color: Colors.white),
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                QuestStartScreen(),
                _buildUserQuestListView(context),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
          ),
        ),
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
            title: 'Time to add some favourites!',
            message:
                'Head to the explore page, and when you find a quest you like tap on the heart icon to save it.',
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
                QuestDetailScreen.show(context,
                    quest: quest, user: user, database: database);
              },
            ),
          );
        });
  }
}
