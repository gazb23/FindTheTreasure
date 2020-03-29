import 'package:find_the_treasure/widgets_common/custom_raised_button.dart';
import 'package:flutter/material.dart';

class BuyDiamondOrKeyButton extends StatelessWidget {
  final String numberOfDiamonds;
  final String diamondCost;
  final Color textColor;
  final double textSize;

  const BuyDiamondOrKeyButton({
    Key key,
    this.numberOfDiamonds,
    this.diamondCost, this.textColor, this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: CustomRaisedButton(
        padding: 15,
        onPressed: () {},
        child: FractionallySizedBox(
          widthFactor: .9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(numberOfDiamonds, style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: textSize
                  ),),
                  SizedBox(width: 15),
                  Image.asset('images/2.0x/ic_diamond.png', height: 25,),
                ],
              ),
              SizedBox(width: 20),
              Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Buy For',style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: textSize
                  ),),
                  SizedBox(width: 8),
                  Text('\$' + diamondCost, style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: textSize,
                  ),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
