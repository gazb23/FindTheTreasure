import 'package:find_the_treasure/widgets/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String content;
  final String defaultActionText;

  PlatformAlertDialog({this.title, this.content, this.defaultActionText});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    // TODO: implement buildCupertinoWidget
    return null;
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    // TODO: implement buildMaterialWidget
    return null;
  }

}