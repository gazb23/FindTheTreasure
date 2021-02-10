import 'dart:math';

import 'package:intl/intl.dart';

class GlobalFunction {
  static Future<void> delayBy({int minTime, int maxTime}) async {
    Random random = Random();
    int randomNumber = random.nextInt(maxTime ??= 250) + (minTime ??= 50);
    await Future.delayed(Duration(milliseconds: randomNumber));
  }

   // String Plurals for diamond/s
  static diamondPluralCount(int howMany) =>
      Intl.plural(howMany, one: 'diamond', other: 'diamonds');
}
