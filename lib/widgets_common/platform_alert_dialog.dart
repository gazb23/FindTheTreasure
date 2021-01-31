import 'dart:io';
import 'package:find_the_treasure/constants.dart';
import 'package:find_the_treasure/theme.dart';

import 'package:find_the_treasure/widgets_common/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;
  final Widget image;
  final bool showPoints;
  final Color backgroundColor;
  final Color titleTextColor;
  final Color contentTextColor;
  final bool canPop;

  PlatformAlertDialog({
    this.canPop = false,
    this.cancelActionText,
    @required this.title,
    @required this.content,
    @required this.defaultActionText,
    this.image,
    this.showPoints = false,
    this.backgroundColor,
    this.titleTextColor,
    this.contentTextColor,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            barrierDismissible: canPop,
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: canPop,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => canPop,
      child: CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              //Title
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'quicksand',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              //Show points
              showPoints
                  ? Text(
                      '+ ' + correctPoints.toString() + ' points',
                      style: TextStyle(
                        color: MaterialTheme.orange,
                        fontFamily: 'quicksand',
                        fontSize: 20,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        content: SingleChildScrollView(
          // Image
          child: Column(
            children: <Widget>[
              image ?? Container(),
              SizedBox(
                height: 20,
              ),
              // Content
              Text(
                content,
                style: TextStyle(
                    fontFamily: 'quicksand',
                    color: contentTextColor ?? Colors.grey.shade800),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: _buildActions(context),
      ),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => canPop,
      child: AlertDialog(
        scrollable: true,
        backgroundColor: backgroundColor ?? Colors.white,
        title: Center(
          child: Center(
            child: Column(
              children: [
                //Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'quicksand',
                      fontWeight: FontWeight.w600,
                      color: titleTextColor ?? Colors.black87),
                ),
                SizedBox(
                  height: 5,
                ),
                // Points
                showPoints
                    ? Text(
                        '+ ' + correctPoints.toString() + ' points',
                        style: TextStyle(
                          color: MaterialTheme.orange,
                          fontFamily: 'quicksand',
                          fontSize: 20,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              image ?? Container(),
              SizedBox(
                  height:
                      20), //If no image is displayed an empty container will take it's place.
//Content
              Text(
                content,
                style: TextStyle(
                    fontFamily: 'quicksand',
                    color: contentTextColor ?? Colors.grey.shade800),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: _buildActions(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(PlatformAlertDialogAction(
        child: Text(
          cancelActionText,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(false),
      ));
    }
    actions.add(PlatformAlertDialogAction(
      child: Text(
        defaultActionText,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: MaterialTheme.orange,
        ),
      ),
      onPressed: () => Navigator.of(context).pop(true),
    ));
    return actions;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;

  PlatformAlertDialogAction({this.child, this.onPressed});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
