import 'package:find_the_treasure/blocs/sign_in/email_create_account_bloc.dart';
import 'package:find_the_treasure/models/email_sign_in_model.dart';
import 'package:find_the_treasure/services/auth.dart';

import 'package:find_the_treasure/widgets_common/platform_exception_alert_dialog.dart';
import 'package:flutter/services.dart';
import 'package:find_the_treasure/widgets_common/custom_list_view.dart';
import 'package:find_the_treasure/widgets_common/custom_text_field.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailCreateAccountForm extends StatefulWidget {
  EmailCreateAccountForm({@required this.bloc});
  final EmailCreateAccountBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailCreateAccountBloc>(
      create: (context) => EmailCreateAccountBloc(auth: auth),
      child: Consumer<EmailCreateAccountBloc>(
        builder: (context, bloc, _) => EmailCreateAccountForm(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
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
  bool _obscureText = true;

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL')
        _showDuplicateAccountSignInError(context, e);
      else
        PlatformExceptionAlertDialog(
          title: 'Sign up failed',
          exception: e,
        ).show(context);
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign up failed',
        exception: e,
      ).show(context);
      print(e.toString());
    }
  }

  void _showDuplicateAccountSignInError(
      BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final _newFocus = !model.emailIsEmptyValidator.isValid(model.email) &&
            model.emailStringValidator.isValid(model.email)
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
        suffixIcon: IconButton(
            enableFeedback: true,
            icon: Icon(
              Icons.clear,
              color: Colors.orangeAccent,
            ),
            onPressed: () {
              Future.delayed(Duration(milliseconds: 50)).then((_) {
                _emailController.clear();
              });
            }));
  }

  CustomTextField _buildPasswordTextField(EmailSignInModel model) {
    return CustomTextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      labelText: 'Password (6+ characters)',
      enabled: model.isLoading == false,
      onEditingComplete: model.canSubmit ? _submit : null,
      onChanged: (password) => widget.bloc.updateWith(password: password),
      errorText: model.passwordErrorText,
      obscureText: _obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.orangeAccent,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
      textInputAction: TextInputAction.done,
    );
  }

  SignInButton _buildSignInButton(EmailSignInModel model) {
    return SignInButton(
        isLoading: model.isLoading,
        text: 'Sign up',
        textcolor: Colors.white,
        color: Colors.orangeAccent,
        onPressed: model.canSubmit ? _submit : null);
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
