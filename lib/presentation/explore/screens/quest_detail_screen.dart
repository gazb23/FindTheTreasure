import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/active_quest/active_quest_screen.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/widgets_common/quests/heart.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_details_list_tile.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_diamond_calculation_button.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_tags.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class QuestDetailScreen extends StatelessWidget {
  final QuestModel questModel;
  final UserData userData;
  final DatabaseService database;
  const QuestDetailScreen({
    Key key,
    @required this.questModel,
    @required this.userData,
    @required this.database,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List tags = questModel.tags ?? [];
    return StreamBuilder<QuestModel>(
        stream: database.questStream(questId: questModel.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final QuestModel questModelStream = snapshot.data;
            return SafeArea(
              child: Scaffold(
                body: Container(
                  width: double.infinity,
                  color: Colors.grey.shade50,
                  child: Stack(
                    children: <Widget>[
                      ListView(
                        children: <Widget>[
                          _buildImage(context, questModelStream),
                          _buildQuestTags(tags),
                          _buildQuestDescriptionCard(context, questModelStream),
                          _buildBountyCard(context, questModelStream),
                          SizedBox(
                            height: 80,
                          )
                        ],
                      ),
                      _buildBottomBar(context, questModelStream),
                    ],
                  ),
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget _buildImage(BuildContext context, QuestModel questModelStream) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
            image: NetworkImage(
              questModelStream.image,
            ),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.8), BlendMode.dstATop),
            alignment: Alignment.center),
      ),
      child: Stack(children: <Widget>[
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: _buildQuestListTile(context, questModelStream))
      ]),
    );
  }

  Container _buildQuestTags(List tags) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.grey.shade50,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 5,
        runSpacing: 5,
        children: <Widget>[
          // Iterate over the tags list stored in Firebase and return a QuestTag for each element in that list.
          for (String tag in tags)
            QuestTags(
              title: tag,
            )
        ],
      ),
    );
  }

  Widget _buildQuestListTile(
      BuildContext context, QuestModel questModelStream) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      title: Text(
        questModelStream.title,
        style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'JosefinSans'),
      ),
      subtitle: Row(
        children: <Widget>[
          Icon(
            Icons.room,
            color: Colors.amberAccent,
            size: 18,
          ),
          Text(
            questModelStream.location,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'JosefinSans'),
          ),
        ],
      ),
      trailing: StreamBuilder<QuestModel>(
        stream: database.questStream(questId: questModel.id),
        builder: (context, snapshot) {
          final questModelStream = snapshot.data;
          final isLikedByUser = questModelStream.likedBy.contains(database.uid);
          return Heart(
            database: database,
            isLikedByUser: isLikedByUser,
            questModel: questModelStream,
          );
        },
      ),
    );
  }

  Widget _buildQuestDescriptionCard(
      BuildContext context, QuestModel questModelStream) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: ExpandablePanel(
          header: Column(
            children: <Widget>[
              Text(
                'Quest Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              _buildQuestDetailCard(context, questModelStream),
            ],
          ),
          collapsed: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                questModelStream.description,
                style: TextStyle(height: 1.35),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          expanded: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                questModelStream.description,
                style: TextStyle(height: 1.35),
              ),
            ],
          ),
          theme: ExpandableThemeData(
              tapBodyToCollapse: true,
              tapHeaderToExpand: true,
              hasIcon: false,
              iconColor: Colors.orangeAccent,
              iconSize: 40),
        ),
      ),
    );
  }

  Column _buildQuestDetailCard(
      BuildContext context, QuestModel questModelStream) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey.shade200),
          child: Column(
            children: <Widget>[
              _buildTimeListTile(context, questModelStream.timeDifficulty),
              _buildBrainListTile(context, questModelStream.brainDifficulty),
              _buildHikingListTile(context, questModelStream.hikeDifficulty),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBountyCard(BuildContext context, QuestModel questModelStream) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: ExpandablePanel(
          header: Column(
            children: <Widget>[
              Text(
                'Bounty',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              _buildTreasure(context, questModelStream),
            ],
          ),
          collapsed: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                'Theres plenty of bounty to be discovered in this quest. Keep your eyes peeled and your wits in tact - who knows what treasures abound',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          expanded: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                  'Theres plenty of bounty to be discovered in this quest. Keep your eyes peeled and your wits in tact - who knows what treasures abound'),
            ],
          ),
          theme: ExpandableThemeData(
            tapBodyToCollapse: true,
            tapHeaderToExpand: true,
            hasIcon: false,
            iconColor: Colors.orangeAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildTreasure(BuildContext context, QuestModel questModelStream) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.brown),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Image.asset(
            'images/ic_treasure.png',
            height: 80,
          ),
          SizedBox(
            height: 10,
          ),
          DiamondAndKeyContainer(
            numberOfDiamonds: questModelStream.bountyDiamonds,
            numberOfKeys: questModelStream.bountyKeys,
            diamondHeight: 30,
            skullKeyHeight: 40,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            spaceBetween: 60,
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, QuestModel questModelStream) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.grey.shade800.withOpacity(0.8),
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: DiamondAndKeyContainer(
                numberOfDiamonds: questModelStream.numberOfDiamonds,
                numberOfKeys: questModelStream.numberOfKeys,
                mainAxisAlignment: MainAxisAlignment.start,
                spaceBetween: 10,
                fontSize: 14,
                diamondHeight: 20,
                skullKeyHeight: 30,
              ),
            ),
            Expanded(
                flex: 3,
                child: QuestDiamondCalulationButton(
                    questModelStream: questModelStream,
                    userData: userData,
                    databaseService: database,
                    confirmQuest: _confirmQuest))
          ],
        ),
      ),
    );
  }

  Future<void> _confirmQuest(BuildContext context, QuestModel questModelStream,
  //TODO: add a try and catch block
      UserData userData, DatabaseService database) async {
    final didRequestQuest = await PlatformAlertDialog(
      title: '${userData.displayName}',
      content:
          'It seems ya have enough treasure for the ${questModelStream.title} quest. Do you want to begin the quest?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Confirm',
      image: Image.asset('images/ic_excalibur_owl.png'),
    ).show(context);
    if (didRequestQuest) {
      final UserData _userData = UserData(
        userDiamondCount:
            userData.userDiamondCount - questModelStream.numberOfDiamonds,
        userKeyCount: userData.userKeyCount - questModelStream.numberOfKeys,
        displayName: userData.displayName,
        email: userData.email,
        photoURL: userData.photoURL,
        uid: userData.uid,
      );
      await database.arrayUnionField(documentId: questModel.id, uid: database.uid, field: 'questStartedBy');
      await database.updateUserDiamondAndKey(userData: _userData);
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ActiveQuestScreen(
            questModel: questModelStream,
          ),
        ),
      );
    }
  }

  Widget _buildTimeListTile(BuildContext context, String difficulty) {
    return Column(
      children: <Widget>[
        QuestDetailsListTile(
          image: 'images/deadline.png',
          imageHeight: 40,
          difficulty: difficulty,
        ),
      ],
    );
  }

  Widget _buildBrainListTile(BuildContext context, String difficulty) {
    return Column(
      children: <Widget>[
        QuestDetailsListTile(
          image: 'images/brain.png',
          imageHeight: 40,
          difficulty: difficulty,
        ),
      ],
    );
  }

  Widget _buildHikingListTile(BuildContext context, String difficulty) {
    return Column(
      children: <Widget>[
        QuestDetailsListTile(
          image: 'images/hiker.png',
          imageHeight: 40,
          difficulty: difficulty,
        ),
      ],
    );
  }
}
