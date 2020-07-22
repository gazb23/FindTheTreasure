import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/screens/intro_screen.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/custom_circular_progress_indicator_button.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/presentation/explore/screens/quest_detail_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    final _userData = Provider.of<UserData>(context);

    // Lock this screen to portrait orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: MaterialTheme.blue,
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
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: _userData != null
            ? !_userData.isAdmin
                ? _buildLiveListView(context)
                : ListView(children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Test Quests',
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold)),
                        Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            child: _buildTestListView(context)),
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Live Quests',
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold)),
                        Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            child: _buildLiveListView(context))
                      ],
                    ),
                  ])
            : Container(
                child: Center(
                child: CustomCircularProgressIndicator(
                    color: MaterialTheme.orange),
              )));
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
          } else {
            return Container();
          }
        });
  }

  @override
  void didChangeDependencies() {
    final UserData userData = Provider.of<UserData>(context, listen: false);
    if (mounted) _showIntroDialog(context, userData);
    super.didChangeDependencies();
  }

  void _showIntroDialog(BuildContext context, UserData userData) async {
    print('dialog');
    await Future.delayed(Duration(seconds: 5));
    try {
      if (!userData.seenIntro) {
        SchedulerBinding.instance.scheduleFrameCallback((_) {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            maintainState: true,
            builder: (context) => IntroScreen(),
          ));
        });
      } else {
        print('seen');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildLiveListView(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
    final database = Provider.of<DatabaseService>(context);

    return StreamBuilder<List<QuestModel>>(
        stream: database.questFieldIsAdmin(field: 'isLive', isEqualTo: true),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
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
                        fullscreenDialog: true,
                        builder: (context) => QuestDetailScreen(
                          userData: _userData,
                          questModel: quest,
                          database: database,
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Container();
          }
        });
  }
}
