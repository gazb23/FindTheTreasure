import 'package:find_the_treasure/theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';

class QuestDetailsListTile extends StatelessWidget {
  final String image;
  final String difficulty;
  final double imageHeight;
  final String platformTitle;
  final String platformContent;
  final Widget platformImage;
  final BuildContext context;

  QuestDetailsListTile({
    Key key,
    @required this.image,
    @required this.imageHeight,
    @required this.difficulty,
    @required this.context,
    @required this.platformTitle,
    @required this.platformContent,
    this.platformImage,
  }) : super(key: key);

  Widget _questDifficulty(String difficulty) {
    double width = MediaQuery.of(context).size.width / 2;
    Color color = Colors.grey.shade400;
    switch (difficulty) {
      case 'Easy':
        return LinearPercentIndicator(
          animation: true,
          animationDuration: 800,
          width: width,
          lineHeight: 15,
          percent: 0.33,
          progressColor: Colors.green,
          backgroundColor: color,
        );
        break;
      case 'Moderate':
        return LinearPercentIndicator(
          animation: true,
          animationDuration: 800,
          width: width,
          lineHeight: 15,
          percent: 0.66,
          progressColor: MaterialTheme.orange,
          backgroundColor: color,
        );
        break;
      case 'Hard':
        return LinearPercentIndicator(
          animation: true,
          animationDuration: 800,
          width: width,
          lineHeight: 15,
          percent: 1,
          progressColor: MaterialTheme.red,
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
    return InkWell(
      
      onTap:  () {
          PlatformAlertDialog(
            title: platformTitle,
            content: platformContent,
            image: platformImage,
            defaultActionText: 'OK',
          ).show(context);
        },
          child: ListTile(
        leading: Image.asset(
          image,
          height: imageHeight,
        ),
        title: _questDifficulty(difficulty),
      ),
    );
  }
}
