import 'dart:io';

import 'package:find_the_treasure/presentation/profile/widgets/custom_list_tile.dart';
import 'package:find_the_treasure/services/url_launcher.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  final String version;
  static const String _fAQsPrimaryUrl =
      'https://www.findthetreasure.com.au/faqs/';
  static const String _fallbackUrl = 'https://www.findthetreasure.com.au/';
  static const String _contactPrimaryUrl =
      'https://www.findthetreasure.com.au/contact-us/';
  static const String _privacyPrimaryUrl =
      'https://www.findthetreasure.com.au/privacy-policy/';
  static const String _termsPrimaryUrl =
      'https://www.findthetreasure.com.au/terms-conditions/';
        static const String _googlePrimaryUrl =
      'https://play.google.com/store/apps/details?id=com.findthetreasure.find_the_treasure';
  static const String _applePrimaryUrl =
      'https://www.apple.com/au/ios/app-store/';

  const HelpScreen({Key key, @required this.version}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Text('Help'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          CustomListTile(
            title: 'FAQs',
            leadingIcon: Icons.question_answer,
            leadingContainerColor: Colors.grey.shade200,
            onTap: () {
              UrlLauncher.socialAppLauncher(
                context: context,
                primaryUrl: _fAQsPrimaryUrl,
                fallBackUrll: _fallbackUrl,
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
                fallBackUrll: _googlePrimaryUrl,
              );
               } else {
                   UrlLauncher.socialAppLauncher(
                context: context,
                primaryUrl: _applePrimaryUrl,
                fallBackUrll: _applePrimaryUrl,
              );
               }
              
            },
          ),
          CustomListTile(
            title: 'Contact',
            leadingIcon: Icons.email,
            leadingContainerColor: Colors.grey.shade200,
            onTap: () {
              UrlLauncher.socialAppLauncher(
                context: context,
                primaryUrl: _contactPrimaryUrl,
                fallBackUrll: _fallbackUrl,
              );
            },
          ),
          CustomListTile(
            title: 'Privacy Policy',
            leadingIcon: Icons.insert_drive_file,
            leadingContainerColor: Colors.grey.shade200,
            onTap: () {
              UrlLauncher.socialAppLauncher(
                context: context,
                primaryUrl: _privacyPrimaryUrl,
                fallBackUrll: _fallbackUrl,
              );
            },
          ),
          CustomListTile(
            title: 'Terms & Conditions',
            leadingIcon: Icons.insert_drive_file,
            leadingContainerColor: Colors.grey.shade200,
             onTap: () {
              UrlLauncher.socialAppLauncher(
                context: context,
                primaryUrl: _termsPrimaryUrl,
                fallBackUrll: _fallbackUrl,
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
               applicationIcon: Image.asset('images/andicon.png', height: 30,),
               applicationName: 'Find The Treasure',
               applicationVersion: 'version:' + version,
                

             );
            },
          ),
        ],
      ),
    );
  }
}
