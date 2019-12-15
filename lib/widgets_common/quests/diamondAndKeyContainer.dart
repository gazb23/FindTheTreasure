import 'package:flutter/material.dart';


class  DiamondAndKeyContainer extends StatelessWidget {

final double diamondHeight;
  final double skullKeyHeight;
  final double spaceBetween;
  final double fontSize;
  final FontWeight fontWeight;
  final int numberOfDiamonds;  
  final int numberOfKeys;
  final MainAxisAlignment mainAxisAlignment;
  

  DiamondAndKeyContainer(
    {this.diamondHeight,
    this.skullKeyHeight,
    this.spaceBetween,
    this.numberOfDiamonds,
    this.numberOfKeys, this.mainAxisAlignment, this.fontSize, this.fontWeight, }
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/3.0x/ic_diamond.png',
                  height: diamondHeight ?? 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  numberOfDiamonds.toString(),
                  style: TextStyle(color: Colors.white, fontSize: fontSize ?? 13, fontWeight: fontWeight),
                ),
              ],
            ),
          ),
          SizedBox(
            width: spaceBetween,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/explore/skull_key.png',
                  height: skullKeyHeight ?? 30.0,
                ),
                Text(
                  numberOfKeys.toString(),
                  style: TextStyle(color: Colors.white, fontSize: fontSize ?? 13, fontWeight: fontWeight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





