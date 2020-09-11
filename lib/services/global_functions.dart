import 'dart:math';

class GlobalFunction {
  static Future<void> delayBy({int minTime, int maxTime}) async {
    Random random = Random();
    int randomNumber = random.nextInt(maxTime ??= 250) + (minTime ??= 50);
    await Future.delayed(Duration(milliseconds: randomNumber));
  }
}
