import 'package:find_the_treasure/blocs/sign_in/email_sign_in_bloc.dart';
import 'package:find_the_treasure/models/email_sign_in_model.dart';
import 'package:find_the_treasure/presentation/sign_in/screens/password_reset_screen.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/platform_exception_alert_dialog.dart';
import 'package:flutter/services.dart';
import 'package:find_the_treasure/widgets_common/custom_list_view.dart';
import 'package:find_the_treasure/widgets_common/custom_text_field.dart';
import 'package:find_the_treasure/widgets_common/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSignInForm extends StatefulWidget {
  final EmailSignInBloc bloc;
  EmailSignInForm({this.bloc});

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInForm(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  void _submit() async {
    try {
      await widget.bloc.submit();
      // Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final _newFocus = !model.emailIsEmptyValidator.isValid(model.email) && model.emailStringValidator.isValid(model.email)
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
              _buildSignInButton(model),
              FlatButton(
                shape: StadiumBorder(),
                onPressed: () {
                  Navigator.pushNamed(context, PasswordResetScreen.id);
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
      onChanged: widget.bloc.updateEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
       suffixIcon: IconButton(
                          enableFeedback: true,
                          icon: Icon(
                            Icons.clear,
                            color: MaterialTheme.orange,
                          ),
                          onPressed: () {
                            Future.delayed(Duration(milliseconds: 50))
                                .then((_) {
                              _emailController.clear();
                            });
                          })
    );
  }

  CustomTextField _buildPasswordTextField(EmailSignInModel model) {
    return CustomTextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      labelText: 'Password (6+ characters)',
      enabled: model.isLoading == false,
      onEditingComplete: model.canSubmit ? _submit : null,
      onChanged: widget.bloc.updatePassword,
      errorText: model.passwordErrorText,
      obscureText: _obscureText,
      suffixIcon: IconButton(
                      icon: Icon(
                        
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: MaterialTheme.orange,
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
      text: 'Sign in',
      textcolor: Colors.white,
      color: MaterialTheme.orange,
      onPressed: model.canSubmit ? _submit : null,
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
