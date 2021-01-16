import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:flutter/material.dart';

class UserProfileListTile extends StatelessWidget {
  final String image;
  final double imageHeight;
  final String title;
  final int number;

  const UserProfileListTile(
      {Key key,
      @required this.image,
      this.imageHeight,
      @required this.title,
      @required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      leading: Opacity(
        opacity: 0.8,
        child: Image.asset(
          image,
          height: imageHeight,

        ),
      ),
      title: AutoSizeText(
        title,
        maxLines: 1,
        
        style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      trailing: Container(
        child: Text(
          '${number.toString()}',
        style: TextStyle(
          color: MaterialTheme.orange,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          
        ),
        ),
      ),
    );
  }
}
