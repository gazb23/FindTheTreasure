import 'package:find_the_treasure/models/faq_model.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FAQScreen extends StatefulWidget {
  static const String id = 'FAQ_page';

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    // Lock this screen to portrait orientation
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('FAQs'),
          backgroundColor: MaterialTheme.red,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: _buildListView(context));
  }

  Widget _buildListView(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);
    return StreamBuilder<List<FAQModel>>(
        stream: database.faqsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<FAQModel>(
            snapshot: snapshot,
            title: 'Error!',
            message: 'Oh No! We are unable to reach the FAQs. Please try again later.',
            itemBuilder: (context, faqModel, index) => ExpandableCard(
              question: faqModel.question,
              answer: faqModel.answer,
            ),
          );
        });
  }
}
