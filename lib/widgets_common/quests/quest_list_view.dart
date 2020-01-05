import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/widgets_common/quests/heart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestListView extends StatefulWidget {
  final QuestModel questModel;

  final String image;
  final String title;
  final String difficulty;
  final String location;
  final int numberOfLocations;
  final int numberOfDiamonds;
  final int numberOfKeys;
  final VoidCallback onTap;

  const QuestListView({
    Key key,
    @required this.title,
    @required this.difficulty,
    @required this.numberOfDiamonds,
    @required this.numberOfKeys,
    @required this.image,
    this.onTap,
    this.location,
    this.numberOfLocations,
    this.questModel,
  }) : super(key: key);

  @override
  _QuestListViewState createState() => _QuestListViewState();
}

class _QuestListViewState extends State<QuestListView> {
  Color _questDifficulty(String difficultyTitle) {
    switch (difficultyTitle) {
      case 'Easy':
        return Colors.green;
        break;
      case 'Moderate':
        return Colors.orangeAccent;
        break;
      case 'Hard':
        return Colors.redAccent;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService database = Provider.of<DatabaseService>(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Material(
        color: Colors.grey.shade800,
        child: InkWell(
          enableFeedback: true,
          splashColor: Colors.orangeAccent,
          onTap: widget.onTap,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        widget.image,
                      ),
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.75), BlendMode.dstATop),
                      alignment: Alignment.center),
                ),
                child: buildQuestListTile(context, database),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [
                      0.5,
                      0.8,
                    ],
                        colors: [
                      Colors.grey.shade900,
                      Colors.grey.shade800
                    ])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildDifficultyIndicator(),
                    buildNumberOfLocations(),
                    DiamondAndKeyContainer(
                      numberOfDiamonds: widget.numberOfDiamonds,
                      numberOfKeys: widget.numberOfKeys,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestListTile(BuildContext context, DatabaseService database) {
    final questModel = widget.questModel;
    final isLikedByUser = questModel.likedBy.contains(database.uid);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      title: Text(
        widget.title,
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
            widget.location,
            style: TextStyle(
                color: Colors.grey.shade100,
                fontWeight: FontWeight.w600,
                fontFamily: 'JosefinSans'),
          ),
        ],
      ),
      trailing: Heart(
        database: database,
        isLikedByUser: isLikedByUser,
        questModel: widget.questModel,
      ),
    );
  }

  Widget buildNumberOfLocations() {
    return Container(
      child: Text(
        '${widget.numberOfLocations} Locations',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget buildDifficultyIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: _questDifficulty(widget.difficulty),
      ),
      child: Text(
        widget.difficulty,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
