import 'package:flutter/material.dart';

class QuestListView extends StatelessWidget {
  final NetworkImage image;
  final String title;
  final Color difficultyColor;
  final String difficultyTitle;
  final int diamondCount;
  final int keyCount;

  const QuestListView({
    Key key,
    @required this.title,
    this.difficultyColor,
    @required this.difficultyTitle,
    @required this.diamondCount,
    @required this.keyCount,
    @required this.image,
  }) : super(key: key);

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
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: image,
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
                          color: Colors.orangeAccent),
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
        ),
      ),
    );
  }
}
