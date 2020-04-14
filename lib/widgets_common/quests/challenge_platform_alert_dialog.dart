import 'dart:io';
import 'package:find_the_treasure/widgets_common/platform_widget.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChallengePlatformAlertDialog extends PlatformWidget {
  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;
  final Color textColor;
  final Color backgroundColor;
  final Widget image;
  final bool isLoading;
 

  ChallengePlatformAlertDialog({
    this.cancelActionText,
    this.backgroundColor, 
    this.textColor, 
    @required this.title,
    @required this.content,
    @required this.defaultActionText,
    this.image,  
    this.isLoading, 
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
          child: CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'quicksand',
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.black87
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              image ?? Container(),
              SizedBox(
                height: 20,
              ),
              Text(
                content,
                style: TextStyle(
                  fontFamily: 'quicksand',
                  fontSize: 18,
                  color: textColor ?? Colors.black87
                ),
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
      onWillPop: () async => false,
          child: AlertDialog(
        
        backgroundColor: backgroundColor ?? Colors.white,
        title: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'quicksand',
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.black87
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

              Text(
                content,
                style: TextStyle(
                  fontFamily: 'quicksand',
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Colors.black87
                ),
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
        child: 
        Platform.isIOS ? Text(cancelActionText,) :
        SignInButton(   
             
        text: cancelActionText,
        color: Colors.grey,
        
        onPressed: () => Navigator.of(context).pop(false),
      ),
        // onPressed: () => Navigator.of(context).pop(false),
      ));
    }
    actions.add(PlatformAlertDialogAction(
      child: 
      Platform.isIOS ? Text(defaultActionText) :
      SignInButton(
        text: defaultActionText,
        onPressed: () => Navigator.of(context).pop(true),
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
