import 'package:find_the_treasure/models/faq_model.dart';
import 'package:find_the_treasure/presentation/explore/widgets/list_items_builder.dart';
import 'package:find_the_treasure/services/database.dart';
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
          title: Text('FAQs'),
          
          backgroundColor: Colors.grey.shade800,
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
         if (snapshot.connectionState == ConnectionState.active) {
            return ListItemsBuilder<FAQModel>(
        
           
            snapshot: snapshot,
            title: 'No FAQs!',
            message: 'Oh No!',
            itemBuilder: (context, faqModel, index) => ExpandableCard(
               question: faqModel.question,
               answer: faqModel.answer,
               
                ),
          );
         } if (snapshot.connectionState == ConnectionState.waiting) {
           return Container(
             height: MediaQuery.of(context).size.height,
             width: double.infinity,
             child: CircularProgressIndicator(),
           );
         }
         
          else 
           return Container(
             height: MediaQuery.of(context).size.height,
             width: double.infinity,
             child: CircularProgressIndicator(),
           );
        });
  }
}
