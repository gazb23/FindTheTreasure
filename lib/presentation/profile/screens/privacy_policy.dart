import 'package:find_the_treasure/models/legal_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/custom_circular_progress_indicator_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),     
        backgroundColor: MaterialTheme.blue,
      ),
      body: StreamBuilder<LegalModel>(
          stream: databaseService.legalStream(),
          builder: (context, legal) {
            if (legal.hasData &&
                legal.connectionState == ConnectionState.active) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(legal.data.privacyPolicy ?? 'no data'),
                  ),
                ),
              );
            } else
              return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: CustomCircularProgressIndicator(color: Colors.orange,)));
          }),
    );
  }
}
