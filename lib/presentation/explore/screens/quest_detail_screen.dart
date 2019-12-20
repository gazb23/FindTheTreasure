import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/widgets_common/quests/heart.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_details_list_tile.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_tags.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class QuestDetailScreen extends StatefulWidget {
  final QuestModel questModel;
  final UserData userData;
  final DatabaseService database;
  const QuestDetailScreen(
      {Key key, this.questModel, this.userData, this.database})
      : super(key: key);

  static Future<void> show(BuildContext context,
      {QuestModel quest, UserData user, DatabaseService database}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => QuestDetailScreen(
          questModel: quest,
          userData: user,
          database: database,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _QuestDetailScreenState createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  @override
  Widget build(BuildContext context) {
    List tags = widget.questModel.tags ?? [];
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          color: Colors.grey.shade50,
          child: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  _buildImage(context),
                  _buildQuestTags(tags),
                  _buildQuestDescriptionCard(context),
                  _buildBountyCard(context),
                  _buildCargoCard(context),
                  SizedBox(
                    height: 70,
                  )
                ],
              ),
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
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

  Widget _buildImage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
            image: NetworkImage(
              widget.questModel.image,
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
            child: _buildQuestListTile(context))
      ]),
    );
  }

  Widget _buildQuestListTile(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        title: Text(
          widget.questModel.title,
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
              widget.questModel.location,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'JosefinSans'),
            ),
          ],
        ),
        trailing: StreamBuilder<QuestModel>(
            stream:
                widget.database.questStream(documentId: widget.questModel.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final questModel = snapshot.data;
                final likedByCopy = []..addAll(questModel.likedBy);
                final isLikedByUser = likedByCopy.contains(widget.database.uid);
                return Heart(
                  database: widget.database,
                  likedByCopy: likedByCopy,
                  isLikedByUser: isLikedByUser,
                  questModel: widget.questModel,
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Waiting');
              }
              return CircularProgressIndicator();
            }));
  }

  Widget _buildQuestDescriptionCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: ExpandablePanel(
          header: Text(
            'Quest Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            
          ),
          collapsed: Column(
            children: <Widget>[
              _buildQuestDetailCard(context),
              SizedBox(height: 5,),
              Text(
                widget.questModel.description,
                style: TextStyle(height: 1.35),
                softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          
          expanded: Column(
            children: <Widget>[
              _buildQuestDetailCard(context),
              SizedBox(height: 5,),
              Text(
                widget.questModel.description,
                style: TextStyle(height: 1.35),
              ),
            ],
          ),
          tapHeaderToExpand: true,
          tapBodyToCollapse: true,
          hasIcon: true,

        ),
      ),
    );
  }

  Column _buildQuestDetailCard(BuildContext context) {
    return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade200),
              child: Column(
                children: <Widget>[
                  _buildTimeListTile(
                      context, widget.questModel.timeDifficulty),
                  _buildBrainListTile(
                      context, widget.questModel.brainDifficulty),
                  _buildHikingListTile(
                      context, widget.questModel.hikeDifficulty),
                ],
              ),
            ),
            
          ],
        );
  }

  Widget _buildBountyCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: ExpandablePanel(
          header: Text(
            'Bounty',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          collapsed: Container(child: Text('Collapsed')),
          expanded: Text('hello'),
          tapHeaderToExpand: true,
          tapBodyToCollapse: true,
          hasIcon: true,
        ),
      ),
    );
  }

  Widget _buildCargoCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: ExpandablePanel(
          header: Text(
            'Cargo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          collapsed: Container(
            child: Text(
              widget.questModel.description,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          expanded: Text(
            widget.questModel.description,
            style: TextStyle(height: 1.35),
          ),
          tapHeaderToExpand: true,
          tapBodyToCollapse: true,
          hasIcon: true,
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.grey.shade800,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: DiamondAndKeyContainer(
                numberOfDiamonds: widget.questModel.numberOfDiamonds,
                numberOfKeys: widget.questModel.numberOfKeys,
                mainAxisAlignment: MainAxisAlignment.start,
                spaceBetween: 10,
                fontSize: 14,
                diamondHeight: 20,
                skullKeyHeight: 30,
              ),
            ),
            Expanded(
              flex: 3,
              child: SignInButton(
                text: 'Let\s Go!',
                onPressed: () {
                  if (widget.userData.userDiamondCount >=
                      widget.questModel.numberOfDiamonds) {
                    return PlatformAlertDialog(
                      title: '${widget.userData.displayName}',
                      content:
                          'It seems ya have enough treasure for the ${widget.questModel.title} quest. But do you have the legs!',
                      cancelActionText: 'Cancel',
                      defaultActionText: 'Let\s Go Baby!',
                      image: Image.asset('images/ic_excalibur_owl.png'),
                    ).show(context);
                  } else
                    return PlatformAlertDialog(
                      title: '${widget.userData.displayName}',
                      content:
                          'It seems you need ${widget.questModel.numberOfDiamonds - widget.userData.userDiamondCount} more diamonds for the ${widget.questModel.title} quest. Head to the store to buy some more',
                      cancelActionText: 'Cancel',
                      defaultActionText: 'Store',
                      image: Image.asset('images/ic_owl_wrong_dialog.png'),
                    ).show(context);
                },
                padding: 0,
              ),
            )
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
