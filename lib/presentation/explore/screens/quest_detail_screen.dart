import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/custom_circular_progress_indicator_button.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/widgets_common/quests/heart.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_details_list_tile.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_diamond_calculation_button.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_tags.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
                backgroundColor: Colors.grey.shade100,
                body: Container(
                  width: double.infinity,
                  child: Stack(
                    children: <Widget>[
                      ListView(
                        children: <Widget>[
                          _buildImage(context, questModelStream),
                          _buildQuestTags(tags),
                          _buildQuestDescriptionCard(context, questModelStream),
                          _buildBountyCard(context, questModelStream),
                          const SizedBox(
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
          return SafeArea(
            child: Scaffold(
              body: Container(
                  color: Colors.white,
                  child: Center(
                      child: CustomCircularProgressIndicator(
                    color: MaterialTheme.orange,
                  ))),
            ),
          );
        });
  }

  Widget _buildImage(BuildContext context, QuestModel questModelStream) {
    return CachedNetworkImage(
      imageUrl: questModelStream.image,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fadeInDuration: Duration(milliseconds: 500),
      fadeOutDuration: Duration(milliseconds: 400),
      imageBuilder: (context, image) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.75,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: image,
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
      ),
    );
  }

  Container _buildQuestTags(List tags) {
    return Container(
      
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      title: Text(
        questModelStream.title,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'JosefinSans'),
      ),
      subtitle: Row(
        children: <Widget>[
          const Icon(
            Icons.room,
            color: Colors.amberAccent,
            size: 18,
          ),
          Text(
            questModelStream.location,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'JosefinSans'),
          ),
        ],
      ),
      trailing:Heart(
                database: database,
                
                questModel: questModelStream,
              )
            
          
        
      
    );
  }

  Widget _buildQuestDescriptionCard(
      BuildContext context, QuestModel questModelStream) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: ExpandablePanel(
          
          header: Column(
            children: <Widget>[
              Text(
                'Quest Details',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          collapsed: ExpandableButton(
            child: Column(
              children: <Widget>[
                _buildQuestDetailCard(context, questModelStream),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    questModelStream.description,
                    style: TextStyle(height: 1.35),
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          expanded: ExpandableButton(
            child: Column(
              children: <Widget>[
                _buildQuestDetailCard(context, questModelStream),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    questModelStream.description,
                    style: TextStyle(height: 1.35),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          theme: const ExpandableThemeData(
              crossFadePoint: 0,
              tapBodyToExpand: true,
              tapBodyToCollapse: true,
              hasIcon: true,
              iconColor: MaterialTheme.orange,
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              iconSize: 40,),
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
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text(
              'Bounty Details',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildTreasure(context, questModelStream),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreasure(BuildContext context, QuestModel questModelStream) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.brown),
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          ListTile(
            leading: Image.asset(
              'images/treasure.png',
              height: 35,
            ),
            title: ShopButton(
              numberOfDiamonds: questModelStream.bountyDiamonds,              
              diamondHeight: 25,              
              fontSize: 18,
              fontWeight: FontWeight.bold,
              mainAxisAlignment: MainAxisAlignment.center,              
            ),
            trailing: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.brown.shade400,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(width: 1, color: Colors.amberAccent),
              ),
              child: AutoSizeText(
                '${questModel.questPoints.toString()} points',
                style: TextStyle(
                    color: Colors.amberAccent, fontWeight: FontWeight.bold),
                maxLines: 1,
                minFontSize: 15,
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    QuestModel questModelStream,
    UserData userData,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        color: Colors.grey.shade800,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: ShopButton(
                numberOfDiamonds: questModelStream.numberOfDiamonds,               
                mainAxisAlignment: MainAxisAlignment.start,               
                fontSize: 22,
                fontWeight: FontWeight.bold,
                diamondHeight: 35,      
                showShop: false,        
              ),
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: QuestDiamondCalulationButton(
                    questModelStream: questModelStream,
                    userData: userData,
                    databaseService: database,

                  ),
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
          context: context,
          image: 'images/deadline.png',
          imageHeight: 40,
          difficulty: difficulty,
          platformTitle: 'Quest Length\n $difficulty',
          platformContent:
              'Allow ${questTimeCalc(difficulty)} to complete this quest.',
          platformImage: Image.asset(
            'images/deadline.png',
            height: 80,
          ),
        ),
      ],
    );
  }

  String questTimeCalc(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return 'up to 3 hours';
        break;
      case 'Moderate':
        return 'up to 8 hours';
        break;
      case 'Hard':
        return 'more than 1 day';
      default:
        return 'Up to 3 hours';
    }
  }

  Widget _buildBrainListTile(BuildContext context, String difficulty) {
    return Column(
      children: <Widget>[
        QuestDetailsListTile(
          context: context,
          image: 'images/brain.png',
          imageHeight: 40,
          difficulty: difficulty,
          platformTitle: 'Brain Strain\n $difficulty ',
          platformContent: '${questBrainCalc(difficulty)}',
          platformImage: Image.asset(
            'images/brain.png',
            height: 80,
          ),
        ),
      ],
    );
  }

  String questBrainCalc(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return 'During the quest expect to be asked simple questions.';
        break;
      case 'Moderate':
        return 'During the quest expect that some of the questions or riddles to be challenging.';
        break;
      case 'Hard':
        return 'Time to put your thinking cap on! During the quest expect difficult questions or riddles that will use all of your mental fortitude to complete.';
      default:
        return 'Expect to be asked simple questions or riddles during the quest.';
    }
  }

  Widget _buildHikingListTile(BuildContext context, String difficulty) {
    return Column(
      children: <Widget>[
        QuestDetailsListTile(
          context: context,
          image: 'images/hiker.png',
          imageHeight: 40,
          difficulty: difficulty,
          platformTitle: 'Physical Difficulty\n $difficulty',
          platformContent: '${questHikeCalc(difficulty)}',
          platformImage: Image.asset(
            'images/hiker.png',
            height: 80,
          ),
        ),
      ],
    );
  }

  String questHikeCalc(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return 'During the quest expect mainly flat terrain and walking distances no greater than a few kilometers.';
        break;
      case 'Moderate':
        return 'During the quest expect flat to moderate slopes and walking distances no greater than 5 kilometers.';
        break;
      case 'Hard':
        return 'During the quest expect flat to steep slopes and hiking distances up to 10 kilometers. Expereinced hikers only';
      default:
        return 'During the quest expect mainly flat terrain and walking distances no greater than a few kilometers.';
    }
  }

  // Widget _buildBountyText(
  //     {BuildContext context, int maxLines, TextOverflow overflow}) {
  //   return RichText(
  //       textAlign: TextAlign.justify,
  //       maxLines: maxLines,
  //       overflow: overflow,
  //       text: TextSpan(
  //           style: Theme.of(context).textTheme.bodyText2.copyWith(
  //                 fontSize: 20,
  //                 height: 1.35,
  //               ),
  //           children: [
  //             TextSpan(
  //                 text:
  //                     'If you have the skills to conquer this quest you will be rewarded with '),
  //             TextSpan(
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .bodyText2
  //                     .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
  //                 text: '${questModel.numberOfDiamonds} diamonds '),
  //             TextSpan(text: 'and '),
  //             TextSpan(
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .bodyText2
  //                     .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
  //                 text: '${questModel.numberOfKeys} key. '),
  //             TextSpan(
  //                 text:
  //                     'Conquer all of the challenges with no mistakes and you\'ll receive '),
  //             TextSpan(
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .bodyText2
  //                     .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
  //                 text: '${questModel.questPoints} points '),
  //             TextSpan(
  //                 text:
  //                     'which will look pretty darn nice on the leaderboard! '),
  //           ]));
  // }
}
