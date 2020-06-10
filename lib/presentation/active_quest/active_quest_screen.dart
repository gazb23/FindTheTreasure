import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/active_quest/question_types/question_scroll_single_answer.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_location_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_the_treasure/view_models/location_view_model.dart';

class ActiveQuestScreen extends StatelessWidget {
  static const String id = 'active_quest_page';
  final QuestModel questModel;

  const ActiveQuestScreen({Key key, this.questModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService =
        Provider.of<DatabaseService>(context);
    bool _isLoading = false;
    return ChangeNotifierProvider<LocationViewModel>(
      create: (context) => LocationViewModel(),
      child: Consumer<LocationViewModel>(
        builder: (context, locationViewModel, _) => SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: AutoSizeText(
                questModel.title,
                maxLines: 1,
                style: const TextStyle(color: Colors.black87),
              ),
              iconTheme: const IconThemeData(
                color: Colors.black87,
              ),
              actions: <Widget>[
                Consumer<UserData>(
                  builder: (_, _userData, __) => DiamondAndKeyContainer(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    numberOfDiamonds: _userData.userDiamondCount,
                    numberOfKeys: _userData.userKeyCount,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      
                        image: AssetImage("images/bckgrnd_balon.png"),
                        fit: BoxFit.fill),
                  ),
                  child: BackdropFilter(filter: ImageFilter.blur(
                    sigmaX: 5, sigmaY: 5, 
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),),
                ),
                Consumer<DatabaseService>(
                  builder: (_, _databaseService, __) => StreamBuilder<
                          List<LocationModel>>(
                      stream: _databaseService.locationsStream(
                          questId: questModel.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          final _numberOfLocations = snapshot.data.length;
                          final _locationsCompleted = snapshot.data
                              .where((locationModel) => locationModel
                                  .locationCompletedBy
                                  .contains(databaseService.uid))
                              .length;

                          return ListItemsBuilder<LocationModel>(
                            title: 'Say whhhaaat!',
                            message:
                                'No locations to explore! The Find The Treasure team needs to pick up their act!',
                            snapshot: snapshot,
                            itemBuilder: (context, locationModel, _) =>
                                QuestLocationCard(
                              lastLocationCompleted:
                                  _numberOfLocations == _locationsCompleted + 1,
                              locationModel: locationModel,
                              questModel: questModel,
                              databaseService: _databaseService,
                              isLoading: _isLoading,
                              onTap: () async {
                                try {
                                  _isLoading = true;
                                  // To discover the location, the user must first answer a location question
                                  if (locationModel.locationStartedBy
                                      .contains(_databaseService.uid)) {
                                    return null;
                                  } else
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            QuestionScrollSingleAnswer(
                                          isFinalChallenge: true,
                                          locationQuestion: true,
                                          locationModel: locationModel,
                                          questModel: questModel,
                                        ),
                                      ),
                                    );
                                } catch (e) {
                                  _isLoading = false;
                                }
                              },
                            ),
                          );
                        }
                        return Container();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
