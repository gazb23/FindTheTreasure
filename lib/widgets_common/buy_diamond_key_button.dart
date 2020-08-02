import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/custom_raised_button.dart';
import 'package:flutter/material.dart';

class BuyDiamondOrKeyButton extends StatelessWidget {
  final String numberOfDiamonds;
  final String diamondCost;
  final String bonusKey;
  final Color textColor;
  final double diamondTextSize;
  final double costTextSize;
  final VoidCallback onPressed;
  final bool isPurchasePending;

  const BuyDiamondOrKeyButton({
    Key key,
    @required this.numberOfDiamonds,
    @required this.diamondCost,
    @required this.onPressed,
    this.textColor,
    this.bonusKey,
    this.diamondTextSize = 30,
    this.costTextSize = 15, this.isPurchasePending,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return     
    Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height/14,
      child: CustomRaisedButton(
        color: MaterialTheme.orange,
        padding: 10,
        
        onPressed: isPurchasePending ? null : onPressed,
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'images/diamond2.png',
                      height: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: AutoSizeText(
                        numberOfDiamonds,
                        maxLines: 1,
                        style: TextStyle(
                            color: textColor ?? Colors.white,
                            fontSize: diamondTextSize,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                
                child: 
                bonusKey == '0' ? Container() : 
                Row(
                  children: <Widget>[
                    Text(
                      '+$bonusKey',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    Image.asset(
                      'images/skull_key_outline.png',
                      height: 30,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.shade700),
                  child: Text(
                    diamondCost,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: costTextSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
