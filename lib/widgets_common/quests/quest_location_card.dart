import 'package:expandable/expandable.dart';
import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/active_quest/question_widgets/question_scroll_single_answer.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/view_models/question_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestLocationCard extends StatelessWidget {
  final LocationModel locationModel;
  final QuestModel questModel;
  final DatabaseService databaseService;
  final VoidCallback onTap;
  final bool isLoading;

  const QuestLocationCard({
    Key key,
    @required this.locationModel,
    @required this.questModel,
    @required this.databaseService,
    this.onTap,
    this.isLoading,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UserData _userData = Provider.of<UserData>(context);
    final _locationStartedBy =
        locationModel.locationStartedBy.contains(_userData.uid);
           final _locationCompletedBy =
        locationModel.locationCompletedBy.contains(_userData.uid);

    return InkWell(
      onTap: onTap,
      child: Card(
        color: _locationProgressColor(locationStarted: _locationStartedBy, locationCompleted: _locationCompletedBy ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ExpandablePanel(
          theme: ExpandableThemeData(
            tapBodyToExpand: true,
            tapBodyToCollapse: true,
            tapHeaderToExpand: _locationStartedBy ? true : false,
            hasIcon: false,
          ),
          header: LocationHeader(
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
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => QuestionScrollSingleAnswer(
                              isFinalChallenge: _numberofChallengesCompleted ==
                                  _numberOfChallenges - 1,
                              locationQuestion: false,
                              questModel: questModel,
                              questionsModel: questionsModel,
                              locationModel: locationModel,
                            ),
                          ),
                        );
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
      return Colors.orangeAccent.shade200;
    }
    return Colors.white;
}
}

class LocationHeader extends StatelessWidget {
  final LocationModel locationModel;
  final QuestModel questModel;
  final bool isLoading;
  const LocationHeader(
      {Key key,
      @required this.locationModel,
      @required this.questModel,
      this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserData _userData = Provider.of<UserData>(context);
    final _locationCompletedBy =
        locationModel.locationCompletedBy.contains(_userData.uid);
    final _locationStartedBy =
        locationModel.locationStartedBy.contains(_userData.uid);
    final DatabaseService databaseService =
        Provider.of<DatabaseService>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        enabled: isLoading,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        leading: _locationProgressImage(
            locationCompleted: _locationCompletedBy,
            locationStarted: _locationStartedBy),
        title: Text(
          _locationStartedBy ? locationModel.title : 'Mystery Location',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _locationStartedBy ? Colors.white : Colors.black54,
              fontFamily: 'JosefinSans',
              fontSize: 22),
        ),
        subtitle: _locationCompletedBy ? Text('Conquered') : null,
        trailing: StreamBuilder<List<QuestionsModel>>(
            stream: databaseService.challengesStream(
                questId: questModel.id, locationId: locationModel.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final _numberOfChallenges = snapshot.data.length;
                final _numberofChallengesCompletedCard = snapshot.data
                    .where((questionsModel) => questionsModel
                        .challengeCompletedBy
                        .contains(databaseService.uid))
                    .length;
                QuestionViewModel.submitLocationConquered(context,
                    locationModel: locationModel, questModel: questModel,
                    lastChallengeCompleted: _numberOfChallenges == _numberofChallengesCompletedCard);
                return Text(
                    '$_numberofChallengesCompletedCard/$_numberOfChallenges');
              }

              return CircularProgressIndicator();
            }),
      ),
    );
  }

  // Decide which image to show depending on user progress through the location
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
