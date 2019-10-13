import 'package:find_the_treasure/blocs/sign%20in/email_create_account_bloc.dart';
import 'package:find_the_treasure/models/email_sign_in_model.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets/platform_exception_alert_dialog.dart';
import 'package:flutter/services.dart';
import 'package:find_the_treasure/widgets/custom_list_view.dart';
import 'package:find_the_treasure/widgets/custom_text_field.dart';
import 'package:find_the_treasure/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailCreateAccountForm extends StatefulWidget {
  EmailCreateAccountForm({this.bloc});
  final EmailCreateAccountBloc bloc;
  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailCreateAccountBloc>(
      builder: (context) => EmailCreateAccountBloc(auth: auth),
      child: Consumer<EmailCreateAccountBloc>(
        builder: (context, bloc, _) => EmailCreateAccountForm(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.disose(),
    );
  }

  @override
  _EmailCreateAccountFormState createState() => _EmailCreateAccountFormState();
}

class _EmailCreateAccountFormState extends State<EmailCreateAccountForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final _newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_newFocus);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return CustomListView(
            children: <Widget>[
              _buildEmailTextField(model),
              _buildPasswordTextField(model),
              SizedBox(
                height: 20.0,
              ),
              _buildSignInButton(model)
            ],
          );
        });
  }

  SignInButton _buildSignInButton(EmailSignInModel model) {
    return SignInButton(
      text: 'Sign up',
      textcolor: Colors.white,
      color: Colors.orangeAccent,
      onPressed: model.canSubmit ? _submit : null,
    );
  }

  CustomTextField _buildPasswordTextField(EmailSignInModel model) {    
    return CustomTextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      labelText: 'Password',
      enabled: model.isLoading == false,
      onEditingComplete: _submit,
      onChanged: (password) => widget.bloc.updateWith(password: password),
      errorText: model.passwordErrorText,
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }

  CustomTextField _buildEmailTextField(EmailSignInModel model) {    
    return CustomTextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      labelText: 'Email',
      enabled: model.isLoading == false,
      errorText: model.emailErrorText,
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: (email) => widget.bloc.updateWith(email: email),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
  }
}
