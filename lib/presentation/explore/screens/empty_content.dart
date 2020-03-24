import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String message;
  final Image image;
  final String buttonText;
  final VoidCallback onPressed;
  final bool buttonEnabled;

  const EmptyContent(
      {Key key,
      this.title = 'No Quests Currently Available',
      this.message = 'New Quests coming soon!', this.image, this.buttonText = 'OK', this.onPressed, this.buttonEnabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headline,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            image ?? Image.asset('images/ic_excalibur_owl.png'),
            SizedBox(
              height: 15,
            ),
            Text(
              message,
              style: Theme.of(context).textTheme.body1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            buttonEnabled ? SignInButton(text: buttonText,
            onPressed: onPressed,
            color: Colors.orangeAccent,
            ) : Container()
          ],
        ),
      ),
    );
  }
}
