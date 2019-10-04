import 'package:find_the_treasure/screens/sign%20in/password_reset.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets/custom_list_view.dart';
import 'package:find_the_treasure/widgets/custom_text_field.dart';
import 'package:find_the_treasure/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';

class EmailSignInForm extends StatefulWidget {  
  EmailSignInForm({this.auth});
  final AuthBase auth;
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  void _submit() async {
    try {      
      await widget.auth.signInWithEmailAndPassword(_email, _password);
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomListView(
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            SignInButton(
              text: 'Sign in',
              textcolor: Colors.white,
              color: Colors.orangeAccent,
              onPressed: _submit
            ),
            
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, PasswordReset.id);
              },
              child: Text(
                'Forgotten Password?',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        );
  }
}
