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
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 10),
      color: _placeColor(),
      child: ListTile(

        onTap: onTap,
        leading: Container(
          width: 85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                '0' + place.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              SizedBox(width: 15),
              Avatar(
                borderColor: Colors.black38,
                borderWidth: 1,
                radius: 20,
                photoURL: photoURL,
              )
            ],
          ),
        ),
        title: Text(
          displayName,
          
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          points.toString(),
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }

  Color _placeColor() {
    if (place == 1) {
      return Colors.amberAccent;
    } else if (place == 2) {
      return Colors.blueGrey.shade100;
    } else if (place == 3) {
      return Colors.brown.shade300;
    } else if (place > 3 && place.isOdd) {
      return Colors.grey.shade100;
    }
    return Colors.white;
  }
}
