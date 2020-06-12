import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/services/location_service.dart';
import 'package:find_the_treasure/view_models/question_view_model.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class QuestLocationCard extends StatelessWidget {
  final LocationModel locationModel;
  final QuestModel questModel;
  final DatabaseService databaseService;
  final VoidCallback onTap;
  final bool isLoading;
  final bool lastLocationCompleted;

  const QuestLocationCard({
    Key key,
    @required this.locationModel,
    @required this.questModel,
    @required this.databaseService,
    this.onTap,
    this.isLoading,
    @required this.lastLocationCompleted,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UserData _userData = Provider.of<UserData>(context);
    final _locationStartedBy =
        locationModel.locationStartedBy.contains(_userData.uid);
    final _locationCompletedBy =
        locationModel.locationCompletedBy.contains(_userData.uid);
    final _locationDiscoveredBy =
        locationModel.locationDiscoveredBy.contains(_userData.uid);

    return InkWell(
      onTap: onTap,
      child: Card(
        color: _locationProgressColor(
            locationStarted: _locationStartedBy,
            locationCompleted: _locationCompletedBy),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ExpandablePanel(
          theme: ExpandableThemeData(
            sizeCurve: Curves.bounceOut,
            animationDuration: Duration(milliseconds: 800),
            tapBodyToExpand: true,
            tapBodyToCollapse: true,
            tapHeaderToExpand:
                _locationStartedBy && _locationDiscoveredBy ? true : false,
            hasIcon: false,
          ),
          header: ChangeNotifierProvider<LocationService>(
            create: (context) => LocationService(
              questModel: questModel,
              locationModel: locationModel,
              databaseService: databaseService,
            ),
            child: LocationHeader(
              lastLocationCompleted: lastLocationCompleted,
              questModel: questModel,
              locationModel: locationModel,
              isLoading: isLoading,
            ),
          ),
          expanded:
              // Build challenges in Location Card
              SizedBox(
            height: MediaQuery.of(context).size.height/2,
            child: StreamBuilder<List<QuestionsModel>>(
              stream: databaseService.challengesStream(
                  questId: questModel.id, locationId: locationModel.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  // How many challenged the user has completed, this is parsed to Challenges class so it can be used to determine which challenge to activate
                  final int _numberOfChallenges = snapshot.data.length;

                  final int _numberofChallengesCompleted = snapshot.data
                      .where((questionsModel) => questionsModel
                          .challengeCompletedBy
                          .contains(databaseService.uid))
                      .length;
                  final bool _isFinalChallenge =
                      _numberofChallengesCompleted == _numberOfChallenges - 1;
                  return ListItemsBuilder<QuestionsModel>(
                    title: 'Oh no! No challenges!',
                    message: 'Admin needs to add some!',
                    snapshot: snapshot,
                    isSeperated: true,
                    itemBuilder: (context, questionsModel, index) => Challenges(
                      questModel: questModel,
                      questionsModel: questionsModel,
                      currentIndex: index,
                      locationModel: locationModel,
                      numberOfChallengesCompleted: _numberofChallengesCompleted,
                      databaseService: databaseService,
                      onTap: () {
                        QuestionViewModel.loadQuestion(
                            context: context,
                            questModel: questModel,
                            locationModel: locationModel,
                            questionsModel: questionsModel,
                            isFinalChallenge: _isFinalChallenge);
                      },
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  // Logic for Location Card Color
  Color _locationProgressColor({bool locationCompleted, bool locationStarted}) {
    if (locationCompleted) {
      return Colors.amberAccent;
    }
    if (locationStarted) {
      return Colors.white;
    }
    return Colors.white;
  }
}

class LocationHeader extends StatefulWidget {
  final LocationModel locationModel;
  final QuestModel questModel;
  final bool lastLocationCompleted;
  final bool isLoading;
  const LocationHeader(
      {Key key,
      @required this.locationModel,
      @required this.questModel,
      this.isLoading,
      @required this.lastLocationCompleted})
      : super(key: key);

  @override
  _LocationHeaderState createState() => _LocationHeaderState();
}

class _LocationHeaderState extends State<LocationHeader> {
  @override
  Widget build(BuildContext context) {
    final UserData _userData = Provider.of<UserData>(context);
    final _locationCompletedBy =
        widget.locationModel.locationCompletedBy.contains(_userData.uid);
    final _locationStartedBy =
        widget.locationModel.locationStartedBy.contains(_userData.uid);
    final DatabaseService databaseService =
        Provider.of<DatabaseService>(context);
    final LocationService locationService = context.watch<LocationService>();

    void _submit() async {
      try {
        locationService.getCurrentLocation(context);
      } catch (e) {
        print(e.toString());
      }
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            enabled: widget.isLoading,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            leading: _locationProgressImage(
                locationCompleted: _locationCompletedBy,
                locationStarted: _locationStartedBy),
            title: AutoSizeText(
              _locationStartedBy
                  ? widget.locationModel.title
                  : 'Mystery Location',
              maxLines: 2,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _locationCompletedBy ? Colors.white : Colors.black54,
                  
                  fontSize: 22),
            ),
            subtitle: _locationCompletedBy ? Text('Conquered') : null,
            trailing: StreamBuilder<List<QuestionsModel>>(
                stream: databaseService.challengesStream(
                    questId: widget.questModel.id,
                    locationId: widget.locationModel.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final _numberOfChallenges = snapshot.data.length;
                    final _numberofChallengesCompleted = snapshot.data
                        .where((questionsModel) => questionsModel
                            .challengeCompletedBy
                            .contains(databaseService.uid))
                        .length;

                    QuestionViewModel.checkQuestLogic(
                      context,
                      locationModel: widget.locationModel,
                      questModel: widget.questModel,
                      lastLocationCompleted: widget.lastLocationCompleted,
                      lastChallengeCompleted: (_numberOfChallenges ==
                              _numberofChallengesCompleted) &&
                          (_numberofChallengesCompleted > 0),
                    );
                    return Text(
                        '$_numberofChallengesCompleted/$_numberOfChallenges');
                  }

                  return CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                  );
                }),
          ),
          !widget.locationModel.locationStartedBy
                      .contains(databaseService.uid) ||
                  widget.locationModel.locationDiscoveredBy
                      .contains(databaseService.uid)
              ? Container()
              : Container(
                  // margin: EdgeInsets.only(bottom: 0),
                  // padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: <Widget>[
                      Container(
                    
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            
                             IconButton(
                                icon: Icon(
                                  Icons.help_outline,
                                  color: Colors.white30,
                                  size: 35,
                                ),
                                onPressed: () {
                                  PlatformAlertDialog(
                                          title: 'X marks the spot!',
                                          image: Image.asset('images/compass.gif', height: 150,),
                                          content:
                                              'Tap the button to unlock the challenges once you\'re at ${widget.locationModel.title}.',
                                          defaultActionText: 'OK')
                                      .show(context);
                                }),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.locationModel.locationDirections ?? '',
                              style: TextStyle(
                                
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                           
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          shape: StadiumBorder(),
                          color: Colors.orangeAccent,
                          child: locationService.isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Icon(
                                  Icons.vpn_lock,
                                  color: Colors.white,
                                  size: 40,
                                ),
                          onPressed:
                              !locationService.isLoading ? _submit : null,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Image _locationProgressImage({bool locationCompleted, bool locationStarted}) {
    if (locationCompleted) {
      return Image.asset('images/ic_questcompleted.png');
    }
    if (locationStarted) {
      return Image.asset('images/ic_activequest.png');
    }
    return Image.asset('images/ic_quest_nonactive.png');
  }
}

class Challenges extends StatelessWidget {
  final QuestionsModel questionsModel;
  final LocationModel locationModel;
  final QuestModel questModel;
  final VoidCallback onTap;
  final int currentIndex;
  final int numberOfChallengesCompleted;
  final DatabaseService databaseService;
  const Challenges(
      {Key key,
      this.questionsModel,
      this.onTap,
      this.currentIndex,
      this.locationModel,
      this.numberOfChallengesCompleted,
      this.databaseService, @required this.questModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool _isCurrentChallenge = numberOfChallengesCompleted == currentIndex - 1;
    bool _challengeCompleted =
        questionsModel.challengeCompletedBy.contains(databaseService.uid);
         final _locationCompletedBy =
        locationModel.locationCompletedBy.contains(databaseService.uid);
final _questCompletedBy =
        questModel.questCompletedBy.contains(databaseService.uid);
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      color:  Colors.transparent,
      
      child: ListTile(
        
        contentPadding: EdgeInsets.only(left: 20, right: 20),
        enabled: _isCurrentChallenge,
        leading: _challengeProgressImage(
            challengeCompleted: _challengeCompleted,
            isCurrentChallenge: _isCurrentChallenge),
        title: Text(
          questionsModel.challengeTitle,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _locationCompletedBy || _questCompletedBy ? Colors.white : _challengeCompleted ? Colors.grey.shade300 : Colors.black54,
              fontFamily: 'quicksand',
              
              fontSize: 18),
        ),
        subtitle: _challengeCompleted ? Text('Challenge Complete', style: TextStyle(color: _locationCompletedBy || _questCompletedBy ? Colors.black54 : _challengeCompleted ? Colors.grey.shade300 : Colors.black54, fontSize: 15)) : null,
        trailing: Text(currentIndex.toString(), style: TextStyle(
          color: _locationCompletedBy || _questCompletedBy ? Colors.white : _challengeCompleted ? Colors.grey.shade300 : Colors.black54
        ),),
        onTap: onTap,
      ),
    );
  }

// Decide which image to show depending on user progress through the challenge
  Image _challengeProgressImage(
      {bool challengeCompleted, bool isCurrentChallenge}) {
    if (isCurrentChallenge) {
      return Image.asset('images/ic_activequest.png');
    }
    if (challengeCompleted) {
      return Image.asset('images/ic_questcompleted.png');
    }
    return Image.asset('images/ic_quest_nonactive.png');
  }
}
