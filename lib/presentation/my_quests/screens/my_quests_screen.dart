import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/active_quest/active_quest_screen.dart';
import 'package:find_the_treasure/presentation/explore/screens/quest_detail_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyQuestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
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
            backgroundColor: Colors.grey.shade400,
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
                _buildCurrentQuestListView(context, database, user),
                _buildLikedQuestListView(context, database, user),
                _buildConqueredQuestListView(context, database, user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLikedQuestListView(
      BuildContext context, DatabaseService database, UserData user) {
    print('liked');

    return StreamBuilder<List<QuestModel>>(
        stream: database.questFieldContainsUID(field: 'likedBy'),
        builder: (context, snapshot) {
          return ListItemsBuilder<QuestModel>(
            title: 'Time to add some favourites!',
            message:
                'Head to the explore page, and when you find a quest you like tap on the heart icon to save it.',            
            buttonEnabled: false,
            image: Image.asset('images/owl_thumbs.png'),
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
                      database: database,
                      userData: user,
                      questModel: quest,
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  Widget _buildCurrentQuestListView(
      BuildContext context, DatabaseService database, UserData user) {  

    return StreamBuilder<List<QuestModel>>(
        stream: database.questFieldContainsUID(field: 'questStartedBy'),
        builder: (context, snapshot) {
          return ListItemsBuilder<QuestModel>(
            title: 'Ready for Adventure?',
            message: 'Head to the explore page, choose a quest to start your journey!',
            
            buttonEnabled: false,            
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
                final _questStartedBy = quest.questStartedBy.contains(user.uid);
                
                if (!_questStartedBy) {
                    Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => QuestDetailScreen(
                      userData: user,
                      questModel: quest,
                      database: database,
                    ),
                  ),
                );
                } else {
                  Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => ActiveQuestScreen(
                      questModel: quest,
                    ),
                  ),
                );
                }
              },
            ),
          );
        });
  }

   Widget _buildConqueredQuestListView(
      BuildContext context, DatabaseService database, UserData user) {
    print('current');

    return StreamBuilder<List<QuestModel>>(
        stream: database.questFieldContainsUID(field: 'questCompletedBy'),
        builder: (context, snapshot) {
          return ListItemsBuilder<QuestModel>(
            title: 'No Quests Conquered!',
            message: 'Head to the explore page, choose a quest and start your journey!',
            buttonEnabled: false,            
             image: Image.asset('images/ic_owl_wrong_dialog.png'),
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
                final _questCompletedBy = quest.questCompletedBy.contains(user.uid);
                
                if (!_questCompletedBy) {
                    Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => QuestDetailScreen(
                      userData: user,
                      questModel: quest,
                      database: database,
                    ),
                  ),
                );
                } else {
                  Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => ActiveQuestScreen(
                      questModel: quest,
                    ),
                  ),
                );
                }
              },
            ),
          );
        });
  }
  
}
