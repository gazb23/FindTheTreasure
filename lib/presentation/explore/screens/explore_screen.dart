import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/quest_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          centerTitle: true,
          title: FlatButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        content: Text('You clicked me'),
                        title: Text('TREASURE!!'),
                      )),
              child: Image.asset('images/ic_treasure.png')),
        ),
        body: _buildListView(context),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<QuestModel>>(
      stream: database.questsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<QuestModel>(
          snapshot: snapshot,
          itemBuilder: (context, quest) => QuestListView(
            diamondCount: quest.diamondCount,            
            difficultyTitle: quest.difficultyTitle,
            keyCount: quest.keyCount,
            title: quest.title,
            image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/find-the-treasure-8d58f.appspot.com/o/Coolum.jpg?alt=media&token=7dca0d86-ea30-4117-b2c8-76bd1eb514c6'),

          ),
        );

      }
    );
  }
}
