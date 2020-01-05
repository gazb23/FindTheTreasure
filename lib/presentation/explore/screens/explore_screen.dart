import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/screens/quest_detail_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/presentation/profile/screens/profile_screen.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lock this screen to portrait orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          centerTitle: true,
          title: FlatButton(
            onPressed: () => Navigator.pushNamed(
              context,
              ProfileScreen.id,
            ),
            child: Image.asset('images/andicon.png', height: 50,
            ),
          ),
        ),
        body: _buildListView(context),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);
    final user = Provider.of<UserData>(context);
    return StreamBuilder<List<QuestModel>>(
        stream: database.questsStream(),
        builder: (context, snapshot) {
          
          return ListItemsBuilder<QuestModel>(
            snapshot: snapshot,
            itemBuilder: (context, quest) => QuestListView(
              numberOfDiamonds: quest.numberOfDiamonds,
              difficulty: quest.difficulty,
              numberOfKeys: quest.numberOfKeys,
              title: quest.title,
              image: quest.image,
              numberOfLocations: quest.numberOfLocations,
              location: quest.location,
              questModel: quest,       
                    
              onTap: () {
                QuestDetailScreen.show(context, quest: quest, user: user, database: database );
                
              },
            ),
          );
          }
          
        );
  }
}
