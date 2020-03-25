

import 'package:expandable/expandable.dart';
import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/services/location_service.dart';
import 'package:find_the_treasure/view_models/question_view_model.dart';
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
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          header: LocationHeader(
            lastLocationCompleted: lastLocationCompleted,
            questModel: questModel,
            locationModel: locationModel,
            isLoading: isLoading,
          ),
          expanded:
              // Build challenges in Location Card
              SizedBox(
            height: 400,
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
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final UserData _userData = Provider.of<UserData>(context);
    final _locationCompletedBy =
        widget.locationModel.locationCompletedBy.contains(_userData.uid);
    final _locationStartedBy =
        widget.locationModel.locationStartedBy.contains(_userData.uid);
    final DatabaseService databaseService =
        Provider.of<DatabaseService>(context);

    void _submit() async {
      try {
        _isLoading = true;     
        
        setState(() {});
        LocationService(
                databaseService: databaseService,
                questModel: widget.questModel,
                locationModel: widget.locationModel)
            .getCurrentLocation(context);
        await Future.delayed(Duration(milliseconds: 2000));
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e.toString());
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            enabled: widget.isLoading,
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            leading: _locationProgressImage(
                locationCompleted: _locationCompletedBy,
                locationStarted: _locationStartedBy),
            title: Text(
              _locationStartedBy
                  ? widget.locationModel.title
                  : 'Mystery Location',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _locationCompletedBy ? Colors.white : Colors.black54,
                  fontFamily: 'JosefinSans',
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
                    final _numberofChallengesCompletedCard = snapshot.data
                        .where((questionsModel) => questionsModel
                            .challengeCompletedBy
                            .contains(databaseService.uid))
                        .length;

                    QuestionViewModel.submitLocationConquered(
                      context,
                      locationModel: widget.locationModel,
                      questModel: widget.questModel,
                      lastLocationCompleted: widget.lastLocationCompleted,
                      lastChallengeCompleted: (_numberOfChallenges ==
                              _numberofChallengesCompletedCard) &&
                          (_numberofChallengesCompletedCard > 0),
                    );
                    return Text(
                        '$_numberofChallengesCompletedCard/$_numberOfChallenges');
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
                  margin: EdgeInsets.only(bottom: 1),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: <Widget>[
                      Image.asset('images/pirate.png'),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Ahoy ${_userData.displayName}! Tap the button below to unlock the challenges once you\'re at ${widget.locationModel.title}.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: RaisedButton(
                          shape: StadiumBorder(),
                          color: Colors.orangeAccent,
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Icon(
                                  Icons.vpn_lock,
                                  color: Colors.white,
                                  size: 30,
                                ),
                          onPressed: !_isLoading ? _submit : null,
                        ),
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
      this.databaseService})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool _isCurrentChallenge = numberOfChallengesCompleted == currentIndex - 1;
    bool _challengeCompleted =
        questionsModel.challengeCompletedBy.contains(databaseService.uid);

    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Container(
        height: 50,
        child: ListTile(
          enabled: _isCurrentChallenge,
          leading: _challengeProgressImage(
              challengeCompleted: _challengeCompleted,
              isCurrentChallenge: _isCurrentChallenge),
          title: Text(
            questionsModel.challengeTitle,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontFamily: 'quicksand',
                decoration:
                    _challengeCompleted ? TextDecoration.lineThrough : null,
                fontSize: 18),
          ),
          onTap: onTap,
        ),
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
