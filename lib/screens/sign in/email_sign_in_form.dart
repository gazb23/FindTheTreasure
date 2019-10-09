import 'package:find_the_treasure/screens/sign%20in/password_reset.dart';
import 'package:find_the_treasure/screens/sign%20in/validators.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets/platform_exception_alert_dialog.dart';

import 'package:flutter/services.dart';
import 'package:find_the_treasure/widgets/custom_list_view.dart';
import 'package:find_the_treasure/widgets/custom_text_field.dart';
import 'package:find_the_treasure/widgets/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {  

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
  bool _isLoading = false;

  void _submit() async {
    setState(() {
     _submitted = true; 
     _isLoading = true;
    });
    try {      
      final auth = Provider.of<AuthBase>(context);
      await auth.signInWithEmailAndPassword(_email, _password);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,        
      ).show(context);
    } finally {
      setState(() {
       _isLoading = false; 
      });
    }
  }

  void _emailEditingComplete() {
    final _newFocus = widget.emailValidator.isValid(_email)
    ? _passwordFocusNode
    : _emailFocusNode;
    FocusScope.of(context).requestFocus(_newFocus);
  }

  @override
  Widget build(BuildContext context) {
    bool submitEnabled = widget.emailValidator.isValid(_email) && widget.passwordValidator.isValid(_password) && !_isLoading;
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
            enabled: _isLoading == false,
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
            enabled: _isLoading == false,
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
  @override
  void dispose() {
    
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
  }
}
