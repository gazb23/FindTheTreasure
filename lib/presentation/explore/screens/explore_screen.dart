import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/screens/intro_screen.dart';
import 'package:find_the_treasure/services/audio_player.dart';
import 'package:find_the_treasure/services/connectivity_service.dart';
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
  void initState() {
    AudioPlayerService().loadAllSounds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
    ConnectivityService.checkNetwork(context, listen: true);
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
          title: DiamondAndKeyContainer(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            numberOfDiamonds: _userData.userDiamondCount,
            numberOfKeys: _userData.userKeyCount,
            diamondHeight: 30,
            skullKeyHeight: 33,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            diamondSpinning: true,
          ),
        ),
        body: _userData != null
            ? !_userData.isAdmin ? LiveListView() : AdminView()
            : Container(
                child: Center(
                child: CustomCircularProgressIndicator(
                    color: MaterialTheme.orange),
              )));
  }

  @override
  void didChangeDependencies() {
    final UserData userData = Provider.of<UserData>(context, listen: false);
    if (mounted) _showIntroDialog(context, userData);
    super.didChangeDependencies();
  }

  void _showIntroDialog(BuildContext context, UserData userData) async {
    print('dialog');
    await Future.delayed(Duration(seconds: 4));
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
}

// Present UI containing both live and test events for admin users to test
class AdminView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
    final database = Provider.of<DatabaseService>(context);

    return ListView(children: <Widget>[
      Column(
        children: <Widget>[
          Text('Test Quests',
              style:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: StreamBuilder<List<QuestModel>>(
                  stream: database.questFieldIsAdmin(
                      field: 'isLive', isEqualTo: false),
                  builder: (context, snapshot) {
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
                  })),
          const SizedBox(
            height: 20,
          ),
          Text('Live Quests',
              style:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: LiveListView())
        ],
      ),
    ]);
  }
}

// Present only live events to non admin users
class LiveListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        });
  }
}
