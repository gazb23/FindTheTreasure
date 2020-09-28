import 'dart:io';

import 'package:find_the_treasure/presentation/profile/screens/frequently_asked_questions.dart';
import 'package:find_the_treasure/presentation/profile/screens/privacy_policy.dart';
import 'package:find_the_treasure/presentation/profile/screens/term_and_conditions.dart';
import 'package:find_the_treasure/presentation/profile/widgets/custom_list_tile.dart';
import 'package:find_the_treasure/services/url_launcher.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  final String version;
  static const String _fallbackUrl = 'https://www.findthetreasure.com.au/';
  static Uri mail = Uri(
      scheme: 'mailto',
      path: 'support@findthetreasure.com.au',
      query:
          'subject=App question&body=Hi,<br><br> I have a question regarding the Find The Treasure App.');

  static const String _contactPrimaryUrl =
      'mailto:support@findthetreasure.com.au?subject=App question&body=Hi,<br><br> I have a question regarding the Find The Treasure App.';
  static const String _contactFallbackUrl =
      'https://www.findthetreasure.com.au/';

  static const String _googlePrimaryUrl =
      'https://play.google.com/store/apps/details?id=com.findthetreasure.find_the_treasure';
  static const String _googleFallbackUrl = 'https://play.google.com/';

  static const String _applePrimaryUrl =
      'https://apps.apple.com/us/app/id1516617779';
  static const String _appleFallBackUrl = 'https://apps.apple.com/';

  const HelpScreen({Key key, @required this.version}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MaterialTheme.red,
        title: Text('Help'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          CustomListTile(
            title: 'FAQs',
            leadingIcon: Icons.question_answer,
            leadingContainerColor: Colors.grey.shade200,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => FAQScreen(),
                ),
              );
            },
          ),
          CustomListTile(
            title: 'Rate App',
            leadingIcon: Icons.star,
            leadingContainerColor: Colors.grey.shade200,
            onTap: () {
              if (Platform.isAndroid) {
                UrlLauncher.socialAppLauncher(
                  context: context,
                  primaryUrl: _googlePrimaryUrl,
                  fallBackUrll: _googleFallbackUrl,
                );
              } else {
                UrlLauncher.socialAppLauncher(
                  context: context,
                  primaryUrl: _applePrimaryUrl,
                  fallBackUrll: _appleFallBackUrl,
                );
              }
            },
          ),
          CustomListTile(
            title: 'Contact',
            leadingIcon: Icons.email,
            leadingContainerColor: Colors.grey.shade200,
            onTap: () {
              if (Platform.isAndroid)
                UrlLauncher.socialAppLauncher(
                  context: context,
                  primaryUrl: _contactPrimaryUrl,
                  fallBackUrll: _contactFallbackUrl,
                );
              else
                UrlLauncher.socialAppLauncher(
                  context: context,
                  primaryUrl: mail.toString(),
                  fallBackUrll: _contactFallbackUrl,
                );
            },
          ),
          CustomListTile(
            title: 'Visit Us',
            leadingIcon: Icons.language,
            leadingContainerColor: Colors.grey.shade200,
            onTap: () {
              UrlLauncher.socialAppLauncher(
                context: context,
                primaryUrl: _fallbackUrl,
                fallBackUrll: _fallbackUrl,
              );
            },
          ),
          CustomListTile(
            title: 'Privacy Policy',
            leadingIcon: Icons.insert_drive_file,
            leadingContainerColor: Colors.grey.shade200,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicy(),
                ),
              );
            },
          ),
          CustomListTile(
            title: 'Terms & Conditions',
            leadingIcon: Icons.insert_drive_file,
            leadingContainerColor: Colors.grey.shade200,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => TermsAndConditions(),
                ),
              );
            },
          ),
          CustomListTile(
            title: 'About',
            leadingIcon: Icons.help,
            leadingContainerColor: Colors.grey.shade200,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationIcon: Image.asset(
                  'images/andicon.png',
                  height: 30,
                ),
                applicationName: 'Find The Treasure',
                applicationLegalese: 'Copyright 2020 Find The Treasure',
                applicationVersion: 'version: ' + version,
              );
            },
          ),
        ],
      ),
    );
  }
}
