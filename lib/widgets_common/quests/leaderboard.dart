import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/widgets_common/avatar.dart';
import 'package:flutter/material.dart';

class LeaderBoardTile extends StatelessWidget {
  final int place;
  final String photoURL;
  final String displayName;
  final int points;
  final VoidCallback onTap;
  const LeaderBoardTile({
    @required this.place,
    @required this.photoURL,
    @required this.displayName,
    @required this.points,
    this.onTap,
  })  : assert(place != null),
        assert(displayName != null),
        assert(points != null),
        assert(onTap != null);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: podiumColor(),
      margin: EdgeInsets.symmetric(horizontal: 10),
      color: place == 1 || place == 2 || place == 3 ? null : _placeColor(),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (place < 10)
                Text(
                  '0' + place.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: place == 1 || place == 2 || place == 3 ? Colors.white.withOpacity(0.8) : Colors.black54,
                  ),
                ),
              if (place >= 10)
                AutoSizeText(
                  place.toString(),
                  maxLines: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              Avatar(
                borderColor: place == 1 || place == 2 || place == 3
                    ? Colors.black
                    : Colors.black38,
                borderWidth: 1,
                radius: 20,
                photoURL: photoURL,
              )
            ],
          ),
        ),
        title: AutoSizeText(
          displayName,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          points.toString(),
          style: TextStyle(
              color: Colors.black87,
              fontWeight: place == 1 || place == 2 || place == 3
                  ? FontWeight.bold
                  : null),
        ),
      ),
    );
  }

  Color _placeColor() {
    if (place > 3 && place.isOdd) {
      return Colors.grey.shade100;
    }
    return Colors.white;
  }

  BoxDecoration podiumColor() {
    if (place == 1) {
      return BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
            Colors.amber[600],
            Colors.amberAccent,
          ]));
    } else if (place == 2) {
      return BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
            Colors.blueGrey.shade400,
            Colors.blueGrey.shade100,
          ]));
    } else if (place == 3) {
      return BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
            Colors.brown,
            Colors.brown.shade300,
          ]));
    } else
      return null;
  }
}
