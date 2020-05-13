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
  final Color color;
  final bool showDiamond;
  final bool showKey;
  

  DiamondAndKeyContainer(
    {this.diamondHeight,
    this.skullKeyHeight,
    this.spaceBetween = 5,
    this.numberOfDiamonds,
    this.numberOfKeys, this.mainAxisAlignment, this.fontSize, this.fontWeight, this.color, this.showDiamond = true, this.showKey = true }
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.end,
        children: <Widget>[
          showDiamond ? Container(
            
            child: Row(
              
              children: <Widget>[
                Image.asset(
                  'images/2.0x/ic_diamond.png',
                  height: diamondHeight ?? 20,
                ),
                SizedBox(
                  width: 10,
                ),
                
                Text(
                  numberOfDiamonds.toString(),
                  style: TextStyle(color: color ?? Colors.white, fontSize: fontSize ?? 13, fontWeight: fontWeight),
                ),
              ],
            ),
          ) : Container(),
          SizedBox(
            width: spaceBetween,
          ),
          showKey ? Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/skull_key_outline.png',
                  height: skullKeyHeight ?? 30.0,
                ),
                Text(
                  numberOfKeys.toString(),
                  style: TextStyle(color: color ?? Colors.white, fontSize: fontSize ?? 13, fontWeight: fontWeight),
                ),
              ],
            ),
          ) : Container(),
        ],
      ),
    );
  }

}





