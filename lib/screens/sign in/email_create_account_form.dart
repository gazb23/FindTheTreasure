import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets/custom_list_view.dart';
import 'package:find_the_treasure/widgets/custom_text_field.dart';
import 'package:find_the_treasure/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';

class EmailCreateAccountForm extends StatefulWidget {  
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

  @override
  Widget build(BuildContext context) {
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
          text: 'Sign up',
          textcolor: Colors.white,
          color: Colors.orangeAccent,
          onPressed: _submit,
        )
      ],
    );
  }
}
