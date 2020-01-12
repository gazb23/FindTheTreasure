import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/answer_box.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';

import 'package:find_the_treasure/widgets_common/quests/scroll.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class QuestStartScreen extends StatelessWidget {
  static const String id = 'quest_start_screen';
  final QuestModel questModel;

  const QuestStartScreen({Key key, this.questModel}) : super(key: key);

  static Future<void> show(BuildContext context, {QuestModel questModel}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => QuestStartScreen(
                questModel: questModel,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    final UserData userData = Provider.of<UserData>(context);
    return StreamBuilder<QuestModel>(
      stream: databaseService.questStream(documentId: questModel.id),
      builder: (context, snapshot) {
        final _quest = snapshot.data;
        print(_quest.title);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(_quest.title),
              iconTheme: IconThemeData(
                color: Colors.black87,
              ),
              
              actions: <Widget>[
                DiamondAndKeyContainer(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  numberOfDiamonds: userData.userDiamondCount,
                  numberOfKeys: userData.userKeyCount,
                  color: Colors.black87,
                  
                ),
                SizedBox(width: 20,)
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'images/background_games.png',
                      ),
                      fit: BoxFit.fill)),
              child: ListView(
                children: <Widget>[
                  _buildPirateIntro(context, questModel),
                  SizedBox(
                    height: 20,
                  ),
                  AnswerBox(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

Widget _buildPirateIntro(BuildContext context, QuestModel questModel) {
  // final _database = Provider.of<DatabaseService>(context);
  
        return Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Stack(children: <Widget>[
              
              Container(
                width: MediaQuery.of(context).size.width,
                
                padding: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 15),
                margin: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  color: Colors.brown,
                ),
                child: Center(
                    child: Text(
                        'Ahoy me matey. This ancient scroll will lead you to where you need to be!',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset('images/pirate.png')),
            ]),
            SizedBox(
              height: 10,
            ),
            Scroll()
          ],
        );
      }


