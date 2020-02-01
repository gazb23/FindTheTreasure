import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_location_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveQuestScreen extends StatelessWidget {
  final QuestModel questModel;  

  const ActiveQuestScreen({Key key, @required this.questModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _databaseService = Provider.of<DatabaseService>(context);
    final UserData _userData = Provider.of<UserData>(context);
    
        return StreamBuilder<List<QuestionsModel>>(
          stream: _databaseService.locationsStream(questId: questModel.id),
          builder: (context, snapshot) {
            return SafeArea(
                  child: Scaffold(
                appBar: AppBar(
                        title: Text(questModel.title),
                        iconTheme: IconThemeData(
                          color: Colors.black87,
                        ),
                        actions: <Widget>[
                          DiamondAndKeyContainer(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            numberOfDiamonds: _userData.userDiamondCount,
                            numberOfKeys: _userData.userKeyCount,
                            color: Colors.black87,
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                body: Stack(
                  children: <Widget>[
                  
                    Container(            
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/background_games.png"),
                            fit: BoxFit.fill),
                      ),
                    ),
                    
                    StreamBuilder<List<QuestionsModel>>(              
                      stream: _databaseService.locationsStream(questId: questModel.id),
                      builder: (context, snapshot) {

                      
                        return ListItemsBuilder<QuestionsModel>(
                          title: 'Say whhhaaat!',
                          message: 'No locations to explore! The Find The Treasure team needs to pick up their act!',
                          snapshot: snapshot,
                          itemBuilder: (context, questionsModel) => QuestLocationCard(
                            questionsModel: questionsModel,
                            questModel: questModel,
                            databaseService: _databaseService,
                          ),
                        );
                        
                      }
                    )
                  ],
                ),
              ),
            );
          }
        );
      }


  }

