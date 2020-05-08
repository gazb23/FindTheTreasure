import 'package:find_the_treasure/presentation/profile/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Help'),
        centerTitle: true,
      ),
      body: Column(

      children: <Widget>[
        SizedBox(height: 20,),
        CustomListTile(
          title: 'FAQs',
          leadingIcon: Icons.question_answer,
          leadingContainerColor: Colors.grey.shade200,
          
        ),
        CustomListTile(
          title: 'Rate App',
          leadingIcon: Icons.star,
          leadingContainerColor: Colors.grey.shade200,
        ),
        CustomListTile(
          title: 'Contact',
          leadingIcon: Icons.email,
          leadingContainerColor: Colors.grey.shade200,
        ),
        CustomListTile(
          title: 'Privacy Policy',
          leadingIcon: Icons.insert_drive_file,
          leadingContainerColor: Colors.grey.shade200,
        ),
        CustomListTile(
          title: 'Terms & Conditions',
          leadingIcon: Icons.insert_drive_file,
          leadingContainerColor: Colors.grey.shade200,
        ),
      ],
    ),
    );
    
    
  }
}