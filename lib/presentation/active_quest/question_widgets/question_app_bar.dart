import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/view_models/challenge_view_model.dart';
import 'package:find_the_treasure/view_models/location_view_model.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool locationQuestion;
  final QuestModel questModel;
  final LocationModel locationModel;
  final QuestionsModel questionsModel;

  const QuestionAppBar({
    Key key,
    @required this.locationQuestion,
    this.questModel,
    this.locationModel,
    this.questionsModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService =
        Provider.of<DatabaseService>(context);
            final UserData userData = Provider.of<UserData>(context);
    return AppBar(
       centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black87,
          ),
          
          actions: <Widget>[
            
            DiamondAndKeyContainer(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              numberOfDiamonds: userData.userDiamondCount,              
              diamondHeight: 25,
              color: Colors.black87,
            ),
            const SizedBox(
              width: 20,
            )
          ],
      title: Builder(
        builder: (context) => !locationQuestion
            ? StreamBuilder<QuestionsModel>(
                stream: databaseService.challengeStream(
                    questId: questModel?.id,
                    locationId: locationModel?.id,
                    challengeId: questionsModel?.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final questionsModelStream = snapshot.data;
                    return InkWell(
                      onTap: () {
                        ChallengeViewModel.showHint(
                          context: context,
                          questionsModel: questionsModelStream,
                          locationModel: locationModel,
                          questModel: questModel,
                        );
                      },
                      child: Container(
                          padding: const EdgeInsets.all(15),
                          child: AutoSizeText(
                            !questionsModelStream.hintPurchasedBy
                                    .contains(databaseService.uid)
                                ? 'HINT?'
                                : 'SHOW HINT',
                            style: const TextStyle(color: MaterialTheme.orange),
                          )),
                    );
                  }
                  return Container();
                })
            : StreamBuilder<LocationModel>(
                stream: databaseService.locationStream(
                  questId: questModel?.id,
                  locationId: locationModel?.id,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final locationModelStream = snapshot.data;
                    return InkWell(
                      onTap: () {
                        LocationViewModel().showHint(
                            context: context,
                            locationModel: locationModelStream,
                            questModel: questModel);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: AutoSizeText(
                          !locationModelStream.hintPurchasedBy
                                  .contains(databaseService.uid)
                              ? 'HINT?'
                              : 'SHOW HINT',
                          style: TextStyle(color: MaterialTheme.orange),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);  
}
