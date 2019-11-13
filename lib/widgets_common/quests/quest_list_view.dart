import 'package:flutter/material.dart';

class QuestListView extends StatelessWidget {
  final AssetImage image;
  final String title;
  final Color difficultyColor;
  final String difficultyTitle;
  final int diamondCount;
  final int keyCount;

  const QuestListView({
    Key key,
    @required this.title,
    @required this.difficultyColor,
    @required this.difficultyTitle,
    @required this.diamondCount,
    @required this.keyCount,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      color: Colors.black87,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image: image,
                  fit: BoxFit.fill,

                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                  alignment: Alignment.topCenter),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                      color: difficultyColor),
                  child: Text(
                    difficultyTitle,
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
                        diamondCount.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      Image.asset(
                        'images/explore/key.png',
                        height: 40.0,
                      ),
                      Text(
                        keyCount.toString(),
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
    );
  }
}
