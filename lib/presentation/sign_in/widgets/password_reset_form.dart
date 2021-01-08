import 'package:find_the_treasure/blocs/sign_in/password_reset_bloc.dart';
import 'package:find_the_treasure/models/password_reset_model.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/platform_exception_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:find_the_treasure/widgets_common/custom_list_view.dart';
import 'package:find_the_treasure/widgets_common/custom_text_field.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordResetForm extends StatefulWidget {
  final PasswordResetBloc bloc;
  PasswordResetForm({this.bloc});

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<PasswordResetBloc>(
      create: (context) => PasswordResetBloc(auth: auth),
      child: Consumer<PasswordResetBloc>(
        builder: (context, bloc, _) => PasswordResetForm(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<PasswordResetForm> {
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();

  void _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Reset Password Failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PasswordResetModel>(
        stream: widget.bloc.modelStream,
        initialData: PasswordResetModel(),
        builder: (context, snapshot) {
          final PasswordResetModel model = snapshot.data;
          return CustomListView(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'images/ic_owl_wrong_dialog.png',
                  height: 120.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'If you\'ve forgotten your password already, good luck with the quests! No sweat - just enter your email below and we\'ll reset it.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.0,
              ),
              _buildEmailTextField(model),
              SizedBox(
                height: 20.0,
              ),
              _buildSignInButton(model),
              SizedBox(
                height: 10.0,
              ),
            ],
          );
        });
  }

  CustomTextField _buildEmailTextField(PasswordResetModel model) {
    return CustomTextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      labelText: 'Email',
      enabled: model.isLoading == false,
      errorText: model.emailErrorText,
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: model.canSubmit ? _submit : null,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildSignInButton(PasswordResetModel model) {
    return SignInButton(
        isLoading: model.isLoading,
        text: 'Reset Password',
        textcolor: Colors.white,
        color: MaterialTheme.orange,
        onPressed: model.canSubmit ? _submit : null,
      );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
  }
}
