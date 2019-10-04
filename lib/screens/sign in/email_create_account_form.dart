import 'package:find_the_treasure/screens/sign%20in/validators.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets/custom_list_view.dart';
import 'package:find_the_treasure/widgets/custom_text_field.dart';
import 'package:find_the_treasure/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';

class EmailCreateAccountForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailCreateAccountForm({this.auth});

  final AuthBase auth;
  @override
  _EmailCreateAccountFormState createState() => _EmailCreateAccountFormState();
}

class _EmailCreateAccountFormState extends State<EmailCreateAccountForm> {
  // final TextEditingController _firstNameController = TextEditingController();
  // final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  
  void _submit() async {
    try {
      await widget.auth.createUserWithEmailAndPassword(_email, _password);
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
        //TODO: Find out how to add Firt Name and Last name to Firebase login
        // CustomTextField(
        //   controller: _firstNameController,
        //   labelText: 'First Name',
        // ),
        // CustomTextField(
        //   controller: _lastNameController,
        //   labelText: 'Last Name',
        // ),
        _buildEmailTextField(),
        _buildPasswordTextField(),
        SizedBox(
          height: 20.0,
        ),
        SignInButton(
          text: 'Sign up',
          textcolor: Colors.white,
          color: Colors.orangeAccent,
          onPressed: submitEnabled ? _submit : null,
        )
      ],
    );
  }

  CustomTextField _buildPasswordTextField() {
    return CustomTextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      labelText: 'Password',
      onEditingComplete: _submit,
      
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }

  CustomTextField _buildEmailTextField() {
    return CustomTextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      labelText: 'Email',
      onEditingComplete: _emailEditingComplete,
      
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  
  
}
