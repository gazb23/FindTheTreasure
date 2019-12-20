import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuestDetailsListTile extends StatelessWidget {
  final String image;
  final String difficulty;
  final double imageHeight;

  QuestDetailsListTile({
    Key key,
    this.image,
    this.imageHeight,
    this.difficulty,
  }) : super(key: key);

  Widget _questDifficulty(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return LinearPercentIndicator(
          width: double.infinity,
          lineHeight: 15,
          percent: 0.33,
          progressColor: Colors.green,
          backgroundColor: Colors.grey.shade400,
        );
        break;
      case 'Moderate':
        return LinearPercentIndicator(
          width: double.infinity,
          lineHeight: 15,
          percent: 0.66,
          progressColor: Colors.orangeAccent,
          backgroundColor: Colors.grey.shade400,
        );
        break;
      case 'Hard':
        return LinearPercentIndicator(
          width: double.infinity,
          lineHeight: 15,
          percent: 1,
          progressColor: Colors.redAccent,
          backgroundColor: Colors.grey.shade400,
        );
      default:
        return LinearPercentIndicator(
          width: double.infinity,
          lineHeight: 15,
          percent: 0.33,
          progressColor: Colors.green,
          backgroundColor: Colors.grey.shade400,
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
