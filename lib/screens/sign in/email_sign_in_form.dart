import 'package:find_the_treasure/screens/sign%20in/password_reset.dart';
import 'package:find_the_treasure/screens/sign%20in/validators.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets/custom_list_view.dart';
import 'package:find_the_treasure/widgets/custom_text_field.dart';
import 'package:find_the_treasure/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {  
  EmailSignInForm({this.auth});
  final AuthBase auth;
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;

  void _submit() async {
    setState(() {
     _submitted = true; 
    });
    try {      
      await widget.auth.signInWithEmailAndPassword(_email, _password);
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    bool submitEnabled = widget.emailValidator.isValid(_email) && widget.passwordValidator.isValid(_password);
    return CustomListView(
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            _buildEmailTextField(),
            _buildPasswordTextField(),
            SizedBox(
              height: 20.0,
            ),
            SignInButton(
              text: 'Sign in',
              textcolor: Colors.white,
              color: Colors.orangeAccent,
              onPressed: submitEnabled ? _submit : null,
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

  CustomTextField _buildPasswordTextField() {
    bool showErrorText = _submitted && !widget.passwordValidator.isValid(_password);
    return CustomTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            labelText: 'Password',
            onEditingComplete: _submit,
            obscureText: true,
            onChanged: (password) => _callSetState(),
            errorText: showErrorText ? widget.invalidPasswordErrorText : null,
            textInputAction: TextInputAction.done,
          );
  }

  CustomTextField _buildEmailTextField() {
     bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return CustomTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            labelText: 'Email',
            onEditingComplete: _emailEditingComplete,
            onChanged: (email) => _callSetState(),
            errorText: showErrorText ? widget.invalidEmailErrorText : null,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            
          );
  }
   void _callSetState() {
    setState(() {});
  }
}
