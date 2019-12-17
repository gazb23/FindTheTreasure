// import 'package:find_the_treasure/models/quest_model.dart';
// import 'package:find_the_treasure/services/database.dart';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class Heart extends StatelessWidget {
//   final QuestModel questModel;

//  Heart({Key key, this.questModel}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final database = Provider.of<DatabaseService>(context);
//     return StreamBuilder<List<QuestModel>>(
//         stream: database.questsStream(),
//         builder: (context, snapshot) {
//           final questModel = snapshot.data;
//           return IconButton(
//               icon: Icon(
//                 questModel.
//                     ? Icons.favorite
//                     : Icons.favorite_border,
//                 color: questModel.heartIsSelected
//                     ? Colors.redAccent
//                     : Colors.white,
//                 size: 35,
//               ),
//               onPressed: () {
//                 questModel.heartIsSelected = !questModel.heartIsSelected;
//                 _addQuestData(context);
//                 print(questModel.heartIsSelected);
//               });
//         });
//           }
          
//   }

//   Future<void> _addQuestData(BuildContext context) async {
//     final database = Provider.of<DatabaseService>(context);

//     await database.updateUserQuests(
//         QuestModel(id: questModel.id, description: questModel.description));
//   }
// }
