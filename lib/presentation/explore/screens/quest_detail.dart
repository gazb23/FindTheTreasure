import 'package:find_the_treasure/models/quest_model.dart';
import 'package:flutter/material.dart';


class QuestDetailPage extends StatefulWidget {

  final QuestModel questModel;

  const QuestDetailPage({Key key, this.questModel}) : super(key: key);



  static Future<void> show(BuildContext context, {QuestModel quest}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => QuestDetailPage(questModel: quest,),
        fullscreenDialog: true,
        
      ),
    );
  }

  @override
  _QuestDetailPageState createState() => _QuestDetailPageState();
}

class _QuestDetailPageState extends State<QuestDetailPage> {
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
          child: Scaffold(
        
        body: Container(
          //TODO: Add mediaquery to all pictures
          height: MediaQuery.of(context).size.height/2.5,
            child: Image.network(widget.questModel.image, fit: BoxFit.cover,),
          ),
      ),
    );
  }
}
