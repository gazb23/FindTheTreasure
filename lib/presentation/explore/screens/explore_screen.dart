import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/screens/intro_screen.dart';
import 'package:find_the_treasure/services/audio_player.dart';
import 'package:find_the_treasure/services/connectivity_service.dart';
import 'package:find_the_treasure/services/global_functions.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/custom_circular_progress_indicator_button.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/presentation/explore/screens/quest_detail_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_conquered_card.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_list_view.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_locked_card.dart';
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
                ]))),
            iconTheme: const IconThemeData(
              color: Colors.black87,
            ),
            actions: [
              ShopButton(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                numberOfDiamonds: _userData.userDiamondCount,
                diamondHeight: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                diamondSpinning: true,
              ),
              SizedBox(
                width: 15,
              )
            ]),
        body: _userData != null
            ? !_userData.isAdmin
                ? LiveListView()
                : AdminView()
            : Container(
                child: Center(
                child: CustomCircularProgressIndicator(
                    height: 30, width: 30, color: MaterialTheme.orange),
              )));
  }

  @override
  void didChangeDependencies() async {
    final UserData userData = Provider.of<UserData>(context, listen: true);
    if (mounted) {
      _showIntroDialog(context, userData);
    } else {
      await Future.delayed(Duration(seconds: 3));
      _showIntroDialog(context, userData);
    }
    super.didChangeDependencies();
  }

  void _showIntroDialog(BuildContext context, UserData userData) async {
    // print('dialog');

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
                      itemBuilder: (context, quest, index) => QuestCard(
                          numberOfDiamonds: quest.numberOfDiamonds,
                          difficulty: quest.difficulty,
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

// Present live events only
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
              title: 'Error!',
              message:
                  'Oh No! There has been a problem with getting your quests! Please try again later.',
              itemBuilder: (context, questModel, index) {
                // User has insufficient diamonds to unlock quest
                bool insufficientDiamonds = _userData.userDiamondCount <
                        questModel.numberOfDiamonds &&
                    !questModel.questCompletedBy.contains(_userData.uid) &&
                    !questModel.questStartedBy.contains(_userData.uid) &&
                    !questModel.treasureDiscoveredBy.contains(_userData.uid);

                // User has conquered the quest
                bool questCompleted =
                    questModel.questCompletedBy.contains(_userData.uid) && questModel.treasureDiscoveredBy.contains(_userData.uid);

                if (insufficientDiamonds) {
                  return QuestLockedCard(
                      numberOfDiamonds: questModel.numberOfDiamonds,
                      difficulty: questModel.difficulty,
                      title: questModel.title,
                      image: questModel.image,
                      numberOfLocations: questModel.numberOfLocations,
                      location: questModel.location,
                      questModel: questModel,
                      onTap: () {
                        !insufficientDiamonds
                            ? Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => QuestDetailScreen(
                                    userData: _userData,
                                    questModel: questModel,
                                    database: database,
                                  ),
                                ),
                              )
                            : PlatformAlertDialog(
                                title: 'Quest Locked!',
                                image: Image.asset('images/event.png'),
                                content:
                                    'Unlock this quest by earning ${questModel.numberOfDiamonds - _userData.userDiamondCount} more ${GlobalFunction.diamondPluralCount(questModel.numberOfDiamonds - _userData.userDiamondCount)}!',
                                defaultActionText: 'OK',
                              ).show(context);
                      });
                } else if (questCompleted) {
                  return QuestConqueredCard(
                      numberOfDiamonds: questModel.numberOfDiamonds,
                      difficulty: questModel.difficulty,
                      title: questModel.title,
                      image: questModel.image,
                      numberOfLocations: questModel.numberOfLocations,
                      location: questModel.location,
                      questModel: questModel,
                      onTap: () {
                        PlatformAlertDialog(
                          backgroundColor: Colors.amberAccent,
                          titleTextColor: Colors.grey.shade800,
                          title: 'Quest Conquered!',
                          image: Image.asset('images/ic_excalibur_owl.png'),
                          content:
                              'Congratulations on conquering the ${questModel.title} quest! Where\'s your next adventure going to be? ',
                          defaultActionText: 'OK',
                        ).show(context);
                      });
                } else {
                  return QuestCard(
                      numberOfDiamonds: questModel.numberOfDiamonds,
                      difficulty: questModel.difficulty,
                      title: questModel.title,
                      image: questModel.image,
                      numberOfLocations: questModel.numberOfLocations,
                      location: questModel.location,
                      questModel: questModel,
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => QuestDetailScreen(
                              userData: _userData,
                              questModel: questModel,
                              database: database,
                            ),
                          ),
                        );
                      });
                }
              });
        });
  }

 
}
