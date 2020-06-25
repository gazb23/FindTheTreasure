import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/presentation/explore/screens/quest_detail_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
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
       
    final database = Provider.of<DatabaseService>(context);
    // Lock this screen to portrait orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return StreamBuilder<List<QuestModel>>(
        stream: database.questsStream(),
        builder: (context, questModel) {
          if (questModel.connectionState == ConnectionState.active && questModel.data != null) {
            final _userData = context.watch<UserData>(); 
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.grey.shade800,
                leading: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
                iconTheme: const IconThemeData(
                  color: Colors.black87,
                ),
                actions: <Widget>[
                  DiamondAndKeyContainer(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    numberOfDiamonds: _userData?.userDiamondCount,
                    numberOfKeys: _userData?.userKeyCount,
                    diamondHeight: 20,
                    skullKeyHeight: 30,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
              body: _userData != null ? !_userData.isAdmin
                  ? _buildLiveListView(context)
                  : ListView(children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text('Test Quests',
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold)),
                          Container(
                              height: MediaQuery.of(context).size.height / 2.5,
                              child: _buildTestListView(context)),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Live Quests',
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold)),
                          Container(
                              height: MediaQuery.of(context).size.height / 2.5,
                              child: _buildLiveListView(context))
                        ],
                      ),
                    ]) : null
            );
          } else if (questModel.connectionState == ConnectionState.waiting) {
            return Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.white,
                child: Image.asset('images/compass.gif', height: 100,));
          } 
            return Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.white,
                child: Image.asset('images/compass.gif', height: 100,));
        });
  }

  Widget _buildTestListView(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
    final database = Provider.of<DatabaseService>(context);
    return StreamBuilder<List<QuestModel>>(
        stream: database.questFieldIsAdmin(field: 'isLive', isEqualTo: false),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListItemsBuilder<QuestModel>(
              snapshot: snapshot,
              message: 'No Test Events',
              title: 'No test events',
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
          }
          return Container();
        });
  }

  Widget _buildLiveListView(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
    final database = Provider.of<DatabaseService>(context);
    return StreamBuilder<List<QuestModel>>(
        stream: database.questFieldIsAdmin(field: 'isLive', isEqualTo: true),
        builder: (context, snapshot) {
          return ListItemsBuilder<QuestModel>(
            snapshot: snapshot,
            title: 'No quests!',
            message: 'Oh No!',
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
