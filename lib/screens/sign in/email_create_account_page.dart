import 'package:find_the_treasure/widgets/custom_list_view.dart';
import 'package:find_the_treasure/widgets/custom_text_field.dart';
import 'package:find_the_treasure/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  static const String id = 'create_account';

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submit() {
    print('email: ${_emailController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _buildStack(),
    );
  }

  Widget _buildStack() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bckgrnd.png"), fit: BoxFit.cover),
          ),
        ),
        CustomListView(
          children: <Widget>[
            CustomTextField(
              controller: _firstNameController,
              labelText: 'First Name',
            ),
            CustomTextField(
              controller: _lastNameController,
              labelText: 'Last Name',
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
                text: 'Sign up',
                textcolor: Colors.white,
                color: Colors.orangeAccent,
                onPressed: _submit)
          ],
        )
      ],
    );
  }
}
