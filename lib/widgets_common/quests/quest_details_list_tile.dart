import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuestDetailsListTile extends StatelessWidget {
  final String image;
  final String difficulty;
  final double imageHeight;
  final BuildContext context;

  QuestDetailsListTile({
    Key key,
    @required this.image,
    @required this.imageHeight,
    @required this.difficulty,
    @required this.context,
  }) : super(key: key);

  Widget _questDifficulty(String difficulty) {
    double width = MediaQuery.of(context).size.width / 2;
    Color color = Colors.grey.shade400;
    switch (difficulty) {
      case 'Easy':
        return LinearPercentIndicator(
          width: width,
          lineHeight: 15,
          percent: 0.33,
          progressColor: Colors.green,
          backgroundColor: color,
        );
        break;
      case 'Moderate':
        return LinearPercentIndicator(
          width: width,
          lineHeight: 15,
          percent: 0.66,
          progressColor: Colors.orangeAccent,
          backgroundColor: color,
        );
        break;
      case 'Hard':
        return LinearPercentIndicator(
          width: width,
          lineHeight: 15,
          percent: 1,
          progressColor: Colors.redAccent,
          backgroundColor: color,
        );
      default:
        return LinearPercentIndicator(
          width: width,
          lineHeight: 15,
          percent: 0.33,
          progressColor: Colors.green,
          backgroundColor: color,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        image,
        height: imageHeight,
      ),
      title: _questDifficulty(difficulty),
    );
  }
}
