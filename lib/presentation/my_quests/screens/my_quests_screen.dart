import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/active_quest/active_quest_screen.dart';
import 'package:find_the_treasure/presentation/explore/screens/quest_detail_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/theme.dart';

import 'package:find_the_treasure/widgets_common/quests/quest_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyQuestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaleFactor.clamp(0.8, 1.35);
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
        );
      },
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          
          color: MaterialTheme.red,
        ),
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
              
              Colors.greenAccent[400],
              MaterialTheme.blue,
            ]) )) ,        
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              labelStyle: const TextStyle(
                  fontFamily: 'quicksand', fontWeight: FontWeight.bold),
              tabs: <Widget>[
                const Tab(
                  text: 'Current',
                ),
                const Tab(
                  text: 'Liked',
                ),
                const Tab(
                  text: 'Conquered',
                ),
              ],
            ),
            centerTitle: true,
            title: const Text(
              'My Quests',
              style: const TextStyle(
                  fontFamily: 'quicksand',
                  color: Colors.white,
                  fontWeight: FontWeight.bold),

            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Current(),
              Liked(),
              Conquered(),
            ],
          ),
        ),
      ),
    );
  }
}

class Current extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final userData = Provider.of<UserData>(context, listen: false);
    print('current');
    return StreamBuilder<List<QuestModel>>(
        stream: databaseService.questFieldContainsUID(field: 'questStartedBy'),
        builder: (context, snapshot) {
          return ListItemsBuilder<QuestModel>(
            title: 'No Current Quests!',
            fontColor: Colors.grey,
            message:
                'Head to the explore page to start your adventure.',
            buttonEnabled: false,            
            image: Image.asset('images/event.png'),
            snapshot: snapshot,
            itemBuilder: (context, quest, index) => QuestCard(
              numberOfDiamonds: quest.numberOfDiamonds,
              difficulty: quest.difficulty,
              // numberOfKeys: quest.numberOfKeys,
              title: quest.title,
              image: quest.image,
              numberOfLocations: quest.numberOfLocations,
              location: quest.location,
              questModel: quest,
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => QuestDetailScreen(
                      database: databaseService,
                      userData: userData,
                      questModel: quest,
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}

class Liked extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final userData = Provider.of<UserData>(context, listen: false);
    print('liked');
    return StreamBuilder<List<QuestModel>>(
        stream: databaseService.questFieldContainsUID(field: 'likedBy'),
        builder: (context, snapshot) {
          return ListItemsBuilder<QuestModel>(
            fontColor: Colors.grey,
            title: 'Time to add some favourites!',
            message:
                'Head to the explore page, and when you find a quest you like tap on the heart icon to save it.',
            buttonEnabled: false,
            image: Image.asset('images/owl_thumbs.png'),
            snapshot: snapshot,
            itemBuilder: (context, quest, index) => QuestCard(
              numberOfDiamonds: quest.numberOfDiamonds,
              difficulty: quest.difficulty,
              // numberOfKeys: quest.numberOfKeys,
              title: quest.title,
              image: quest.image,
              numberOfLocations: quest.numberOfLocations,
              location: quest.location,
              questModel: quest,
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => QuestDetailScreen(
                      database: databaseService,
                      userData: userData,
                      questModel: quest,
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}

class Conquered extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final userData = Provider.of<UserData>(context, listen: false);
    print('conquewred');
    return StreamBuilder<List<QuestModel>>(
        stream:
            databaseService.questFieldContainsUID(field: 'questCompletedBy'),
        builder: (context, snapshot) {
          return ListItemsBuilder<QuestModel>(
            fontColor: Colors.grey,
            title: 'No Quests Conquered!',
            message:
                'Head to the explore page, choose a quest and start your journey!',
            buttonEnabled: false,
            image: Image.asset('images/ic_owl_wrong_dialog.png'),
            snapshot: snapshot,
            itemBuilder: (context, quest, index) => QuestCard(
              numberOfDiamonds: quest.numberOfDiamonds,
              difficulty: quest.difficulty,
              // numberOfKeys: quest.numberOfKeys,
              title: quest.title,
              image: quest.image,
              numberOfLocations: quest.numberOfLocations,
              location: quest.location,
              questModel: quest,
              onTap: () {
                final _questCompletedBy =
                    quest.questCompletedBy.contains(userData.uid);

                if (!_questCompletedBy) {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => QuestDetailScreen(
                        userData: userData,
                        questModel: quest,
                        database: databaseService,
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
