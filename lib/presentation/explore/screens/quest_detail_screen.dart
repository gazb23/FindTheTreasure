import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/database.dart';
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
                      _buildBottomBar(context, questModelStream, userData),
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
      trailing: SizedBox(
        width: 50,
        child: StreamBuilder<QuestModel>(
          stream: database.questStream(questId: questModel.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final questModelStream = snapshot.data;
              final isLikedByUser =
                  questModelStream.likedBy.contains(database.uid);
              return Heart(
                database: database,
                isLikedByUser: isLikedByUser,
                questModel: questModelStream,
              );
            } else if (snapshot.hasError) {
              print(snapshot.hasError.toString());
            }
            return Container();
          },
        ),
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
            ],
          ),
          collapsed: Column(
            children: <Widget>[
              _buildQuestDetailCard(context, questModelStream),
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
              _buildQuestDetailCard(context, questModelStream),
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
              hasIcon: true,
              iconColor: Colors.orangeAccent,
              iconSize: 30),
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
                'Bounty Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          collapsed: Column(
            children: <Widget>[
              _buildTreasure(context, questModelStream),
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
              _buildTreasure(context, questModelStream),
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
            hasIcon: true,
            iconSize: 30,
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

  Widget _buildBottomBar(
      BuildContext context, QuestModel questModelStream, UserData userData, ) {
        
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
                    ))
          ],
        ),
      ),
    );
    
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
