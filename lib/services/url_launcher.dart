import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  
  static void socialAppLauncher({
    @required BuildContext context,
    @required String primaryUrl,
    @required String fallBackUrll,
  }) async {
    try {
      bool launched = await launch(primaryUrl, forceSafariVC: false);
      if (!launched) {
        await launch(primaryUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallBackUrll, forceSafariVC: true);
    }
  }
}