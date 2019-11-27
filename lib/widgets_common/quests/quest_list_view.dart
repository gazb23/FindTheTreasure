import 'package:flutter/material.dart';

class QuestListView extends StatelessWidget {
  final String image;
  final String title;
  final String difficulty;
  final int numberOfDiamonds;
  final int numberOfKeys;

  const QuestListView({
    Key key,
    @required this.title,
    @required this.difficulty,
    @required this.numberOfDiamonds,
    @required this.numberOfKeys,
    @required this.image,
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
          onTap: () {},
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.85), BlendMode.dstATop),
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
                  trailing: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 150.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset('images/ic_diamond.png'),
                          Text(
                            numberOfDiamonds.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Image.asset(
                            'images/explore/key.png',
                            height: 40.0,
                          ),
                          Text(
                            numberOfDiamonds.toString(),
                            style: TextStyle(color: Colors.white),
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
