import 'package:find_the_treasure/widgets_common/quests/heart.dart';
import 'package:flutter/material.dart';

class QuestListView extends StatelessWidget {
  final String image;
  final String title;
  final String difficulty;
  final String numberOfLocations;
  final String location;
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
    this.onTap, this.location, this.numberOfLocations,
  }) : super(key: key);

  // Function that takes the difficulty string passed in via the CMS to Firebase and return a Color corresponding to that difficulty.
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
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Material(
        color: Colors.black87,
        child: InkWell(
          enableFeedback: true,
          splashColor: Colors.orangeAccent,
          onTap: onTap,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        image,
                      ),
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.75), BlendMode.dstATop),
                      alignment: Alignment.center),
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  title: Text(
                    title,
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
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(                        
                        location,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'JosefinSans'),
                      ),
                    ],
                  ),
                  trailing: Heart(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.grey.shade900,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: _questDifficulty(difficulty),
                      ),
                      child: Text(
                        difficulty,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Container(
                      child: Text(
                        '$numberOfLocations Locations',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      width: 135.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.asset(
                            'images/ic_diamond.png',
                            height: 25,
                          ),
                          Text(
                            numberOfDiamonds.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          Image.asset(
                            'images/explore/skull_key.png',
                            height: 30.0,
                          ),
                          Text(
                            numberOfKeys.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
