import 'package:find_the_treasure/theme.dart';
import 'package:flutter/material.dart';

class DiamondAndKeyContainer extends StatelessWidget {
  final double diamondHeight;
  final double skullKeyHeight;
  final double spaceBetween;
  final double fontSize;
  final FontWeight fontWeight;
  final int numberOfDiamonds;
  final int numberOfKeys;
  final MainAxisAlignment mainAxisAlignment;
  final Color color;
  final bool showDiamond;
  final bool showKey;
  final bool diamondSpinning;

  DiamondAndKeyContainer({
    this.diamondHeight,
    this.skullKeyHeight,
    this.spaceBetween = 5,
    this.numberOfDiamonds,
    this.numberOfKeys,
    this.mainAxisAlignment,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.showDiamond = true,
    this.showKey = true,
    this.diamondSpinning = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.end,
        children: <Widget>[
          showDiamond
              ? Container(
                  child: Row(
                    children: <Widget>[
                      diamondSpinning
                          ? Opacity(
                            opacity: 0.7,
                                                      child: Image.asset(
                                'images/spinning_diamond.gif',
                                height: diamondHeight ?? 20,
                              ),
                          )
                          : Opacity(
                            opacity: 0.7,
                                                      child: Image.asset('images/diamond2.png',
                                height: diamondHeight ?? 30),
                          ),
                      SizedBox(
                        width: 5,
                      ),
                      numberOfDiamonds != null
                          ? Text(
                              numberOfDiamonds.toString(),
                              style: TextStyle(
                                  color: color ?? Colors.white,
                                  fontSize: fontSize ?? 13,
                                  fontWeight: fontWeight),
                            )
                          : CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  MaterialTheme.blue.withOpacity(0.5)),
                            )
                    ],
                  ),
                )
              : Container(),
          SizedBox(
            width: spaceBetween,
          ),
          showKey
              ? Container(
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'images/skull_key_outline.png',
                        height: skullKeyHeight ?? 30.0,
                      ),
                      numberOfKeys != null
                          ? Text(
                              numberOfKeys.toString(),
                              style: TextStyle(
                                  color: color ?? Colors.white,
                                  fontSize: fontSize ?? 13,
                                  fontWeight: fontWeight),
                            )
                          : CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  MaterialTheme.blue.withOpacity(0.5)))
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
