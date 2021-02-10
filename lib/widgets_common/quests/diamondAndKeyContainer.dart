import 'package:find_the_treasure/presentation/Shop/screens/shop_screen.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/animated_counter.dart';
import 'package:flutter/material.dart';

class ShopButton extends StatelessWidget {
  final double diamondHeight;
  // final double skullKeyHeight;
  // final double spaceBetween;
  final double fontSize;
  final FontWeight fontWeight;
  final int numberOfDiamonds;
  // final int numberOfKeys;
  final MainAxisAlignment mainAxisAlignment;
  final Color color;
  final bool showDiamond;
  // final bool showKey;
  final bool diamondSpinning;
  final bool showShop;
  ShopButton({
    this.diamondHeight,
    // this.skullKeyHeight,
    // this.spaceBetween = 5,
    this.numberOfDiamonds,
    // this.numberOfKeys,
    this.mainAxisAlignment,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.showDiamond = true,
    // this.showKey = true,
    this.diamondSpinning = false, this.showShop = true,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showShop ?() {
        Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => ShopScreen(),
            ));
      } : null,
      child: Container(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
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
                        const SizedBox(
                          width: 5,
                        ),
                        numberOfDiamonds != null ?
                          AnimatedCount(count: numberOfDiamonds, duration: Duration(seconds: 2), textStyle: TextStyle(
                                    color: color ?? Colors.white,
                                    fontSize: fontSize ?? 13,
                                    fontWeight: fontWeight),)


                          
                            : CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    MaterialTheme.blue.withOpacity(0.5)),
                              )
                      ],
                    ),
                  )
                : Container(),
           
           
          ],
        ),
      ),
    );
  }
}
