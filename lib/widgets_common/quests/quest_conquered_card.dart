import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/heart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class QuestConqueredCard extends StatefulWidget {
  final QuestModel questModel;

  final String image;
  final String title;
  final String difficulty;
  final String location;
  final int numberOfLocations;
  final int numberOfDiamonds;
  // final int numberOfKeys;
  final VoidCallback onTap;

  const QuestConqueredCard({
    Key key,
    @required this.title,
    @required this.difficulty,
    @required this.numberOfDiamonds,
    // @required this.numberOfKeys,
    @required this.image,
    this.onTap,
    this.location,
    this.numberOfLocations,
    this.questModel,
  }) : super(key: key);

  @override
  _QuestConqueredCardState createState() => _QuestConqueredCardState();
}

class _QuestConqueredCardState extends State<QuestConqueredCard> {
  



  @override
  Widget build(BuildContext context) {
    final DatabaseService database = Provider.of<DatabaseService>(context);
    


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Material(
        color: Colors.grey.shade800,
        child: InkWell(
          enableFeedback: true,
          splashColor: Colors.white,
          onTap: widget.onTap,
          child: Column(
            children: <Widget>[
              CachedNetworkImage(
                  imageUrl: widget.image,
                  placeholder: (context, url) => Container(
                        height: MediaQuery.of(context).size.height / 4.2,
                      ),
                  fadeInDuration: const Duration(milliseconds: 1000),
                  fadeOutDuration: const Duration(milliseconds: 500),
                  errorWidget: (context, url, error) => Container(
                    height: MediaQuery.of(context).size.height / 4.2,
                    child: Center(child: Icon(Icons.error))),
                  imageBuilder: (context, image) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4.2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: image,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.8),
                                BlendMode.dstATop),
                            alignment: Alignment.center),
                      ),
                      child: 
                          BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 3,
                                sigmaY: 3,
                              ),
                              child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: 
                                        buildQuestListTile(context, database))),
                            )
                          ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    border: Border(
                        top: const BorderSide(color: Colors.white, width: 1)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [
                          0.5,
                          0.8,
                        ],
                        colors: [
                          Colors.grey.shade800,
                          Colors.grey.shade700
                        ])),
                child:
                   Container(
                            width: double.infinity,
                            child: Shimmer.fromColors(
                              period: const Duration(milliseconds: 750),
                              baseColor: Colors.amberAccent,
                              loop: 3,
                              highlightColor: Colors.grey.shade100,
                              child: const Text(
                                'QUEST CONQUERED',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.amberAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                       
                            
                          
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestListTile(BuildContext context, DatabaseService database) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      title: Text(
        widget.title,
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
            widget.location,
            style: TextStyle(
                color: Colors.grey.shade100,
                fontWeight: FontWeight.w600,
                fontFamily: 'JosefinSans'),
          ),
        ],
      ),
      trailing:  Heart(
        database: database,
        questModel: widget.questModel,
      ),
    );
  }




}
