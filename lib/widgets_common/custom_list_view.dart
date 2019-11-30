import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {

  final List<Widget> children;
  final Color color;
  CustomListView({this.children, this.color});
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 25.0),
          children: <Widget>[
            Center(
              child: Card(
                color: color ?? Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 1.0,
                child: FractionallySizedBox(
                  widthFactor: 0.95,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

  }
  
}

