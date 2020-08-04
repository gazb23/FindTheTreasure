import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:flutter/services.dart';

class Heart extends StatefulWidget {
  final DatabaseService database;
  final QuestModel questModel;
  final bool isLikedByUser;

  Heart({
    @required this.isLikedByUser,
    @required this.database,
    @required this.questModel,
  })  : assert(questModel != null),
        assert(database != null),
        assert(isLikedByUser != null);

  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> with TickerProviderStateMixin {
 

  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    
    
  }
 

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.5).animate(
          CurvedAnimation(parent: controller, curve: Curves.elasticOut)),
      child: IconButton(
          icon: Icon(
            widget.isLikedByUser ? Icons.favorite : Icons.favorite_border,
            color: widget.isLikedByUser ? MaterialTheme.red : Colors.white,
            size: 35,
          ),
          onPressed: () async {
            controller.forward();
            await Future.delayed(Duration(milliseconds: 200));
            if (mounted) controller.reverse();
            try {             
            
            widget.isLikedByUser
                ? await widget.database.arrayRemove(widget.questModel.id)
                : await widget.database.arrayUnion(widget.questModel.id);
            } on PlatformException {
              PlatformAlertDialog(title: 'Permission Denied', content: 'Unable to update data', defaultActionText: 'OK').show(context);
            } 
            
            catch(e) {
              print(e.toString());
            }
             
            
          
            
          }),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
